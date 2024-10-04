:- consult("excercise2-3.pl").
:- consult("scanner.pl").

% DCG =========================

%<pgm> ::= <cmd>
statements(Statement) --> statement(Statement).
%| <cmd> ; <pgm>
statements(seq(Statement, RestStatements)) --> statement(Statement), [;], statements(RestStatements).

%<cmd> ::= skip
statement(skip) --> [skip].
%| <id> := <expr>
statement(set(Var, Val)) --> [id(Var)], [:=], expression(Val).
%| if <bool> then <pgm> else <pgm> fi
statement(if(Condition, TrueBranch, FalseBranch)) --> [if], boolExpression(Condition), [then], statements(TrueBranch), [else], statements(FalseBranch), [fi].
%| while <bool> do <pgm> od
statement(while(Condition, Statements)) --> [while], boolExpression(Condition), [do], statements(Statements), [od].

%<bool> ::= <expr> > <expr>
boolExpression(A==B) --> expression(A), [==], expression(B).
boolExpression(A<B) --> expression(A), [<], expression(B).
boolExpression(A>B) --> expression(A), [>], expression(B).

%<expr> ::= <factor>
expression(X) --> factor(X).
%<expr> ::= <factor> + <expr>
expression(A+B) --> factor(A), [+], expression(B).
expression(A-B) --> factor(A), [-], expression(B).

%| <term>
factor(X) --> term(X).
%<factor> ::= <term> * <factor>
factor(A*B) --> term(A), [*], factor(B).
factor(A/B) --> term(A), [/], factor(B).

%<term> ::= <id>
term(id(Var)) --> [id(Var)].
%| <num>
term(num(N)) --> [num(N)].

% parse/2
parse(TokenVec, Ast) :-
	statements(Ast, TokenVec, []).

% run/3
run(InitialState, String, FinalState) :-
	% scan/2 FROM scanner.pl
  scan(String, TokenVec),
  parse(TokenVec, Ast),
	% execute/3 FROM excercise2-3.pl
  execute(InitialState, Ast, FinalState).

% Test case from the lab series, printed when module is loaded
:- initialization(forall(run([x=3], "y:=1; z:=0; while x>z do z:= z + 1; y:= y*z od", Res), writeln(Res))).
