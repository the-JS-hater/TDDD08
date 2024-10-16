:- use module(clpfd).

% container(Id,NrOfPplReq,Duration)

container(a,2,2).
container(b,4,1).
container(c,2,2).
container(d,1,1).

% one container, is ontop of another

on(a,d).
on(b,c).
on(c,d).

schedule(Workers, EndTime, Cost) :-
	% task(S_i, D_i, E_i, C_i, T_i).

	cumulative(Tasks, [limit(Workers)]),
	Cost #= Workers * EndTime,
	labeling([min(Cost)], [Cost | StartTimes]).


task(Start, Duration, End, Cost, Id) :-
	container(Id, Cost, Duration),
	End #= Start + Duration.


getTasks(Tasks) :-
	findall(container(Id, Cost, Duration), container(Id, Cost, Duration), Containers),
	getTasks(Containers, Tasks).
	
getTasks([], []).
getTasks([container(Id, Cost, Duration)| CTail], [task(Start, Duration, End, Cost, Id) | TTail]) :-
	getTasks(CTail, TTail).


getTaskContraints([]).
getTaskContraints([task(Start, Duration, End, Cost, Id)| Tasks]) :-
	on(TopContainerId, Id),
	task(_, _, TopEnd, _, TopContainerId),
	Start #> TopEnd,
	getTaskContraints(Tasks).
	
	

















