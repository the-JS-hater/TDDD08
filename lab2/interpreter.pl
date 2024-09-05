% ENBF
% I = Identifier
% N = natural number
% B = tt | ff | E > E | ...
% E = id(I) | Num(N) | E + E | ...
% C = skip | set(I, E) | if(B, C, C) | while(B, C) | seq(C, C)

num(N) :-
  integer(N),
  N >= 0.

id(I) :-
  atom(I).

evalBoolExpr(tt, tt).
evalBoolExpr(ff, ff).

evalBoolExpr(State, A==B, tt) :-
  evalExpr(State, A, LeftRes),
  evalExpr(State, B, RightRes),
  LeftRes == RightRes.

evalBoolExpr(State, A==B, ff) :-
  evalExpr(State, A, LeftRes),
  evalExpr(State, B, RightRes),
  LeftRes \= RightRes.

evalBoolExpr(State, A<B, tt) :-
  evalExpr(State, A, LeftRes),
  evalExpr(State, B, RightRes),
  LeftRes < RightRes.

evalBoolExpr(State, A<B, ff) :-
  evalExpr(State, A, LeftRes),
  evalExpr(State, B, RightRes),
  LeftRes >= RightRes.

evalBoolExpr(State, A>B, tt) :-
  evalExpr(State, A, LeftRes),
  evalExpr(State, B, RightRes),
  RightRes < LeftRes.

evalBoolExpr(State, A>B, ff) :-
  evalExpr(State, A, LeftRes),
  evalExpr(State, B, RightRes),
  RightRes >= LeftRes.

evalExpr(State, I, Value) :- member([I, Value], State).
evalExpr(State, N, N) :- num(N).

evalExpr(State, A+B, Res) :- 
  evalExpr(State, A, Avalue),
  evalExpr(State, B, Bvalue),
  Res is Avalue + Bvalue.

evalExpr(State, A-B, Res) :- 
  evalExpr(State, A, Avalue),
  evalExpr(State, B, Bvalue),
  Res is Avalue - Bvalue.

evalExpr(State, A/B, Res) :- 
  evalExpr(State, A, Avalue),
  evalExpr(State, B, Bvalue),
  Res is Avalue / Bvalue.

evalExpr(State, A*B, Res) :- 
  evalExpr(State, A, Avalue),
  evalExpr(State, B, Bvalue),
  Res is Avalue * Bvalue.

execute(State, skip, State).
execute(State, set(I, E), NewState)) :-
  notExists(State, I),
  append([State, [I, E], NewState]).

execute(State, set(I, E), NewState) :-
  exists(State, I),
  replace(State, I, E, NewState).

notExists([], I).
notExists([H, _ | T], I) :-
  H \= I,
  notExists(T, I).

exists(State, I) :-
  member([I, _], State).

replace([H, _ | T], I, E, NewState) :-
  H \= I,
  replace(T, I, E, NewState).

replace([H, _| T], I, E, [H, E | T]) :-
  H == I.

execute(State, if(Condition, TrueBranch, FalseBranch), NewState) :-
  evalBoolExpr(State, Condition, Res),
  Res == tt,
  execute(State, TrueBranch, NewState).

execute(State, if(Condition, TrueBranch, FalseBranch), NewState) :-
  evalBoolExpr(State, Condition, Res),
  Res == ff,
  execute(State, FalseBranch, NewState).

execute(State, while(Condition, Statement), NewState) :-
  evalBoolExpr(State, Condition, Res),
  Res == tt,
  execute(State, Statement, InbetweenState),
  execute(InbetweenState, while(Condition, Statement), NewState).

execute(State, while(Condition, Statement), State) :-
  evalBoolExpr(State, Condition, Res),
  Res == ff.

execute(State, seq(C, C1), NewState) :-
  execute(State, C, InbetweenState),
  execute(InbetweenState, C1, NewState).

