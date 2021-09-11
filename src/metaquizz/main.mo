import HashMap "mo:base/HashMap";
import Hash "mo:base/Hash";
import Nat "mo:base/Nat";
import Array "mo:base/Array";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Iter "mo:base/Iter";
import Option "mo:base/Option";

import Metascore "mo:metascore/Metascore";

shared ({ caller = owner }) actor class Metagame() : async Metascore.GameInterface = self {

  
    // Use this to call Metascore's methods. That principal is Metascore's staging canister on Mainnet.

    //To change in prod! 
    let metascore : Metascore.MetascoreInterface = actor("rdmx6-jaaaa-aaaaa-aaadq-cai");


    //For Metascore integration you need to present your players like that 
    public type Player = {
        #stoic : Principal;
        #plug : Principal;
    };

    func _playerEqual (a : Player, b : Player) : Bool {
         switch (a, b) {
            case (#stoic(a), #stoic(b)) { Principal.equal(a, b); };
            case (#plug(a) , #plug(b) ) { Principal.equal(a, b); };
            case (_) { false; };
        };
    };

   func _playerHash (player : Player) : Hash.Hash {
        switch (player) {
            case (#stoic(principal)) { Principal.hash(principal); };
            case (#plug(principal))  { Principal.hash(principal); };
        };
    };

    func _playerPrincipal (player  :  Player) : Principal {
        switch (player) {
            case (#stoic(principal)) { principal };
            case (#plug(principal))  { principal };
        };
    };
    func _playerPrincipalToText(player : Player) : Text {
        switch (player) {
            case (#stoic(principal)) { Principal.toText(principal); };
            case (#plug(principal))  { Principal.toText(principal); };
        };
    };


    public type PlayerInfo = {
        name : Text;
        // You can add more infos : avatar, role, email , score .... 
    };

    stable var playersEntries :  [(Player,PlayerInfo)] = [];
    let players : HashMap.HashMap<Player,PlayerInfo> = HashMap.fromIter(playersEntries.vals(),0, _playerEqual,_playerHash);


    // Your canister is responsible for storing its own full list of scores.
    // Metascore will only store the highest score for each player.
    public type Score = (Player,Nat); 

    stable var scores : [Metascore.Score] = [];

    // REQUIRED function to integrate with Metascore.
    // Metascore will call this method upon registration and around once per day.
    public query func metascoreScores() : async [Metascore.Score] {
        scores;
    };

    // REQUIRED function to integrate with Metascore.
    // Metascore will call this function when registering your canister, or when requesting updated metadata.
    public shared func metascoreRegisterSelf(callback : Metascore.RegisterCallback) : async () {
        await callback({
            name = "Motoko School : quizz 2";
        });
    };

    // A function we can use to register our game in metascore 
    public func register () : async Result.Result<(), Text> {
        await metascore.register(Principal.fromActor(self));
    };

    //A function to register a new score to metascore.

    func _newScore (player : Player, score : Nat) : () {
        let newScore : Metascore.Score = (player, score);

        // Store your score in your own canister.
        scores := Array.append(scores, [newScore]);
        return;

        // When a new high score for a player happens, you should push that to Metascore.
        // This will ensure that your game is up-to-date in our canisters.
        // NOTE: Metascore does not implement this method yet
        // await metascore.scoreUpdate([newScore]);
    };

    public type PlayerRegister = {
        player : Player;
        name : Text; 
        //You can add more infos
    };    

    public type PlayerRegisterResponse = Result.Result<(), {
        #AlreadyExist;
        #Unknown;
    }>;

    public type PlayerInfosResponse = Result.Result<(Text),{
        #NotFound;
        #Unknown;
    }>;

    public shared (msg) func addPlayer (registration : PlayerRegister) : async PlayerRegisterResponse {

        let principal : Principal = _playerPrincipal(registration.player);
        assert(msg.caller == principal);
        switch(players.get(registration.player)) {
            case (?player) return #err (#AlreadyExist);
            case (null) {
                let infos : PlayerInfo = {
                    name = registration.name;
                };

                players.put(registration.player,infos);
                return #ok;
            }
        };
        return #err (#Unknown);
    };

    public shared (msg) func getInfosOfPlayer (player : Player) : async PlayerInfosResponse {
        let principal : Principal = _playerPrincipal(player);
        assert(msg.caller == principal); 

        switch (players.get(player)) {
            case (null) return #err (#NotFound);
            case (?infos) return #ok (infos.name);
        }

    };

    public func testPlayer (player  : Player) : async Bool {
        return true
    };

    public func testBasic () : async Bool {
        return true
    };


    //Internal logic of my canister 

    public type questionID = Nat;
    public type quizzID = Nat;

    public type Quizz = {
        quizzID : Nat;
        title : Text;
        creator : Principal;
        questions : [questionID]; // 
        description : Text;
    };

    public type Question = {
        questionID : Nat;
        question: Text;
        answers : [Answer]; 
    };


    public type Answer = {
        text : Text;
        answer : Bool; 
    };

    public type QuizzToSend = {
        quizzID : Nat;
        title : Text;
        creator : Principal;
        questions : [Question]; 
        description : Text;
    };

    stable var quizzEntries : [(Nat,Quizz)] = [];
    stable var questionEntries : [(Nat,Question)] = [];


    let quizzes : HashMap.HashMap<Nat,Quizz> = HashMap.fromIter(quizzEntries.vals(), 0 , Nat.equal, Hash.hash);
    let questions : HashMap.HashMap<Nat,Question> = HashMap.fromIter(questionEntries.vals(), 0 , Nat.equal , Hash.hash);

    //Quizz 1 : hardcoded 

    let questionSample1 : Question = {
        questionID = 1;
        question = "What type of canister call doesn't exist ?";
        answers = [{text = "Update call"; answer = false}, {text = "Submit call"; answer = true} , {text = "Query call"; answer =false}];
    }; 

    let questionSample2 : Question = {
        questionID = 2;
        question = "What is the minimum number of replica nodes for a specific canister ?";
        answers = [{text = "4."; answer = false}, {text = "18" ; answer = false} , {text = "7" ; answer = true}];
    }; 

    let questionSample3 : Question = {
        questionID = 3;
        question = "What is a canister ?";
        answers = [{text = "A block in the IC blockchain."; answer =  false}, {text = "A fundamental building block of the Internet Computer where code and state live together."; answer = true},{text = "The algorithm responsible of the Internet Computer protocol"; answer = false}];
    };

    let questionSample4 : Question = {
        questionID = 4;
        question = "Who is the founder of Dfinity ?";
        answers = [{ text = "Satoshi Nakamoto."; answer = false}, { text = "Elon Musk"; answer = false}, {text = "Dominic Williams"; answer = true}];
    };

    let questionSample5 : Question = {
        questionID = 5;
        question = "What is Candid useful for ?";
        answers = [{ text = "It allows you to see the current state of a specified canister."; answer =  false}, { text ="It provides an interface of the public methods of a canister, regardless of the language the canister is coded in."; answer =  true}, { text = "It is a feature that automatically adjusts the number of canister your application needs in order to scale."; answer = false}];
    };

    let listQuestionSample : [Question] = [questionSample1, questionSample2, questionSample3, questionSample4 , questionSample5];

    let iterator = Iter.fromArray<Question> (listQuestionSample);
    for (question in iterator) {
        questions.put(question.questionID, question);
    };

    let quizzSample : Quizz = {
        quizzID = 1;
        title = "Metaquizz";
        creator = Principal.fromText("gwfpn-foiv7-q6rbx-sfvbl-b54ws-kplbm-vp6vi-xx6f4-hmrpz-snmxp-nae");
        questions = [1,2,3,4,5]; 
        description = "The first quizz on the Internet Computer ever";
    };

    quizzes.put(quizzSample.quizzID, quizzSample);

    func _IDToQuestion (questionID : questionID) : ?Question {
        return (questions.get(questionID));
    };
    


    func _createAQuizzToSend(id : quizzID) : ?QuizzToSend {
        switch (quizzes.get(id)) {
            case (null) return null;
            case (?quizz) {

                
                let listQuestionId : [questionID] = quizz.questions;
                
                let h = func _IDToQuestion (questionID : questionID) : ?Question {
                    return (questions.get(questionID));
                };

                let questionSample : Question = {
                    questionID : Nat = 1;
                    question : Text = "How old are you?";
                    answers : [Answer] = [{text = "22"; answer = true},{text = "52"; answer = false}];
                };
                let iterator = Iter.fromArray<questionID>(listQuestionId);
                var listQuestion : [Question] = [];

                for (questionID in iterator) {
                    let newValueOptional : ?Question = _IDToQuestion(questionID);
                    let newValue : Question = Option.get(newValueOptional, questionSample);
                    listQuestion := Array.append<Question>(listQuestion, [newValue]);
                };


                let quizzSend : QuizzToSend = {
                    quizzID : Nat = quizz.quizzID;
                    title : Text = quizz.title;
                    creator : Principal = quizz.creator;
                    questions : [Question] = listQuestion;
                    description : Text = quizz.description;
                };

                return (?quizzSend);
            };
            

        };
        return null;
    };


    //This function will return an array of valid answers for a quizz; in the case of the quizz being a multiple choices quizz with only one valid answer for each question
    // e.g for a quizz like the "first" one we could get a array of length 10 : [0,2,1,0,1,1,2,2,0,1] where each value represent the "true" answer 
    // very specific to the current implementation of quizzes 
    //Assumes quizz with this id exists.
    
    func _getArrayResultFromQuizz (id : quizzID) : ?[Nat] {
        
        switch (quizzes.get(id)) {
            case (null) return null;
            case (?quizz) {

                let listQuestionId : [questionID] = quizz.questions;
                var listQuestion : [Question] = [];

                let questionSample : Question = {
                    questionID : Nat = 0;
                    question : Text = "What if the worst fear of Steve ?";
                    answers : [Answer] = [{text = "Failure"; answer = true},{text = "Girls"; answer = false}, {text = "Brain failure"; answer = false}];
                };

                let iterator = Iter.fromArray<questionID>(listQuestionId);

                for (questionID in iterator) {
                    let newValueOptional : ?Question = _IDToQuestion(questionID);
                    let newValue : Question = Option.get(newValueOptional, questionSample);
                    listQuestion := Array.append<Question>(listQuestion, [newValue]);
                };

                let f = func (question: Question) : Nat {
                    let listAnswer = question.answers;
                    return (_answerToNat(listAnswer));
                };

                let results = Array.map<Question, Nat>(listQuestion, f : (question : Question) -> Nat);

                return ?results;
            }
        }
    };

    //This function will take a list of answer and returns the number of the first "true" answer
    // Very specific to our current quizzes implementation
    // e.g for answers : [Answer] = [{text = "Failure"; answer = true},{text = "Girls"; answer = false}, {text = "Brain failure"; answer = false}]. It will returns 0 
    func _answerToNat (listAnswer : [Answer]) : Nat {
        let iterator = Iter.fromArray<Answer>(listAnswer);
        var counter : Nat = 0;
        for (answer in iterator) {
            if (answer.answer == false) {
                counter := counter +1;
            }
            else {
                return counter;
            }

        
        };

        return counter;
    };
    
    // n represents the size of the Array we want and x the value we will populate it with
    // This will produces an immutable array; there is already a function in the Motoko Base Livrary to create a mutable array of size n with value x 

    func _createArraySizeValue <X> (n : Nat , x: X) : [X] {
        let arrayMutable : [var X] = Array.init<X>(n, x);
        let arrayImmutable : [X] = Array.freeze<X>(arrayMutable);
        return (arrayImmutable);
    };

    public func sendAQuizz (id: quizzID) : async ?QuizzToSend {
        return (_createAQuizzToSend(id))
    };


    public shared(msg) func checkResultQuizz (player: Player, result : [Nat], id : quizzID) : async ?Nat {
        var score : Nat = 0;
        switch(players.get(player)) {
            case (null) return null; //The player should be registered before submitting some quizz
            case (?player) {
               
                let iterator = Iter.range(0, result.size() -1);
                let officialResultOptional : ?[Nat] = _getArrayResultFromQuizz(id);
                let officialResult : [Nat] = Option.get(officialResultOptional, _createArraySizeValue<Nat>(result.size() - 1, 0));
                for (index in iterator) {
                    if (result[index] == officialResult[index]) {
                            score := score + 1;
                        }
                };

            };
        };
        //Add score to array of score
        _newScore(player,score);
        return ?score;
    };  



};

