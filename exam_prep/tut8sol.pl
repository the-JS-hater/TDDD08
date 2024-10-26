%pre\2
pre(X, Y) :- X @< Y.

pre_or_eq(X, Y) :-
	pre(X, Y).
pre_or_eq(X, X).

%max\2

max([X], X).
max([X | Xs], X) :-
	max(Xs, Y),
	pre(Y, X).

max([X | Xs], Y) :-
	max(Xs, Y),
	pre_or_eq(X, Y).
