:- consult("excercise2-3.pl").
:- consult("scanner.pl").

% run/3
run(InitialState, String, FinalState) :-
	% scan/2 FROM scanner.pl
  scan(String, TokenVec),
  parse(TokenVec, Ast),
	% execute/3 FROM excercise2-3.pl
  execute(InitialState, Ast, FinalState).

% parse/2
parse(TokenVec, Ast) :-
	statements(Ast, TokenVec []).

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

expression(A+B) --> factor(A), [+], expression(B).

expression(A-B) --> factor(A), [-], expression(B).

expression(X) --> factor(X).

factor(A*B) --> term(A), [*], expression(B).

factor(A/B) --> term(A), [/], expression(B).

factor(X) --> term(X).

term(id(Var)) --> [id(Var)].

term(num(N)) --> [num(N)].


% Test cases
:- initialization(forall(run([x=3], "y:=1; z:=0; while x>z do z:=z+1; y:=y*z od", Res), writeln(Res))).
