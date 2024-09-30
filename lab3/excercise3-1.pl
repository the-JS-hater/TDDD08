:- consult("excercise2-3.pl").
:- consult("scanner.pl").

% DCG =========================

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

statements(Statement) --> statement(Statement).
statements(seq(Statement | RestStatements)) --> statement(Statement), [;], statements(RestStatements).

statement(skip) --> [skip].
statement(set(Var, Val)) --> [id(Var)], [:=], expression(Expression).
statement(if(Condition, TrueBranch, FalseBranch)) --> [if], boolExpression(Condition), [then], statement(TrueBranch), [else], statement(FalseBranch), [fi].
statement(while(Condition, Statement)) --> [while], boolExpression(Condition), [do], statement(Statement), [od].

boolExpression(A==B) --> expression(A), [==], expression(B).
boolExpression(A<B) --> expression(A), [<], expression(B).
boolExpression(A>B) --> expression(A), [>], expression(B).

expression(X) --> factor(X).
expression(A+B) --> factor(A), [+], expression(B).
expression(A-B) --> factor(A), [-], expression(B).

factor(X) --> term(X).
factor(A*B) --> term(A), [*], expression(B).
factor(A/B) --> term(A), [/], expression(B).

term(id(Var)) --> [id(Var)].
term(num(N)) --> [num(N)].

% parseProgram/2
parseProgram(TokenVec, Ast) :-
	statements(Ast, TokenVec []).

% run/3
run(InitialState, String, FinalState) :-
	% scan/2 FROM scanner.pl
  scan(String, TokenVec),
  parseProgram(TokenVec, Ast),
	% execute/3 FROM excercise2-3.pl
  execute(InitialState, Ast, FinalState).

% Test cases
:- initialization(forall(run([x=3], "y:=1; z:=0; while x>z do z:=z+1; y:=y*z od", Res), writeln(Res))).
