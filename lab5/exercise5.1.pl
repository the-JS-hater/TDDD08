:- use_module(clpfd).

% container(Id, Workers, Duration)
% on(X, Y), container X is on top of container Y

% simple database:

% container(a,2,2).
% container(b,4,1).
% container(c,2,2).
% container(d,1,1).
% 
% on(a,d).
% on(b,c).
% on(c,d).

% Larger database:

container(aa, 2, 2). container(ab, 3, 2).
container(ac, 5, 5). container(ba, 6, 2).
container(bb, 1, 2). container(bc, 3, 3).
container(ca, 3, 2). container(cb, 5, 2).
container(cc, 2, 3).

on(aa, ba). on(ab, ba). on(ab, bb). on(ac, ba).
on(ac, bb). on(ac, bc). on(ba, ca). on(ba, cb).
on(bb, cb). on(bc, cb). on(bc, cc).

% Find the optimal schedule to minimize Cost = Workers * EndTime
schedule(Workers, EndTime, Cost) :-
		% domains, can't have 0 or negative amount of workers,
		% also cant' finish before atleast one time unit has passed	
    in(Workers, 1..100),
    in(EndTime, 1..100),
    
    % task(S_i, D_i, E_i, C_i, T_i).
		%	Get tasks in the form of task(start, duration, end, workers, idx)
		% from our container ground terms
    getTasks(Tasks),
		
		% Get a new list of tasks, but with contraints applied
    getTaskConstraints(Tasks, Tasks),
		
		% From a list of tasks, produce lists of all end- and start times 
		getAllParamaters(Tasks, AllEndTimes, AllStartTime),
		
		%	All tasks can, hypothetically, start immidietley
		%	bit no task can finish before atleast one time unit passes	
    ins(AllEndTimes, 1..100),
    ins(AllStartTime, 0..100),
		
		% contrain endtimes
    setEndTimeConstraint(EndTime, AllEndTimes),
    
		% Given from the excercise
    cumulative(Tasks, [limit(Workers)]),
    Cost #= Workers * EndTime,
    labeling([min(Cost)], [Cost | AllStartTime]).


% Minimum end time is essentially the duration of unloading the container
% regardless of other contraints (for now)
setEndTimeConstraint(_, []).
setEndTimeConstraint(EndTime, [ContainerEndTime | TContainerEndTime]) :-
    EndTime #>= ContainerEndTime,
    setEndTimeConstraint(EndTime, TContainerEndTime).


% From a list of tasks, produce lists of all end- and start times 
getAllParamaters([],[],[]).
getAllParamaters([task(Start, Duration, End, Cost, Id) | TTask], [End | TEndTime], [Start | TStartTime]) :-
    getAllParamaters(TTask, TEndTime, TStartTime).


% Use findall to "bag" all containers, and then reformat them into tasks using the getTasks\2 predicate
getTasks(Tasks) :-
    findall(container(Id, Cost, Duration), container(Id, Cost, Duration), Containers),
    getTasks(Containers, Tasks).

% using a list of all containers, reformat them into a list of tasks
getTasks([], []).
getTasks([container(Id, Cost, Duration)| CTail], [task(Start, Duration, End, Cost, Id) | TTail]) :-
    getTasks(CTail, TTail).

% from a list of id:s, get a list of the corresponding tasks
getTaskFromId([], _, []).
getTaskFromId([Id | Tid], [task(Start, Duration, End , Cost ,Id) | TTask], [task(Start, Duration, End, Cost, Id) | Rec]) :-
    getTaskFromId(Tid, TTask, Rec).
getTaskFromId([Id | Tid], [task(Start, Duration, End, Cost, Someid) | TTask] , Rec) :-
    dif(Id, Someid),
    getTaskFromId([Id | Tid], TTask, Rec).
    
% Get and apply time contraints for tasks that depend on the completion
% of other tasks due to on() circumstances
getTaskConstraints([], _).
getTaskConstraints([task(Start, _, End, _, Id) | Rest], AllTasks) :-
		
		% Get id of every container of top of the current one
		findall(Top, on(Top, Id), OnTopOfs),
		
		% Get all the tasks that need to end before current one 
		% can start  	
    getTaskFromId(OnTopOfs, AllTasks, OnTopOfsTasks),
    getAllParamaters(OnTopOfsTasks, AllTopEndTimes, AllTopStartTimes),
    % apply those contraints
		applyTopConstraint(Start, AllTopEndTimes),
		
		% Given the new contraints of current task,
		% we need to contrain all tasks dependent on
		% current task 	
    findall(Bottom,
	    on(Id, Bottom),
	    Bottoms),

    getTaskFromId(Bottoms, AllTasks, BottomTasks),
    getAllParamaters(BottomTasks, AllBottomEndTimes, AllBottomStartTimes),
    applyBottomConstraint(End, AllBottomStartTimes),

    getTaskConstraints(Rest, AllTasks).

% Everything below should be more or less self explanatory
% containers below cant start before container above:s endtime
% and vice versa...
applyBottomConstraint(_, []).
applyBottomConstraint(End, [BottomStart | TBottomStart]) :-
    BottomStart #>= End,
    applyBottomConstraint(End, TBottomStart).

applyTopConstraint(_, []).
applyTopConstraint(Start, [TopEnd | TTopEnd]) :-
    Start #>= TopEnd,
    applyTopConstraint(Start, TTopEnd).















