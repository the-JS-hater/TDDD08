% intersection/3 =========================

% Base case for empty set
intersection([], _, []).

% Intersection where head of both sets are equal
% We then save *one* instance of head in the return list,
% alongside the recursive result of intersecting the tails
intersection([H | T], [H | T1], [H | SubIntersection]) :-
  intersection(T, T1, SubIntersection).

% Head of first set is outside second set (we kan know because both are sorted)
% Therefor it is discarded and the recursion continues
intersection([H | T], [H1 | T1], Intersection) :-
  H @< H1,
  intersection(T, [H1 | T1], Intersection).

% Head of second set is outside first set and is discarded in the recursion
intersection([H | T], [H1 | T1], Intersection) :-
  H @> H1,
  intersection([H | T], T1, Intersection).
  
% union/3 ================================

% Base cases. If either set is empty, the union is the entire other set
union([], S, S).
union(S, [], S).

% Heads are different so the smaller one is added to the return list
union([H | T], [H1 | T1], [H | S]) :-
  H @< H1,
  union(T, [H1 | T1], S).

% Heads are different so the smaller one is added to the return list
union([H | T], [H1 | T1], [H1 | S]) :-
  H1 @< H,
  union([H | T], T1, S).

% Heads are the same, so *one* instance is added to the return list
% and it's removed from both sets in the recursion
union([H | T], [H | T1], [H | S]) :-
  union(T, T1, S).

% powerset/2 =============================

% Base case for empty list
powerset([], [[]]).

% Base case for set of one element
powerset([X], [[], [X]]).

% Main powerset function
% Create all subsets with head as prefix,
% Then append the powerset of the tail
% We also make sure to remove all empty sets that appear
% from base cases, and make sure to add only one empty set at
% the start of the return list to ensure the final powerset only 
% contains one instance of the empty list
powerset([H | T], Return) :-
  subsetCreate([H], T, Subset),
  append([[H]], Subset, ToBeReturned),
  powerset(T, P1),
  append(ToBeReturned, P1, AlmostReturn),
  removeExcessEmpty(AlmostReturn, Cleaned),
  append([[]], Cleaned, Return).

% Helper function for creating subsets with a given prefix
% This is it's base case. After this we have no more suffixes
subsetCreate(OrigList, [X], [Return]) :-
  append(OrigList, [X], Return).

% Recursive case. Combine Head, and first suffix and save the reuslt
% Then add the result of recursivley creating subsets from the rest of
% the suffixes
subsetCreate(OriginList, [H | T], [First | Rest]) :- 
  append(OriginList, [H], First),
  subsetCreate(First, T, Rest).

% Base case for removing excess empty lists
removeExcessEmpty([], []).

% Head is an empty list and should be removed
removeExcessEmpty([H | T], Return) :-
  H == [],
  removeExcessEmpty(T, Return).

% Head is not an empty list and will not be rmeoved
removeExcessEmpty([H | T], [H | T1]) :-
  dif(H, []),
  removeExcessEmpty(T, T1).

% Test queries:
:- writeln("Intersection of [] and [a,b,c]").
:- forall(intersection([], [a,b,c], I), writeln(I)).
:- writeln("Intersection of [a,b,c] and [b,c,d]").
:- forall(intersection([a,b,c], [b,c,d], I), writeln(I)).
:- writeln("Union of [], [a,b,c]").
:- forall(union([], [a,b,c], U), writeln(U)).
:- writeln("Union of [a,b,c,d], and [c,d,e,f]").
:- forall(union([a,b,c,d], [c,d,e,f], U), writeln(U)).
:- writeln("Powerset of []").
:- forall(powerset([], P), writeln(P)).
:- writeln("Powerset of [a,b,c]").
:- forall(powerset([a,b,c], P), writeln(P)).
