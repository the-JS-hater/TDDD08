% ENBF
% I = Identifier
% N = natural number
% B = tt | ff | E > E | ...
% E = id(I) | Num(N) | E + E | ...
% C = skip | set(I, E) | if(B, C, C) | while(B, C) | seq(C, C)

% TODO:
% Represent I and N
% Define arithmetic and boolean expressions
% Lastly, execute/3 which takes state and program and returns resulting state

% state might be a list [a = N, b = N, ..., C = N] ?
% and program should be defined as an IMP struct ?


evalBoolExpr(tt, tt).
evalBoolExpr(ff, ff).
evalBoolExpr(E, ==, E).
evalBoolExpr(E, <, E).
evalBoolExpr(E, <=, E).
evalBoolExpr(E, >, E).
evalBoolExpr(E, >=, E).

evalExpr(id, Val, Val).
evalExpr(num, N, N).
evalExpr(A, +, B, Res) :- Res is A + B.
evalExpr(A, -, B, Res) :- Res is A - B.
evalExpr(A, /, B, Res) :- Res is A / B.
evalExpr(A, *, B, Res) :- Res is A * B.


execCommand(skip).

% I assume global state of the program needs to be passed in here?
execCommand(set, I, E).

% Presumablt we will need one for when B is true, and one when false
execCommand(if, B, TrueBranch, FalseBranch).
  evalBoolExpr(B, Res),
  Res == tt,
  execCommand(TrueBranch).
  

execCommand(if, B, C, C).
  

execCommand(while, B, C).

execCommand(seq, C, C).

execute(InitialState, Program, FinalState).
