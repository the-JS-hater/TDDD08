:- consult("excercise4-1").


% Perform breadth first search,
% For these bfd() clauses the first paramater will be representing a list of possible paths, each such path will be a list going
% from the last node in that path and with the last entry in the list being the root of the search tree.
% The goal of the algorithm will then be to go over all of these list and expand each of those paths and add them to the end of th list of all path. That way we will always be expanding the shortest paths first.
bfs([[Node | Path] | Paths], [Node | Path]) :-
	goalState(Node).

% This is th recursive case for the bfs() clause
bfs([[Node | Path] | Paths], BestPath) :-
        findall(NewState, bfsNext(Node, Path, NewState), Neighbors),
	expand([Node | Path], Neighbors, NewPaths),
	% Here it is important that we append the new paths AFTER the original list of Paths. If we were to do things the other way around then we would have a standard, DFS solution as it would continue to expand one path until that reaches a lead node and is removed. This way the shorest path will be expanded first. 
	append(Paths, NewPaths, NewestPaths),
	bfs(NewestPaths, BestPath).

% In this case we handle if we find an end to some path that dose not lead to the goal state. 
bfs([[Node | Path] | Paths], ReturnPath) :-
    findall(NewState, bfsNext(Node, Path, NewState), Neighbors),
    % We dont find any neighbors on this path, as such we are in a leaf node of the search tree and will not find the goal state on this path, as such the path should be discarded. 
    Neighbors = [],
    bfs(Paths, ReturnPath).

%  This clause will expand some path with the contens of the second paramater. The second paramater should contain all the nodes that a path could go one set ahead, if we have some path [c,b,a] (a being the start state and c the end of the path) and we see that from c we could go to either d or e then this expand clause will return the paths, [d,c,b,a] AND [e,c,b,a].
expand(Path, [Head], [[Head | Path]]).
expand(Path, [Head | Tail], [[Head | Path ] | Paths]) :-
	expand(Path, Tail, Paths).

% this clause will check that from some node we can go to NextNode. It will check that we can transition from the node to the next node but also that the nextnode is leagal and that the nextnode is no in the path. This will prevent us from going back and forth in infinit loops. 
bfsNext(Node, Path, NextNode) :-
	transition(Node, NextNode),
	legalState(NextNode),
	notVisited(NextNode, Path).

% A simple setup clause that is used to get a solution for the problem using the BFS searching method. 
runBFS(Solution) :-
    startState(Start),
    bfs([[Start]], Solution).
