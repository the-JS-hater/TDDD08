% intersection/3

intersection([], _, []).

intersection([H | T], [H | T1], [H | SubIntersection]) :-
  intersection(T, T1, SubIntersection).

intersection([H | T], [H1 | T1], Intersection) :-
  H @< H1,
  intersection(T, [H1 | T1], Intersection).

intersection([H | T], [H1 | T1], Intersection) :-
  H @> H1,
  intersection([H | T], T1, Intersection).
  
% union/3

union([], S, S).

union([H | T], [H1 | T1], [H | S]) :-
  H @< H1,
  union(T, [H1 | T1], S).

union([H | T], [H1 | T1], [H1 | S]) :-
  H1 @< H,
  union([H | T], T1, S).

union([H | T], [H | T1], [H | S]) :-
  union(T, T1, S).

% powerset/2

powerset([], [[]]).
powerset([H | []], [[], [H]]).

powerset([H | T], ) :-
  powerset(T, P),
  

powerset([H | T], [Result, MoreResults]) :-
  combinationCreator(H, T, Result),
  powerset(T, MoreResults).

combinationCreator(_, [], []).

combinationCreator([H], [H1 | T], [H, Combs]) :-
  combinationCreator([H, H1], T, Combs).
