import type { Principal } from '@dfinity/principal';
export interface Answer { 'text' : string, 'answer' : boolean }
export interface Metadata { 'name' : string }
export interface Metagame {
  'addPlayer' : (arg_0: PlayerRegister) => Promise<PlayerRegisterResponse>,
  'checkResultQuizz' : (
      arg_0: Player,
      arg_1: Array<bigint>,
      arg_2: quizzID,
    ) => Promise<[] | [bigint]>,
  'getInfosOfPlayer' : (arg_0: Player) => Promise<PlayerInfosResponse>,
  'metascoreRegisterSelf' : (arg_0: [Principal, string]) => Promise<undefined>,
  'metascoreScores' : () => Promise<Array<Score>>,
  'register' : () => Promise<Result>,
  'sendAQuizz' : (arg_0: quizzID) => Promise<[] | [QuizzToSend]>,
  'testBasic' : () => Promise<boolean>,
  'testPlayer' : (arg_0: Player) => Promise<boolean>,
}
export type Player = { 'plug' : Principal } |
  { 'stoic' : Principal };
export type PlayerInfosResponse = { 'ok' : string } |
  { 'err' : { 'NotFound' : null } | { 'Unknown' : null } };
export interface PlayerRegister { 'player' : Player, 'name' : string }
export type PlayerRegisterResponse = { 'ok' : null } |
  { 'err' : { 'AlreadyExist' : null } | { 'Unknown' : null } };
export type Player__1 = { 'plug' : Principal } |
  { 'stoic' : Principal };
export interface Question {
  'question' : string,
  'answers' : Array<Answer>,
  'questionID' : bigint,
}
export interface QuizzToSend {
  'title' : string,
  'creator' : Principal,
  'description' : string,
  'questions' : Array<Question>,
  'quizzID' : bigint,
}
export type RegisterCallback = (arg_0: Metadata) => Promise<undefined>;
export type Result = { 'ok' : null } |
  { 'err' : string };
export type Score = [Player__1, bigint];
export type quizzID = bigint;
export interface _SERVICE extends Metagame {}
