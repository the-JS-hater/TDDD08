%pre\2
pre(X, Y) :- X @< Y.

pre_or_eq(X, Y) :-
	pre(X, Y).
pre_or_eq(X, X).

remove([], _, []).
remove([H | T], H, T1) :-
	remove(T, H, T1).
remove([H | T], X, [H | T1]) :-
	remove(T, X, T1).

replace([], _, []).
replace([H | T], X, [X | T1]) :-
	replace(T, X, T1).

%max\2
max([X], X).
max([X | Xs], X) :-
	max(Xs, Y),
	pre(Y, X).

max([X | Xs], Y) :-
	max(Xs, Y),
	pre_or_eq(X, Y).


%rmv\2 (facit seems to believe the excercise is rmv\3?)
rmv(Seq, Seq1) :-
	max(Seq, X),
	remove(Seq, X, Seq1).

%rbm\2 (facit is odd again)
rbm(Seq1, Seq2) :-
	max(Seq1, X),
	replace(Seq1, X, Seq2).



