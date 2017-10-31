:- use_module(library(lists)).
:- use_module(library(clpfd)).


:-include('print.pl').

:- dynamic firstMove/1.

firstMove(1).


/**************************
**** FUNCTIONS TO MOVE ****
**************************/


%give a list of values
addNilSpaces(0, _, []).
addNilSpaces(Length, Value, [Value|NewList]):- 
NewLength is Length-1,
NewLength @>= 0,
addNilSpaces(NewLength, Value, NewList).

%insert new piece at specific position
insertAt(Piece,Column,Board,NewBoard) :-
same_length([Piece|Board],NewBoard),
append(Before,BoardAux,Board),
length(Before,Column),
append(Before,[Piece|BoardAux],NewBoard).

%replace one element on matrix
replace( L , X , Y , Z , R ) :-
append(RowPfx,[Row|RowSfx],L),     % decompose the list-of-lists into a prefix, a list and a suffix
length(RowPfx,X) ,                 % check the prefix length: do we have the desired list?
append(ColPfx,[_|ColSfx],Row) ,    % decompose that row into a prefix, a column and a suffix
length(ColPfx,Y) ,                 % check the prefix length: do we have the desired column?
append(ColPfx,[Z|ColSfx],RowNew) , % if so, replace the column with its new value
append(RowPfx,[RowNew|RowSfx],R).  % and assemble the transformed list-of-lists

addSpaceMatrix(Board, Length, NewBoard):-
addNilSpaces(Length, nil, AuxList1),
append([Board], [AuxList1], AuxNewBoard),
addNilSpaces(Length, nil, AuxList2),
append([AuxList2], AuxNewBoard, NewBoard).

/**
* Add a piece to the board
**/

%first move
addPiece(Board, Row, Column, PieceCode, Color, Rotation, NewBoard, NewColor):-
firstMove(X), X == 1,
retract(firstMove(X)),
append([[PieceCode,Rotation,Color,0]], Board, AuxBoard),
append([nil], AuxBoard, AuxTwoBoard),
length(AuxTwoBoard,Length),
addSpaceMatrix(AuxTwoBoard, Length, NewBoard),
prepareBoard(NewBoard).

addPiece(Board, Row, Column, PieceCode, Color, Rotation, NewBoard, NewColor):-
%verificar position se é válida (se esta vazia, ou se  está ao de uma peça já colocada)
replace(Board,Row,Column,[b,3,0,0], AuxBoard),
verifyExpandBoard(Row, Column, AuxBoard, NewBoard).




/**
* Checks if you need to expand the board
**/

%(0,0)
verifyExpandBoard(Row, Column, Board, NewBoard) :- 
Column == 0, Row == 0, !,
write('CASO 1'), nl,
addRowUp(Board, AuxBoard),
length(AuxBoard,Height),
addColNilsLeft(AuxBoard, Height, NewBoard). 

%(length, width)
verifyExpandBoard(Row, Column, [H | T], NewBoard) :- 
length([H | T], AuxHeight),
Height is AuxHeight - 1,
length(H, AuxWidth),
Width is AuxWidth - 1,
Column == Width, Row == Height, !,
write('CASO 2'), nl,
addRowDown([H | T], AuxBoard),
length(AuxBoard, NewHeight),
addColNilsRight(AuxBoard, NewHeight, NewBoard). 

%(0,width)
verifyExpandBoard(Row, Column, [H | T], NewBoard) :- 
length(H, AuxWidth),
Width is AuxWidth - 1,
Column == Width, Row == 0, !,
write('CASO 3'), nl,
addRowUp([H | T], AuxBoard),
length(AuxBoard,Height),
addColNilsRight(AuxBoard, Height, NewBoard). 

% Case (length, 0)
verifyExpandBoard(Row, Column, [H | T], NewBoard) :- 
length([H | T], AuxHeight),
Height is AuxHeight - 1,
Row == Height, Column == 0, !,
write('CASO 4'), nl,
addRowDown([H | T], AuxBoard),
length(AuxBoard,NewHeight),
addColNilsLeft(AuxBoard, NewHeight, NewBoard). 

% Case (0,-)
verifyExpandBoard(Row, Column, Board, NewBoard) :- 
Column == 0, !,
write('CASO 5'), nl,
length(Board,Height),
addColNilsLeft(Board, Height, NewBoard). 

% Case (-,0)
verifyExpandBoard(Row, Column, Board, NewBoard) :- 
Row == 0, !,
write('CASO 6'), nl,
addRowUp(Board, NewBoard).	

% Case (length, -)
verifyExpandBoard(Row, Column, [H | T], NewBoard) :- 
length([H | T], AuxHeight),
Height is AuxHeight - 1,
Row == Height, !,
write('CASO 7'), nl,
addRowDown([H | T], NewBoard).

% Case (-, width)
verifyExpandBoard(Row, Column, [H | T], NewBoard) :- 
length(H, AuxWidth),
Width is AuxWidth - 1,
Column == Width, !,
write('CASO 8'), nl,
addColNilsRight([H | T], AuxWidth, NewBoard). 

% Default case
verifyExpandBoard(Row, Column, Board, Board).



%add col of nils to left
addColNilsLeft([], 0, T2).
addColNilsLeft([H1 | T1], Height, [H2 | T2]) :-
append([nil], H1, H2),
NewHeight is Height - 1,
addColNilsLeft(T1, NewHeight, T2).

%add col of nils to right
addColNilsRight([], 0, T2).
addColNilsRight([H1 | T1], Height, [H2 | T2]) :-
length(H1, Pos),
insertAt(nil, Pos, H1, H2),
NewHeight is Height - 1,
addColNilsRight(T1, NewHeight, T2).

%add row of nils to up
addRowUp([H1 | T1], NewBoard) :-
length(H1, Width),
addNilSpaces(Width, nil, AuxList),
append([AuxList], [H1 | T1], NewBoard).

%add row of nils to down
addRowDown([H1 | T1], NewBoard) :-
length(H1, Width),
addNilSpaces(Width, nil, AuxList),
append([H1 | T1], [AuxList], NewBoard).


/****************
**** TESTING ****
*****************/

teste1 :- 
prepareBoard([
	[nil, nil, nil, nil, nil],
	[nil, nil, [a, 3, 0, 0], [b, 1, 0, 0], nil],
	[nil, [g, 0, 1, 0], [h, 0, 1, 0], [d, 0, 0, 0], nil],
	[nil, nil, nil, nil, nil]
	]).

teste_replace:-
board2(Board),
prepareBoard(Board),
prepareBoard(NewBoard2).


%Test for print all available white pieces.
teste2 :- printAvailablePieces(0, [0,[a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t]]).


%Test for print first move.
teste3 :- board1(Board), addPiece(Board, 1, 1, a, 0, 3, NewBoard, NewColor),
addPiece(NewBoard, 2, 1, a, 0, 3, NewBoard2, NewColor), prepareBoard(NewBoard2).


%test add multiples nils in a row
teste4 :- addNilSpaces( 5, nil, List).

%Test for print first move.
teste5 :- board2(Board), addPiece(Board, 2, 0, b, 1, 3, NewBoard, NewColor), prepareBoard(NewBoard).


board1([nil]).
board2([
	[nil, nil, nil],
	[nil, [a, 3, 0, 0], nil],
	[nil, nil, nil ]
	]).

