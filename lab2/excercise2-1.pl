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
% base case
smallest([X], X).

% First element is smaller than second, so second is discarded and we proceed recursivley
smallest([H, H1 | T], S) :-
  H1 >= H,
  smallest([H | T], S).

% Second element is smaller than head, so head is discarded and we proceed recursivley
smallest([H, H1 | T], S) :-
  H >= H1,
  smallest([H1 | T], S).

% remove from empty list
% base case
remove(X, [], []).

% remove X when X is the head of the list
remove(X, [X | T], T). 

% remove X recursivley when it is in the tail
remove(X, [H | T], [H | T1]) :- 
  dif(H, X),
  remove(X, T, T1).

% Base cases for quicksort
qsort([], []).
qsort([X], [X]).

% main function for qsort containing entirety of the algorithm
% partition based on head elem into lists containg smaller and larger
% values respectivley, and recursivley sort each, then append
% into smaller partition -> head elem -> larger partition
qsort([H | T], L1) :-
  partition(T, H, Small, Large),
  qsort(Small, Small2),
  qsort(Large, Large2),
  append(Small2, [H], L2),
  append(L2, Large2, L1).

% base case for the partitioning
partition([], N, [], []).

% When first elem is smaller than the partitioning value
partition([H | T], N, Small, Large) :-
  H < N,
  partition(T, N, Small2, Large),
  append([H], Small2, Small).

% When first elem is larger than(or equal to) the partitioning value
partition([H | T], N, Small, Large) :-
  H >= N,
  partition(T, N, Small, Large1),
  append([H], Large1, Large).

% Test queries that are executed when the script is included in the interpreter
% Usage: swipl <path-to-this-file.pl>
:- initialization writeln("original list: -7, 3, -2, 5, 5, 7, -1, 10").
:- initialization writeln("Selection sort: ").
:- initialization forall(ssort([-7, 3, -2, 5, 5, 7, -1, 10], T), writeln(T)).
:- initialization writeln("Quick sort: ").
:- initialization forall(qsort([-7, 3, -2, 5, 5, 7, -1, 10], T), writeln(T)).
