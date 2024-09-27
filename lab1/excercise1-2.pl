% NOTE: just as in ex. 1.1; the recursive premises are always last

% Graph (Terms)

edge(a, b).
edge(a, c).
edge(b, c).
edge(c, d).
edge(c, e).
edge(d, h).
edge(d, f).
edge(e, f).
edge(e, g).
edge(f, g).


% there is a path if A and B are conneted by an edge
path(A, B) :-
  edge(A, B).

% there is a path if A is connected to X and X has a path to B 
path(A, B) :-
  edge(A, X),
  path(X, B).

% Base case for recursively plotting a graph path 
path(A, B, [A, B]) :-
  edge(A, B).

% Recursivley plot the path from A -> B, where they dont share an edge 
path(A, B, [A | Zs]) :-
  edge(A, X),
  path(X, B, Zs).

% Get the length of a path, given that such exists
% N = NrOfNosed - 1, because that way you get the 
% number of edges, instead of number of nodes, in a 
% given path
npath(A, B, N) :-
  path(A, B, Z),
  length(Z, NumberOfNodes),
	N is NumberOfNodes - 1.


% test queries that run when the script is included in the interpreter
% i.e usage: swipl <path-to-this-file>

:- initialization writeln("Path:").
:- initialization forall(path(a, f, Z), writeln(Z)).
:- initialization writeln("Length:").
:- initialization forall(npath(a, f, N), writeln(N)). 
