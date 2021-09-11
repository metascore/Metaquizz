export const idlFactory = ({ IDL }) => {
  const Player = IDL.Variant({
    'plug' : IDL.Principal,
    'stoic' : IDL.Principal,
  });
  const PlayerRegister = IDL.Record({ 'player' : Player, 'name' : IDL.Text });
  const PlayerRegisterResponse = IDL.Variant({
    'ok' : IDL.Null,
    'err' : IDL.Variant({ 'AlreadyExist' : IDL.Null, 'Unknown' : IDL.Null }),
  });
  const quizzID = IDL.Nat;
  const PlayerInfosResponse = IDL.Variant({
    'ok' : IDL.Text,
    'err' : IDL.Variant({ 'NotFound' : IDL.Null, 'Unknown' : IDL.Null }),
  });
  const Metadata = IDL.Record({ 'name' : IDL.Text });
  const RegisterCallback = IDL.Func([Metadata], [], []);
  const Player__1 = IDL.Variant({
    'plug' : IDL.Principal,
    'stoic' : IDL.Principal,
  });
  const Score = IDL.Tuple(Player__1, IDL.Nat);
  const Result = IDL.Variant({ 'ok' : IDL.Null, 'err' : IDL.Text });
  const Answer = IDL.Record({ 'text' : IDL.Text, 'answer' : IDL.Bool });
  const Question = IDL.Record({
    'question' : IDL.Text,
    'answers' : IDL.Vec(Answer),
    'questionID' : IDL.Nat,
  });
  const QuizzToSend = IDL.Record({
    'title' : IDL.Text,
    'creator' : IDL.Principal,
    'description' : IDL.Text,
    'questions' : IDL.Vec(Question),
    'quizzID' : IDL.Nat,
  });
  const Metagame = IDL.Service({
    'addPlayer' : IDL.Func([PlayerRegister], [PlayerRegisterResponse], []),
    'checkResultQuizz' : IDL.Func(
        [Player, IDL.Vec(IDL.Nat), quizzID],
        [IDL.Opt(IDL.Nat)],
        [],
      ),
    'getInfosOfPlayer' : IDL.Func([Player], [PlayerInfosResponse], []),
    'metascoreRegisterSelf' : IDL.Func([RegisterCallback], [], []),
    'metascoreScores' : IDL.Func([], [IDL.Vec(Score)], ['query']),
    'register' : IDL.Func([], [Result], []),
    'sendAQuizz' : IDL.Func([quizzID], [IDL.Opt(QuizzToSend)], []),
    'testBasic' : IDL.Func([], [IDL.Bool], []),
    'testPlayer' : IDL.Func([Player], [IDL.Bool], []),
  });
  return Metagame;
};
export const init = ({ IDL }) => { return []; };
