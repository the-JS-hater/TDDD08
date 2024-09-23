:- consult("excercise2-3.pl").
:- consult("scanner.pl").

% run/3

% execute/3 FROM excercise2-3.pl
% scan/2 FROM scanner.pl
run(InitialState, String, FinalState) :-
  scan(String, TokenVec),
  parse(TokenVec, Ast),
  execute(InitialState, Ast, FinalState).


%<pgm> ::= <cmd>
%| <cmd> ; <pgm>
%<cmd> ::= skip
%| <id> := <expr>
%| if <bool> then <pgm> else <pgm> fi
%| while <bool> do <pgm> od
%<bool> ::= <expr> > <expr>
%| ...
%<expr> ::= <factor> + <expr>
%| <factor>
%<factor> ::= <term> * <factor>
%| <term>
%<term> ::= <id>
%| <num>

% parse/2

parse([Statement | RestStatements], Ast) :-
  %TODO
  .

parse([Statement], Ast) :-
  %TODO
  .

parseCmd(skip, skip) :-
  %TODO
  .

parseCmd([id(Var), :=, Expression], ) :-
  %TODO
  % Parse expression, 
  .

parseCmd([if, Bool, then, Statements, else, Statements2, ]) :-
  %TODO, like... alot TODO
  .

parseCmd([while Bool do Statements od]) :-
  %TODO
  .

parseBool([Expression1, >, Expression2]) :-
  %TODO
  .

parseExpression([Factor, +, Expression]) :-
  %TODO
  .

parseFactor([Term, *, Factor]) :-
  %TODO
  .

parseTerm([id(X)]) :-
  %TODO
  .

