% State information: C:s and M:s on each side. Boat side. Boat occupants
% Idea: leftSide(Cannibals_l, Missionaries_l), boat(Side, Cannibals, Missionaries), rightSide(Cannibals_r, Missionaries_r)

% start_state/1
startState([leftSide(0, 0), boat(right, 0, 0), rightSide(3, 3)]).

% goal_state/1
goalState([leftSide(3, 3), boat(left, 0, 0), rightSide(0, 0)]).

% next/2
% NOTE: State is assumed to be legal
next(State, NextState) :-
	transition(State, NextState),
	legalState(NextState).


% TODO: 1 cannibal, 0 missionaries is ILLEGAL. also logic is ugly
legalState([leftSide(C_l, M_l), boat(_, C_b, M_b), rightSide(C_r, M_r)]) :-
	0 =< C_l,
	0 =< M_l,
	0 =< C_r,
	0 =< M_r,
	0 =< C_b,
	0 =< M_b,
	M_l >= C_l,
	M_r >= C_r,
	3 is C_l + C_b + C_r,
	3 is M_l + M_b + M_r,
	BoatOccupants is C_b + M_b,
	BoatOccupants =< 2,
	BoatOccupants >= 0.

% Boat can change side, assuming at least one occupant
transition([leftSide(C_l, M_l), boat(left, C_b, M_b), rightSide(C_r, M_r)], [leftSide(C_l, M_l), boat(right, C_b, M_b), rightSide(C_r, M_r)]) :-
	X is C_b + M_b,
	X > 0.
transition([leftSide(C_l, M_l), boat(right, C_b, M_b), rightSide(C_r, M_r)], [leftSide(C_l, M_l), boat(left, C_b, M_b), rightSide(C_r, M_r)]) :-
	X is C_b + M_b,
	X > 0.

% Cannibal goes into boat
transition([leftSide(C_l, M_l), boat(right, C_b, M_b), rightSide(C_r, M_r)], [leftSide(C_l, M_l), boat(right, C_b2, M_b), rightSide(C_r2, M_r)]) :-
	C_r2 is C_r - 1,
	C_b2 is C_b + 1.
% Cannibal leaves boat
transition([leftSide(C_l, M_l), boat(right, C_b, M_b), rightSide(C_r, M_r)], [leftSide(C_l, M_l), boat(right, C_b2, M_b), rightSide(C_r2, M_r)]) :-
	C_r2 is C_r + 1,
	C_b2 is C_b - 1.
% Missionary goes into boat
transition([leftSide(C_l, M_l), boat(right, C_b, M_b), rightSide(C_r, M_r)], [leftSide(C_l, M_l), boat(right, C_b, M_b2), rightSide(C_r, M_r2)]) :-
	M_r2 is M_r - 1,
	M_b2 is M_b + 1.
% Missionary leaves boat
transition([leftSide(C_l, M_l), boat(right, C_b, M_b), rightSide(C_r, M_r)], [leftSide(C_l, M_l), boat(right, C_b, M_b2), rightSide(C_r, M_r2)]) :-
	M_r2 is M_r + 1,
	M_b2 is M_b - 1.

% Cannibal goes into boat
transition([leftSide(C_l, M_l), boat(left, C_b, M_b), rightSide(C_r, M_r)], [leftSide(C_l2, M_l), boat(left, C_b2, M_b), rightSide(C_r, M_r)]) :-
	C_l2 is C_l - 1,
	C_b2 is C_b + 1.
% Cannibal leaves boat
transition([leftSide(C_l, M_l), boat(left, C_b, M_b), rightSide(C_r, M_r)], [leftSide(C_l2, M_l), boat(left, C_b2, M_b), rightSide(C_r, M_r)]) :-
	C_l2 is C_l + 1,
	C_b2 is C_b - 1.
% Missionary goes into boat
transition([leftSide(C_l, M_l), boat(left, C_b, M_b), rightSide(C_r, M_r)], [leftSide(C_l, M_l2), boat(left, C_b, M_b2), rightSide(C_r, M_r)]) :-
	M_l2 is M_l - 1,
	M_b2 is M_b + 1.
% Missionary leaves boat
transition([leftSide(C_l, M_l), boat(left, C_b, M_b), rightSide(C_r, M_r)], [leftSide(C_l, M_l2), boat(left, C_b, M_b2), rightSide(C_r, M_r)]) :-
	M_l2 is M_l + 1,
	M_b2 is M_b - 1.

% Check if a given state exists in our list of previously visited states
% Avoid loops by ensuring we don't enter an already visited state more than once
notVisited(State, []).
notVisited(State, [OtherState]) :-
	dif(State, OtherState).
	notVisited(State, [OtherState | T]) :-
	dif(State, OtherState),
	notVisited(State, T).

% Perform depth first search to transition from start state to goal state
dfs(State, [State | Path], Path) :- goalState(State).
dfs(State, Path, Visited) :-
	next(State, NewState),
	notVisited(NewState, Visited),
	dfs(NewState, Path,[NewState | Visited]).

% Initialization sequence
solve(Solution) :-
    startState(Start),
    dfs(Start, Solution, [Start]).
