% union/3
union([], _, []).
union([H | T], Set2, UnionSet) :-
  member(H, Set2),
  nonmember(H, UnionSet),
  union(T, Set2, SubUnionSet),
  append([H], SubUnionSet, UnionSet).

union([H | T], Set2, UnionSet) :-
  nonmember(H, Set2),
  union(T, Set2, SubUnionSet),
  append([], SubUnionSet, UnionSet).

nonmember(V, []).
nonmember(V, [H | T]) :-
  V \= H,
  nonmember(V, T).

% intersection/3



% powerset/2


