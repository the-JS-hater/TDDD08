% ENBF ========================
% I = Identifier
% N = natural number
% B = tt | ff | E > E | ...
% E = id(I) | Num(N) | E + E | ...
% C = skip | set(I, E) | if(B, C, C) | while(B, C) | seq(C, C)

% Constants ==================
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

evalExpr(State, id(I), Value) :- member(I=Value, State).
evalExpr(State, num(N), N) :- num(N).

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


notExists([], I).
notExists([H=_ | T], I) :-
  H \= I,
  notExists(T, I).

exists(State, I) :-
  member(I=_, State).

replace([H=SomeValue | T], I, E, NewState) :-
  H \= I,
  replace(T, I, E, Modified),
  append([H=SomeValue], Modified, NewState).

replace([H=_| T], I, E, [H=E | T]) :-
  H == I.

execute(State, skip, State).

execute(State, set(I, E), NewState) :-
  notExists(State, I),
  evalExpr(State, E, ExprEvaluation),
  append(State, [I=ExprEvaluation], NewState).

execute(State, set(I, E), NewState) :-
  exists(State, I),
  evalExpr(State, E, ExprEvaluation),
  replace(State, I, ExprEvaluation, NewState).

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

:- forall(execute([x=2], seq(set(y, id(x)+num(5)), set(z, id(x)*id(y))), Sn), writeln(Sn)).
:- forall(evalBoolExpr([x=1], id(x)<num(10), Res), writeln(Res)).
:- forall(execute([x=10], set(x, id(x)+num(1)), Sn), writeln(Sn)).
:- forall(execute([x=1], while(id(x)<num(10), set(x, id(x)+num(1))), Sn), writeln(Sn)).
:- forall(execute([x=3, y=1], seq(set(y, id(x)*id(y)), set(x, id(x)-num(1))), Sn), writeln(Sn)).
:- forall(execute([x=3], seq(set(y, num(1)), while(id(x)>num(1), seq(set(y, id(y)*id(x)), set(x, id(x)-num(1))))), Sn), writeln(Sn)).
