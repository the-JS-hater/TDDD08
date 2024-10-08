% importing nessecary functionality from 
% previous lab, and the provided scanner
% NOTE: both files are assumed to be present in the same folder
:- consult("excercise2-3.pl").
:- consult("scanner.pl").

% DCG =========================
% Given from the excercise

%<pgm> ::= <cmd>
statements(Statement) --> statement(Statement).
%<pgm> ::= <cmd> ; <pgm>
statements(seq(Statement, RestStatements)) --> statement(Statement), [;], statements(RestStatements).

%<cmd> ::= skip
statement(skip) --> [skip].
%<cmd> ::= <id> := <expr>
statement(set(Var, Val)) --> [id(Var)], [:=], expression(Val).
%<cmd> ::= if <bool> then <pgm> else <pgm> fi
statement(if(Condition, TrueBranch, FalseBranch)) --> [if], boolExpression(Condition), [then], statements(TrueBranch), [else], statements(FalseBranch), [fi].
%<cmd> ::= while <bool> do <pgm> od
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

%<factor> ::= <term>
factor(X) --> term(X).
%<factor> ::= <term> * <factor>
factor(A*B) --> term(A), [*], factor(B).
factor(A/B) --> term(A), [/], factor(B).

%<term> ::= <id>
term(id(Var)) --> [id(Var)].
%<term> ::= <num>
term(num(N)) --> [num(N)].

% parse/2
% Simply uses the DCG rules and the list of tokens generated by scan/2
% to generate a AST
parse(TokenVec, Ast) :-
	statements(Ast, TokenVec, []).

% run/3
% self explanatory
run(InitialState, String, FinalState) :-
	% scan/2 FROM scanner.pl
  scan(String, TokenVec),
  parse(TokenVec, Ast),
	% execute/3 FROM excercise2-3.pl
  execute(InitialState, Ast, FinalState).

% Test case from the lab series, printed when module is loaded
:- initialization(forall(run([x=3], "y:=1; z:=0; while x>z do z:= z + 1; y:= y*z od", Res), writeln(Res))).
