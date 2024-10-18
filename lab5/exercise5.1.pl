:- use_module(clpfd).

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
    in(Workers, 1..100),
    in(EndTime, 1..100),
    
    getTasks(Tasks),
    getTaskConstraints(Tasks, Tasks),

    getAllParamaters(Tasks, AllEndTimes, AllStartTime),

    ins(AllEndTimes, 1..100),
    ins(AllStartTime, 0..100),

    setEndTimeConstraint(EndTime, AllEndTimes),
    
    cumulative(Tasks, [limit(Workers)]),
    Cost #= Workers * EndTime,
    labeling([min(Cost)], [Cost | AllStartTime]).


%task(Start, Duration, End, Cost, Id) :-
%	container(Id, Cost, Duration),
%	End #= Start + Duration.

setEndTimeConstraint(_, []).
setEndTimeConstraint(EndTime, [ContainerEndTime | TContainerEndTime]) :-
    EndTime #>= ContainerEndTime,
    setEndTimeConstraint(EndTime, TContainerEndTime).


getAllParamaters([],[],[]).
getAllParamaters([task(Start, Duration, End, Cost, Id) | TTask], [End | TEndTime], [Start | TStartTime]) :-
    getAllParamaters(TTask, TEndTime, TStartTime).

getTasks(Tasks) :-
    findall(container(Id, Cost, Duration), container(Id, Cost, Duration), Containers),
    getTasks(Containers, Tasks).

getTasks([], []).
getTasks([container(Id, Cost, Duration)| CTail], [task(Start, Duration, End, Cost, Id) | TTail]) :-
    getTasks(CTail, TTail).

getTaskFromId([], _, []).
getTaskFromId([Id | Tid], [task(Start, Duration, End , Cost ,Id) | TTask], [task(Start, Duration, End, Cost, Id) | Rec]) :-
    getTaskFromId(Tid, TTask, Rec).
getTaskFromId([Id | Tid], [task(Start, Duration, End, Cost, Someid) | TTask] , Rec) :-
    dif(Id, Someid),
    getTaskFromId([Id | Tid], TTask, Rec).
    

getTaskConstraints([], _).
getTaskConstraints([task(Start, _, End, _, Id) | Rest], AllTasks) :-
    findall(Top, 
            on(Top, Id), 
            OnTopOfs),

    getTaskFromId(OnTopOfs, AllTasks, OnTopOfsTasks),
    getAllParamaters(OnTopOfsTasks, AllTopEndTimes, AllTopStartTimes),
    applyTopConstraint(Start, AllTopEndTimes),

    findall(Bottom,
	    on(Id, Bottom),
	    Bottoms),

    getTaskFromId(Bottoms, AllTasks, BottomTasks),
    getAllParamaters(BottomTasks, AllBottomEndTimes, AllBottomStartTimes),
    applyBottomConstraint(End, AllBottomStartTimes),

    getTaskConstraints(Rest, AllTasks).

applyBottomConstraint(_, []).
applyBottomConstraint(End, [BottomStart | TBottomStart]) :-
    BottomStart #>= End,
    applyBottomConstraint(End, TBottomStart).

applyTopConstraint(_, []).
applyTopConstraint(Start, [TopEnd | TTopEnd]) :-
    Start #>= TopEnd,
    applyTopConstraint(Start, TTopEnd).















