% Base cases for sorted list
issorted([]).
issorted([A]).

% Recursivley sort in ascending order
issorted([X1, X2 | T]) :-
  X2 >= X1,
  issorted(T).

% base case for selection sort
ssort([], []).

% selection sort
ssort(L, L1) :-
  smallest(L, X),
  remove(X, L, L2),
  ssort(L2, LS),
  append([X], LS, L1).


% collect smallest element of a list
smallest([X], X).

smallest([H, H1 | T], S) :-
  H1 >= H,
  smallest([H | T], S).

smallest([H, H1 | T], S) :-
  H >= H1,
  smallest([H1 | T], S).

% remove from empty list
remove(X, [], []).

% remove X when X is the head of the list
remove(X, [X | T], T). 

% remove X recursivley when it is in the tail
remove(X, [H | T], [H | T1]) :- 
  H \= X, 
  remove(X, T, T1).

% Base cases for quicksort
qsort([], []).
qsort([X], [X]).

qsort([H | T], L1) :-
  partition(T, H, Small, Large),
  qsort(Small, Small2),
  qsort(Large, Large2),
  append(Small2, [H], L2),
  append(L2, Large2, L1).

partition([], N, Small, Large).

partition([H | T], N, Small, Large) :-
  H < N,
  partition(T, N, Small2, Large),
  append([H], Small2, Small).

partition([H | T], N, Small, Large) :-
  H >= N,
  partition(T, N, Small, Large1),
  append([H], Large1, Large).

%:- initialization findall(ssort([-7, 3, -2, 5, 5, 7, -1, 10], T), writeln(T)).
