middle(X, [X]).
middle(X, [First|Xs]) :-
	middle(X, Middle),
	append(Middle, [Last], Xs).

