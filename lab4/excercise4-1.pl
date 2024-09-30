% goal_state/1
goal_state([0, 0, 3, 3]).

% start_state/1
start_state([3, 3, 0, 0]).

% next/2
next([L_C, L_M, R_C, R_M], NextState) :-
	%TODO
	
	.

dfs(State) :- goal_state(State).
dfs(State) :- next(State, NewState), dfs(NewState).

% assuming that the second argument of dfs/2 is responsible for keeping
% track of the list of state transitions
:- table dfs(start_state(State), first).
