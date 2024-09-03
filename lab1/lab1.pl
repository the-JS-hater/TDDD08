% Facts

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

% graph

edge(a, b).
edge(a, c).
edge(b, c).
edge(c, d).
edge(c, e).
edge(d, h).
edge(d, f).
edge(e, f).
edge(e, g).
edge(f, g).


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


% there is a path if A and B are conneted by an edge
path(A, B) :-
  edge(A, B).

% there is a path if A is connected to X and X has a path to B 
path(A, B) :-
  edge(A, X),
  path(X, B).

% Base case for recursively plotting a graph path 
path(A, B, [A, B]) :-
  edge(A, B).

% Recursivley plot the path from A -> B, where they dont share an edge 
path(A, B, [A | Zs]) :-
  edge(A, X),
  path(X, B, Zs).

% Get the length of a path, given that such exists
npath(A, B, N) :-
  path(A, B, Z),
  length(Z, N).



% test queries that run when the script is included in the interpreter
:- initialization(writeln("X likes")).
:- initialization forall(likes(X, Y), writeln(X)).
:- initialization(writeln("\nlikes Y")).
:- initialization forall(likes(X, Y), writeln(Y)).
:- initialization writeln("\nHappy:").
:- initialization forall(happy(X), writeln(X)).
:- initialization writeln("\nHow many like ulrika:").
:- initialization findall(X, likes(Y,ulrika), Z), length(Z, N), writeln(N).

% graph test queries
:- initialization writeln("Path:").
:- initialization forall(path(a, f, Z), writeln(Z)).
:- initialization writeln("Length:").
:- initialization forall(npath(a, f, N), writeln(N)). 
