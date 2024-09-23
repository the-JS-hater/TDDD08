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

% Variable names can be any prolog atom
id(I) :-
  atom(I).

% evaluating true and false
% serves as base cases for more complex boolean expressions
evalBoolExpr(tt, tt).
evalBoolExpr(ff, ff).

% evaluate == when it results in true(tt)
evalBoolExpr(State, A==B, tt) :-
  evalExpr(State, A, LeftRes),
  evalExpr(State, B, RightRes),
  LeftRes == RightRes.

% evaluate == when it results in false(ff)
evalBoolExpr(State, A==B, ff) :-
  evalExpr(State, A, LeftRes),
  evalExpr(State, B, RightRes),
  dif(LeftRes, RightRes).

% evaluate < when it results in true(tt)
evalBoolExpr(State, A<B, tt) :-
  evalExpr(State, A, LeftRes),
  evalExpr(State, B, RightRes),
  LeftRes < RightRes.

% evaluate < when it results in false(ff)
evalBoolExpr(State, A<B, ff) :-
  evalExpr(State, A, LeftRes),
  evalExpr(State, B, RightRes),
  LeftRes >= RightRes.

% evaluate > when it results in true(tt)
evalBoolExpr(State, A>B, tt) :-
  evalExpr(State, A, LeftRes),
  evalExpr(State, B, RightRes),
  RightRes < LeftRes.

% evaluate > when it results in false(ff)
evalBoolExpr(State, A>B, ff) :-
  evalExpr(State, A, LeftRes),
  evalExpr(State, B, RightRes),
  RightRes >= LeftRes.

% evaluating a variable by extracting it's value from the State
evalExpr(State, id(I), Value) :- member(I=Value, State).

% evaluating a constant
evalExpr(State, num(N), N) :- num(N).

% evaluate addition
evalExpr(State, A+B, Res) :- 
  evalExpr(State, A, Avalue),
  evalExpr(State, B, Bvalue),
  Res is Avalue + Bvalue.

% evaluate subtraction
evalExpr(State, A-B, Res) :- 
  evalExpr(State, A, Avalue),
  evalExpr(State, B, Bvalue),
  Res is Avalue - Bvalue.

% evaluate division
evalExpr(State, A/B, Res) :- 
  evalExpr(State, A, Avalue),
  evalExpr(State, B, Bvalue),
  Res is Avalue / Bvalue.

% evaluate multiplication
evalExpr(State, A*B, Res) :- 
  evalExpr(State, A, Avalue),
  evalExpr(State, B, Bvalue),
  Res is Avalue * Bvalue.

% base case for variable name not being defined
notExists([], I).

% when the variable name is not the head
notExists([H=_ | T], I) :-
  H \= I,
  notExists(T, I).

% Variable is already defined
exists(State, I) :-
  member(I=_, State).

% Replacing the assigned value of a defined variable
% Recursive case when the identifier is not the head
replace([H=SomeValue | T], I, E, NewState) :-
  H \= I,
  replace(T, I, E, Modified),
  append([H=SomeValue], Modified, NewState).

% Base case when the identifier is the head
replace([H=_| T], I, E, [H=E | T]) :-
  H == I.

% execute Skip instruction. No change in state occurs
execute(State, skip, State).

% execute assignment on a previously undefined variable
% evaluate expression and append I=<the results> to State
execute(State, set(I, E), NewState) :-
  notExists(State, I),
  evalExpr(State, E, ExprEvaluation),
  append(State, [I=ExprEvaluation], NewState).

% Execute assignment on a defined variable
% Replace it's value
execute(State, set(I, E), NewState) :-
  exists(State, I),
  evalExpr(State, E, ExprEvaluation),
  replace(State, I, ExprEvaluation, NewState).

% execute If-statment
% This is when the True Branch should execute
execute(State, if(Condition, TrueBranch, FalseBranch), NewState) :-
  evalBoolExpr(State, Condition, Res),
  Res == tt,
  execute(State, TrueBranch, NewState).

% This is when the False branch should execute
execute(State, if(Condition, TrueBranch, FalseBranch), NewState) :-
  evalBoolExpr(State, Condition, Res),
  Res == ff,
  execute(State, FalseBranch, NewState).

% Execute while-statement
% This is when the condition holds and the loop
% should continue. Uses inbetween states to update
% state between iterations
execute(State, while(Condition, Statement), NewState) :-
  evalBoolExpr(State, Condition, Res),
  Res == tt,
  execute(State, Statement, InbetweenState),
  execute(InbetweenState, while(Condition, Statement), NewState).

% Base case for the while loop where it ends since the condition no longer
% holds true
execute(State, while(Condition, Statement), State) :-
  evalBoolExpr(State, Condition, Res),
  Res == ff.

% execute a sequence of two statements. InbetweenState
% is needed to keep track of the three stage transition
% of the programs state, since a change in state from C
% might affect the execution of C1
execute(State, seq(C, C1), NewState) :-
  execute(State, C, InbetweenState),
  execute(InbetweenState, C1, NewState).
