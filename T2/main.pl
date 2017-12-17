:-use_module(library(clpfd)).
:-use_module(library(lists)).
:-use_module(library(statistics)).

:-include('puzzles.pl').
:-include('utils.pl').

paintWay(List, Num, Pos):-
	length(List, L),
	Rest is L - Num,
	global_cardinality(List, [1-Num, 0-Rest]),
	element(Pos, List, 0).

% pos-1   | Number  | pos+1
% pos-n-1 | pos+n   | pos+n+1
getSubListFirstRow([Num-Pos], PuzzleF, [H1 | [H2 | [H3 | [H4 | [H5 | [H6]]]]]], N) :-
	Pos > 1, Pos < N, !,
	Pos1 is Pos - 1,
	nth1(Pos1, PuzzleF, H1),
	nth1(Pos, PuzzleF, H2), %pos number (2)
	Pos2 is Pos + 1,
	nth1(Pos2, PuzzleF, H3), 
	Pos3 is Pos - N - 1,
	nth1(Pos3, PuzzleF, H4),
	Pos4 is Pos + N,
	nth1(Pos4, PuzzleF, H5),
	Pos5 is Pos + N + 1,
	nth1(Pos5, PuzzleF, H6),
	paintWay([H1 | [H2 | [H3 | [H4 | [H5 | [H6]]]]]], Num, 2).

% pos-n  | pos-n+1 
% Number | pos+1  
% pos + n| pos + N + 1 
getSubListFirstCol([Num-Pos], PuzzleF, [H1 | [H2 | [H3 | [H4 | [H5 | [H6]]]]]], N) :-
	Aux is mod(Pos, N),
	Aux == 1, !,
	Pos1 is Pos - N,
	nth1(Pos1, PuzzleF, H1),
	Pos2 is Pos - N + 1,
	nth1(Pos2, PuzzleF, H2),
	nth1(Pos, PuzzleF, H3), %pos number
	Pos3 is Pos + 1,
	nth1(Pos3, PuzzleF, H4),
	Pos4 is Pos + N,
	nth1(Pos4, PuzzleF, H5),
	Pos5 is Pos + N + 1,
	nth1(Pos5, PuzzleF, H6),
	paintWay([H1 | [H2 | [H3 | [H4 | [H5 | [H6]]]]]], Num, 3).

% pos-n -1  | pos-n
% pos-1     | Number  
% pos + n-1 | pos + N  
getSubListLastCol([Num-Pos], PuzzleF, [H1 | [H2 | [H3 | [H4 | [H5 | [H6]]]]]], N) :-
	Aux is mod(Pos, N),
	Aux == 0, !,
	Pos1 is Pos - N - 1,
	nth1(Pos1, PuzzleF, H1),
	Pos2 is Pos - N,
	nth1(Pos2, PuzzleF, H2),
	Pos3 is Pos - 1,
	nth1(Pos3, PuzzleF, H3),
	nth1(Pos, PuzzleF, H4), % pos number(4)
	Pos4 is Pos + N - 1,
	nth1(Pos4, PuzzleF, H5),
	Pos5 is Pos + N,
	nth1(Pos5, PuzzleF, H6),
	paintWay([H1 | [H2 | [H3 | [H4 | [H5 | [H6]]]]]], Num, 4).

% pos-n-1 | pos-n   | pos-n+1
% pos-1   | Number  | pos+1
getSubListLastRow([Num-Pos], PuzzleF, [H1 | [H2 | [H3 | [H4 | [H5 | [H6]]]]]], N) :-
	Aux1 is (N*N-N+1), Aux2 is (N*N),
	Pos > Aux1, Pos < Aux2, !,
	Pos1 is Pos - N - 1,
	nth1(Pos1, PuzzleF, H1),
	Pos2 is Pos - N,
	nth1(Pos2, PuzzleF, H2), 
	Pos3 is Pos - N + 1,
	nth1(Pos3, PuzzleF, H3),
	Pos4 is Pos - 1,
	nth1(Pos4, PuzzleF, H4),
	nth1(Pos, PuzzleF, H5), %pos number (5)
	Pos5 is Pos + 1,
	nth1(Pos5, PuzzleF, H6),
	paintWay([H1 | [H2 | [H3 | [H4 | [H5 | [H6]]]]]], Num, 5).



% number | pos+1 
% pos+N  | pos+N+1
getSubListCorners([Num-Pos], PuzzleF, [H1 | [H2 | [H3 | [H4]]]], N) :-
	Pos == 1, !,
	nth1(Pos, PuzzleF, H1), %pos number (1)
	Pos1 is Pos + 1,
	nth1(Pos1, PuzzleF, H2),
	Pos2 is Pos + N,
	nth1(Pos2, PuzzleF, H3),
	Pos3 is Pos + N + 1,
	nth1(Pos3, PuzzleF, H4),
	paintWay([H1 | [H2 | [H3 | [H4]]]], Num, 1).

% pos-1 | number 
% pos+N-1  | pos+N
getSubListCorners([Num-Pos], PuzzleF, [H1 | [H2 | [H3 | [H4]]]], N) :-
	Pos == N, !,
	Pos1 is Pos - 1,
	nth1(Pos1, PuzzleF, H1),
	nth1(Pos, PuzzleF, H2), %pos number (2)
	Pos2 is Pos + N - 1,
	nth1(Pos2, PuzzleF, H3),
	Pos3 is Pos + N,
	nth1(Pos3, PuzzleF, H4),
	paintWay([H1 | [H2 | [H3 | [H4]]]], Num, 2).


% pos-n | pos-n+1 
% number  | pos+1
getSubListCorners([Num-Pos], PuzzleF, [H1 | [H2 | [H3 | [H4]]]], N) :-
	AuxN is (N * N) - N + 1,
	Pos == AuxN, !,
	Pos1 is Pos - N,
	nth1(Pos1, PuzzleF, H1),
	Pos2 is Pos - N + 1,
	nth1(Pos2, PuzzleF, H2),
	nth1(Pos, PuzzleF, H3), %pos number (3)
	Pos3 is Pos + 1,
	nth1(Pos3, PuzzleF, H4),
	paintWay([H1 | [H2 | [H3 | [H4]]]], Num, 3).


% pos-n-1| pos-n
% pos-1  | number
getSubListCorners([Num-Pos], PuzzleF, [H1 | [H2 | [H3 | [H4]]]], N) :-
	AuxN is N * N,
	Pos == AuxN, !,
	Pos1 is Pos - N - 1,
	nth1(Pos1, PuzzleF, H1),
	Pos2 is Pos - N,
	nth1(Pos2, PuzzleF, H2),
	Pos3 is Pos - 1,
	nth1(Pos3, PuzzleF, H3),
	nth1(Pos, PuzzleF, H4), %pos number (4)
	paintWay([H1 | [H2 | [H3 | [H4]]]], Num, 4).


getSubList(Pos, PuzzleF, [Head], N, Aux):-
	Aux == 9,!,
	nth1(Pos, PuzzleF, Head).

getSubList(Pos, PuzzleF, [Head | Tail], N, Aux):-
	(Aux == 3 ; Aux == 6),!,
	nth1(Pos, PuzzleF, Head),
	NewPos is Pos + N - 2,
	Aux1 is Aux + 1,
	getSubList(NewPos, PuzzleF, Tail, N, Aux1).

getSubList(Pos, PuzzleF, [Head|Tail], N, Aux):-
	nth1(Pos, PuzzleF, Head),
	Aux1 is Aux + 1,
	NewPos is  Pos + 1,
	getSubList(NewPos, PuzzleF, Tail, N, Aux1).

cycle([], _, _).

cycle([Num-Pos | T], PuzzleF, N):-
	getSubListCorners([Num-Pos], PuzzleF, List, N),
	cycle(T, PuzzleF, N).

cycle([Num-Pos | T], PuzzleF, N):-
	getSubListLastRow([Num-Pos], PuzzleF, List, N),
	cycle(T, PuzzleF, N).

cycle([Num-Pos | T], PuzzleF, N):-
	getSubListFirstRow([Num-Pos], PuzzleF, List, N),
	cycle(T, PuzzleF, N).

cycle([Num-Pos | T], PuzzleF, N):-
	getSubListFirstCol([Num-Pos], PuzzleF, List, N),
	paintWay(List, Num, 3),
	cycle(T, PuzzleF,N).

cycle([Num-Pos | T], PuzzleF, N):-
	getSubListLastCol([Num-Pos], PuzzleF, List, N),
	paintWay(List, Num, 4),
	cycle(T, PuzzleF, N).


/* Central */
cycle([Num-Pos | T], PuzzleF, N):-
	LeftTopPos is Pos - N - 1,
	getSubList(LeftTopPos, PuzzleF, List, N, 1),
	paintWay(List, Num, 5),
	cycle(T, PuzzleF, N).

/**
	Top Left Corner
*/
getClosure(PuzzleF, Pos, N, V, Cell):-
	Pos == 1,!,
	RightPos is Pos + 1,
	nth1(RightPos, PuzzleF, Right),
	UnderPos is Pos + N,
	nth1(UnderPos, PuzzleF, Under),
	DiagonalPos is Pos + N + 1,
	nth1(DiagonalPos, PuzzleF, Diagonal),
	element(Pos, PuzzleF, Cell),
	((Cell #= 1 #/\ Right #= 1 #/\ Under #= 1 #/\ Diagonal #= 0) #<=> V),
		V #= 1 #\/ Cell #= 0. 

/**
	Top Right Corner
*/
getClosure(PuzzleF, Pos, N, V, Cell):-
	Pos == N,!,
	LeftPos is Pos - 1,
	nth1(LeftPos, PuzzleF, Left),
	UnderPos is Pos + N,
	nth1(UnderPos, PuzzleF, Under),
	DiagonalPos is Pos + N - 1,
	nth1(DiagonalPos, PuzzleF, Diagonal),
	element(Pos, PuzzleF, Cell),
	((Cell #= 1 #/\ Left #= 1 #/\ Under #= 1 #/\ Diagonal #= 0) #<=> V),
		V #= 1 #\/ Cell #= 0. 

/**
	Bottom Left Corner
*/
getClosure(PuzzleF, Pos, N, V, Cell):-
	Aux is N*N - N + 1,
	Pos == Aux,!,
	RightPos is Pos + 1,
	nth1(RightPos, PuzzleF, Right),
	AbovePos is Pos - N,
	nth1(AbovePos, PuzzleF, Above),
	DiagonalPos is Pos - N + 1,
	nth1(DiagonalPos, PuzzleF, Diagonal),
	element(Pos, PuzzleF, Cell),
	((Cell #= 1 #/\ Right #= 1 #/\ Above #= 1 #/\ Diagonal #= 0)#<=> V),
		V #= 1 #\/ Cell #= 0. 

/**
	Bottom Right Corner
*/
getClosure(PuzzleF, Pos, N, V, Cell):-
	Aux is N*N,
	Pos == Aux,!,
	LeftPos is Pos - 1,
	nth1(LeftPos, PuzzleF, Left),
	AbovePos is Pos - N,
	nth1(AbovePos, PuzzleF, Above),
	DiagonalPos is Pos - N - 1,
	nth1(DiagonalPos, PuzzleF, Diagonal),
	element(Pos, PuzzleF, Cell),
	((Cell #= 1 #/\  Left #= 1 #/\ Above #= 1 #/\ Diagonal #= 0) #<=> V),
		V #= 1 #\/ Cell #= 0. 

/**
	First Row
*/
getClosure(PuzzleF, Pos, N, V, Cell):-
	Pos > 1, Pos < N,!,
	LeftPos is Pos - 1,
	RightPos is Pos + 1,
	UnderPos is Pos + N,
	nth1(LeftPos, PuzzleF, Left),
	nth1(RightPos, PuzzleF, Right),
	nth1(UnderPos, PuzzleF, Under),
	element(Pos, PuzzleF, Cell),
	((Cell #= 1 #/\ ((Left #= 1 #/\ Right #= 1 #/\ Under #= 0) #\/ 
		(Left #= 1 #/\ Under #= 1 #/\ Right #= 0) #\/
		(Under #= 1 #/\ Right #= 1 #/\ Left #= 0)))#<=> V),
		V #= 1 #\/ Cell #= 0. 

/**
	Last Row
*/
getClosure(PuzzleF, Pos, N, V, Cell):-
	Aux is N*N - N + 1,
	Aux2 is N*N,
	Pos > Aux, Pos < Aux2, !,
	LeftPos is Pos - 1,
	RightPos is Pos + 1,
	AbovePos is Pos - N,
	nth1(LeftPos, PuzzleF, Left),
	nth1(RightPos, PuzzleF, Right),
	nth1(AbovePos, PuzzleF, Above),
	element(Pos, PuzzleF, Cell),
	((Cell #= 1 #/\ ((Left #= 1 #/\ Right #= 1 #/\ Above #= 0) #\/ 
					(Left #= 1 #/\ Above #= 1 #/\ Right #= 0) #\/
					(Above #= 1 #/\ Right #= 1 #/\ Left #= 0)))#<=> V),
					V #= 1 #\/ Cell #= 0.

/**
	First Col
*/
getClosure(PuzzleF, Pos, N, V, Cell):-
	Aux is mod(Pos, N),
	Aux == 1, !,	
	AbovePos is Pos - N,
	RightPos is Pos + 1,
	UnderPos is Pos + N,
	nth1(AbovePos, PuzzleF, Above),
	nth1(RightPos, PuzzleF, Right),
	nth1(UnderPos, PuzzleF, Under),
	element(Pos, PuzzleF, Cell),
	((Cell #= 1 #/\ 
		((Above #= 1 #/\ Right #= 1 #/\ Under #= 0) #\/ 
		(Above #= 1 #/\ Under #= 1 #/\ Right #= 0) #\/
		(Under #= 1 #/\ Right #= 1 #/\ Above #= 0))) #<=> V),
		V #= 1 #\/ Cell #= 0.

/**
	Last Col
*/
getClosure(PuzzleF, Pos, N,  V, Cell):-
	Aux is mod(Pos, N),
	Aux == 0, !,	
	AbovePos is Pos - N,
	LeftPos is Pos - 1,
	UnderPos is Pos + N,
	nth1(AbovePos, PuzzleF, Above),
	nth1(LeftPos, PuzzleF, Left),
	nth1(UnderPos, PuzzleF, Under),
	element(Pos, PuzzleF, Cell),
	((Cell #= 1 #/\ 
		((Left #= 1 #/\ Above #= 1 #/\ Under #= 0) #\/ 
		(Left #= 1 #/\ Under #= 1 #/\ Above #= 0) #\/
		(Under #= 1 #/\ Above #= 1 #/\ Left #= 0))) #<=> V),
		V #= 1 #\/ Cell #= 0.

/**
	Middle
*/
getClosure(PuzzleF, Pos, N, V, Cell):-
	AbovePos is Pos - N,
	LeftPos is Pos - 1,
	RightPos is Pos + 1,
	UnderPos is Pos + N,
	nth1(AbovePos, PuzzleF, Above),
	nth1(LeftPos, PuzzleF, Left),
	nth1(RightPos, PuzzleF, Right),
	nth1(UnderPos, PuzzleF, Under),
	DiagonalPosUpLeft is Pos - N - 1,
	DiagonalPosUpRight is Pos - N + 1,
	DiagonalPosDownLeft is Pos + N - 1,
	DiagonalPosDownRight is Pos + N + 1,
	nth1(DiagonalPosUpLeft, PuzzleF, DiagonalUpLeft),
	nth1(DiagonalPosUpRight, PuzzleF, DiagonalUpRight),
	nth1(DiagonalPosDownLeft, PuzzleF, DiagonalDownLeft),
	nth1(DiagonalPosDownRight, PuzzleF, DiagonalDownRight),
	element(Pos, PuzzleF, Cell),
	((Cell #= 1 #/\
		((Left #= 1 #/\ Right #= 1 #/\ Above #= 0 #/\ Under #= 0) #\/ 
		(Left #= 1 #/\ Under #= 1 #/\ Above #= 0 #/\ Right #= 0 #/\ DiagonalUpRight #= 0) #\/
		(Under #= 1 #/\ Right #= 1 #/\ Above #= 0 #/\ Left #= 0 #/\ DiagonalUpLeft #= 0) #\/ 
		(Above #= 1 #/\ Right #= 1 #/\ Under #= 0 #/\ Left #= 0 #/\ DiagonalDownLeft #= 0) #\/ 
		(Above #= 1 #/\ Left #= 1 #/\ Under #= 0 #/\ Right #= 0 #/\ DiagonalDownRight #= 0) #\/ 
		(Above #= 1 #/\ Under #= 1 #/\ Left #= 0 #/\ Right #= 0))) #<=> V),
		V #= 1 #\/ Cell #= 0.

restrictionClosure(_, _, L, _, L).
restrictionClosure(PuzzleF, [Pos|T], Pos, N, L) :- 
	getClosure(PuzzleF, Pos, N, V, Cell),
	V == 1, !,
	NewPos is Pos + 1,
	restrictionClosure(PuzzleF, T, NewPos, N, L).
restrictionClosure(PuzzleF, List, Pos, N, L) :- 
	getClosure(PuzzleF, Pos, N, V, Cell),
	NewPos is Pos + 1,
	restrictionClosure(PuzzleF, List, NewPos, N, L).

getNumbers([], _, []).
getNumbers([H | T], Pos, [H-Pos | TR]):-
	H \== nil,!,
	NewPos is Pos + 1,
	getNumbers(T, NewPos, TR).
getNumbers([H | T], Pos, Numbers):-
	NewPos is Pos + 1,
	getNumbers(T, NewPos, Numbers).

solvePuzzle(Puzzle, N, L, Numbers, PuzzleF) :-
	length(PuzzleF, L),
    domain(PuzzleF, 0, 1),
    count(1,PuzzleF,#=, LengthCircuit),
    length(AuxList, LengthCircuit),
    domain(AuxList, 1, L),
    cycle(Numbers, PuzzleF, N),
    restrictionClosure(PuzzleF, AuxList, 1, N, L),
    %write(AuxList),
    %nth1(1, AuxList, FistBlackPos),
    %auxAdjacente(PuzzleF, FistBlackPos, N, LengthCircuit),
    labeling([minimize(LengthCircuit)], PuzzleF).

puzzle(N):-
	getPuzzle(N, Puzzle),
	printInitial(Puzzle, N),
    getNumbers(Puzzle, 1, Numbers),
    L is N*N,
	statistics(walltime, [TimeSinceStart | [TimeSinceLastCall]]),
    solvePuzzle(Puzzle, N, L, Numbers, PuzzleF),
    statistics(walltime, [NewTimeSinceStart | [ExecutionTime]]),
    printSolution(PuzzleF, Puzzle, N), nl, nl,
    write('Execution took: '), write(ExecutionTime), write(' ms.'), nl.



/*
teste(PuzzleF):-
	puzzle10(Puzzle),
	numbers10(Numbers),
	N is 10, %side of matrix
	L is N*N,
	length(PuzzleF, L),
	domain(PuzzleF, 0, 1),
	cycle(Numbers, PuzzleF, N),
	restrictionClosure(PuzzleF, AuxList, 1, N, L),
	labeling([], PuzzleF),
	write('Puzzle:::'), write(PuzzleF), nl,
	printPuzzle(PuzzleF, Puzzle, N, 1).*/

reload :- reconsult(main).
%teste2 :- findall(P-C, teste(P,C) , L), solution10(S), member(S-K,L), write(K).