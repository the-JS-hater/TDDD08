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
union(S, [], S).

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

powerset([X], [[], [X]]).

powerset([H | T], Return) :-
  subsetCreate([H], T, Subset),
  append([[H]], Subset, ToBeReturned),
  powerset(T, P1),
  append(ToBeReturned, P1, AlmostReturn),
  removeExcessEmpty(AlmostReturn, Cleaned),
  append([[]], Cleaned, Return).

subsetCreate(OrigList, [X], [Return]) :-
  append(OrigList, [X], Return).

subsetCreate(OriginList, [H | T], [First | Rest]) :- 
  append(OriginList, [H], First),
  subsetCreate(First, T, Rest).

removeExcessEmpty([], []).

removeExcessEmpty([H | T], Return) :-
  H == [],
  removeExcessEmpty(T, Return).

removeExcessEmpty([H | T], [H | T1]) :-
  dif(H, []),
  removeExcessEmpty(T, T1).
