% Base cases for sorted list
issorted([]).
issorted([A]).

% Recursivley sort in ascending order
issorted([X1 | T]) :-
  T = [X2 | T1],
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

% Base case for quicksort
qsort([], []).

qsort([H | T], L1) :-
  partition(T, H, Small, Large),
  qsort(Small, Small2),
  qsort(Large, Large2),
  append(Small2, Large2, L1).

partition([], N, [], []).

partition([H | T], N, [H | L1], L2) :-
  H < N,
  partition(T, N, L1, L2).

partition([H | T], N, L1, [H | L2]) :-
  H >= N,
  partition(T, N, L1, L2).

%:- initialization ssort([4,3,2,2,1,2], S).
%:- initialization Writeln(S).
