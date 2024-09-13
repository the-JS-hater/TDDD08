% General NOTE: recursive cases are always at the end of functions
% Otherwise certain recursive queries run the risk of never terminating


% Facts (Terms)

beautiful(ulrika).
beautiful(peter).
strong(anne).
strong(peter).
strong(bosse).
rich(anne).
kind(bosse).
man(peter).
man(bosse).
woman(ulrika).
woman(anne).


% all rich people are happy
happy(X) :-
  rich(X).


% every man who likes a woman, who likes him, are happy
happy(X) :-
  man(X),
  woman(Y),
  likes(X, Y),
  likes(Y, X).


% every woman who likes a man, who likes her, is happy
happy(X) :-
  woman(X),
  man(Y),
  likes(X, Y),
  likes(Y, X).


  
% all men like beautiful women
likes(X, Y) :-
  man(X),
  woman(Y),
  beautiful(Y).


% peter likes everyone if they are kind
likes(peter, Y) :-
  kind(Y).


% nisse likes all women who like him
likes(nisse, Y) :-
  woman(Y),
  likes(Y, nisse).



% ulrika likes a man if he likes her and is rich & kind
likes(ulrika, Y) :-
  man(Y),
  rich(Y),
  kind(Y),
  likes(Y, ulrika).


% ulrika likes a man if he likes her and is strong and beautiful 
likes(ulrika, Y) :-
  man(Y),
  beautiful(Y),
  strong(Y),
  likes(Y, ulrika).





% test queries that run when the script is included in the interpreter
% i.e usage: swipl <path-to-this-file>

:- initialization(writeln("X likes")).
:- initialization forall(likes(X, Y), writeln(X)).
:- initialization(writeln("\nlikes Y")).
:- initialization forall(likes(X, Y), writeln(Y)).
:- initialization writeln("\nHappy:").
:- initialization forall(happy(X), writeln(X)).
:- initialization writeln("\nHow many like ulrika:").
:- initialization findall(X, likes(Y,ulrika), Z), length(Z, N), writeln(N).

