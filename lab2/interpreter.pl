% ENBF
% I = Identifier
% N = natural number
% B = tt | ff | E > E | ...
% E = id(I) | Num(N) | E + E | ...
% C = skip | set(I, E) | if(B, C, C) | while(B, C) | seq(C, C)

% TODO:
% Represent I and N
% Define arithmetic and boolean expressions
% Lastly, execute/3 which takes state and program and returns resulting state

% state might be a list [a = N, b = N, ..., C = N] ?
% and program should be defined as an IMP struct ?
