/*
------------------------------------------------------------------------
File:    crossing.pl

Program Description:
Solves the missionary and cannibal crossing problem.
------------------------------------------------------------------------
Author:  David Moreno-Bautista
Date:    May 30, 2019
------------------------------------------------------------------------
 */

solve:-
	% begin the search as follows:
	% first parameter: start state - all missionaries, cannibals, and the boat are on the left
	% second parameter: goal state - all missionaries, cannibals, and the boat are on the right
	% third parameter: the start state is the first one visited
	% fourth parameter: the path from start to goal will be recorded through recursion
	path([3,3,0,0,l], [0,0,3,3,r], [[3,3,0,0,l]], Moves),
	% print the path recorded
	displayPath(Moves).

% first parameter: array of current state
% second parameter: array of goal state
% third parameter: 2D array of states already visited
% fourth parameter: 3D array of state moves towards goal
path([CL0,ML0,CR0,MR0,B0], [CL1,ML1,CR1,MR1,B1], Visited, Moves):-
	move([CL0,ML0,CR0,MR0,B0], [CL2,ML2,CR2,MR2,B2], Description), % move from current state to all possible others
	safe(CL2,ML2,CR2,MR2), % only continue if no missionaries get eaten
	\+ member([CL2,ML2,CR2,MR2,B2], Visited), % only continue if this is a new path (no going backwards)
	% continue path recursively as follows:
	% first parameter: array of new current state
	% second parameter: array of goal state
	% third parameter: 2D array of states already visited (new state is added)
	% fourth parameter: temporary empty array to be passed until goal is reached
	path([CL2,ML2,CR2,MR2,B2], [CL1,ML1,CR1,MR1,B1], [[CL2,ML2,CR2,MR2,B2]|Visited], MovesTemp),
	% once the goal is reached, add the current move as the head of the Moves list recursively
	% this ensures the last move is at the end, and the first move is at the start
	Moves = [ [[CL0,ML0,CR0,MR0,B0], [CL2,ML2,CR2,MR2,B2], Description] | MovesTemp ].

% if current state is equal to goal state, the goal has been reached and recursion stops
path([CL0,ML0,CR0,MR0,B0], [CL0,ML0,CR0,MR0,B0], _, _):- !.

% prints the moves from the array one at a time, from start to finish
displayPath([]):- !.
displayPath([[FirstPos,SecondPos,Description]|T]) :-
   write(FirstPos), write(' -> '), write(SecondPos), write('  i.e.  '), write(Description), nl,
   displayPath(T).

% first parameter: array of current state
% second parameter: array of next state
% third parameter: description of move from current to next state
move([CL0,ML,CR0,MR,l], [CL1,ML,CR1,MR,r], 'One cannibal crosses from left to right'):-
	CL1 is CL0 - 1,
	CR1 is CR0 + 1.

move([CL0,ML,CR0,MR,r], [CL1,ML,CR1,MR,l], 'One cannibal crosses from right to left'):-
	CL1 is CL0 + 1,
	CR1 is CR0 - 1.

move([CL,ML0,CR,MR0,l], [CL,ML1,CR,MR1,r], 'One missionary crosses from left to right'):-
	ML1 is ML0 - 1,
	MR1 is MR0 + 1.

move([CL,ML0,CR,MR0,r], [CL,ML1,CR,MR1,l], 'One missionary crosses from right to left'):-
	ML1 is ML0 + 1,
	MR1 is MR0 - 1.

move([CL0,ML,CR0,MR,l], [CL1,ML,CR1,MR,r], 'Two cannibals cross from left to right'):-
	CL1 is CL0 - 2,
	CR1 is CR0 + 2.

move([CL0,ML,CR0,MR,r], [CL1,ML,CR1,MR,l], 'Two cannibals cross from right to left'):-
	CL1 is CL0 + 2,
	CR1 is CR0 - 2.

move([CL,ML0,CR,MR0,l], [CL,ML1,CR,MR1,r], 'Two missionaries cross from left to right'):-
	ML1 is ML0 - 2,
	MR1 is MR0 + 2.

move([CL,ML0,CR,MR0,r], [CL,ML1,CR,MR1,l], 'Two missionaries cross from right to left'):-
	ML1 is ML0 + 2,
	MR1 is MR0 - 2.

move([CL0,ML0,CR0,MR0,l], [CL1,ML1,CR1,MR1,r], 'One cannibal and one missionary cross from left to right'):-
	CL1 is CL0 - 1,
	ML1 is ML0 - 1,
	CR1 is CR0 + 1,
	MR1 is MR0 + 1.

move([CL0,ML0,CR0,MR0,r], [CL1,ML1,CR1,MR1,l], 'One cannibal and one missionary cross from right to left'):-
	CL1 is CL0 + 1,
	ML1 is ML0 + 1,
	CR1 is CR0 - 1,
	MR1 is MR0 - 1.

% check for no missionaries being eaten and validity of move
safe(CL,ML,CR,MR):-
	(CL =< ML ; ML = 0), % missionaries are not outnumbered on the left
	(CR =< MR ; MR = 0), % missionaries are not outnumbered on the right
	CL >= 0, ML >= 0, CR >= 0, MR >= 0,!. % prevent the attempt to move a cannibal or missionary from a side that doesn't have one
