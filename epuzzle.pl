/*
------------------------------------------------------------------------
File:    epuzzle.pl

Program Description:
Solves the 8-puzzle problem.
------------------------------------------------------------------------
Author:  David Moreno-Bautista
Date:    June 10, 2019
------------------------------------------------------------------------
 */

solve:-
	h_function([2,8,3,1,6,4,7,0,5, 0], Start), % calculate the heuristic value for the start state
	h_function([1,2,3,8,0,4,7,6,5, 0], Goal), % calculate the heuristic value for the goal state
	% begin the search as follows:
	% first parameter: start state - current position of the puzzle
	% second parameter: goal state - solved puzzle position
	% third parameter: list to hold all possible moves from current state (start state is the first)
	% fourth parameter: the path from start to goal will be recorded through recursion
	path(Start, Goal, [Start], Closed),
	% display start state to screen
	write('START STATE:'),nl,
	write(2), write(' '), write(8), write(' '), write(3), nl,
	write(1), write(' '), write(6), write(' '), write(4), nl,
	write(7), write(' '), write(0), write(' '), write(5), nl,
	% display the path recorded
	displayPath(Closed).

% if current state is equal to goal state, the goal has been reached and recursion stops
path([A1,B1,C1,D1,E1,F1,G1,H1,I1,J1], [A1,B1,C1,D1,E1,F1,G1,H1,I1,J1], _, _):- !.
% first parameter: array of current state
% second parameter: array of goal state
% third parameter: 2D array of possible child states
% fourth parameter: 2D array of state moves towards goal
path([A0,B0,C0,D0,E0,F0,G0,H0,I0, J0], [A1,B1,C1,D1,E1,F1,G1,H1,I1, J1], Open, Closed):-
	left([A0,B0,C0,D0,E0,F0,G0,H0,I0, J0], [A2,B2,C2,D2,E2,F2,G2,H2,I2, J2]), % move blank tile left from current state
	up([A0,B0,C0,D0,E0,F0,G0,H0,I0, J0], [A3,B3,C3,D3,E3,F3,G3,H3,I3, J3]), % move blank tile up from current state
	right([A0,B0,C0,D0,E0,F0,G0,H0,I0, J0], [A4,B4,C4,D4,E4,F4,G4,H4,I4, J4]), % move blank tile right from current state
	down([A0,B0,C0,D0,E0,F0,G0,H0,I0, J0], [A5,B5,C5,D5,E5,F5,G5,H5,I5, J5]),% move blank tile down from current state
	% sort these child states from smallest to biggest in terms of heuristic value
	bubblesort([ [A2,B2,C2,D2,E2,F2,G2,H2,I2, J2], [A3,B3,C3,D3,E3,F3,G3,H3,I3, J3], [A4,B4,C4,D4,E4,F4,G4,H4,I4, J4], [A5,B5,C5,D5,E5,F5,G5,H5,I5, J5] | Open], SortedChildren),
	retsmallest(SortedChildren, Smallest, NewOpen), % chose the child state with the smallest heuristic value as the next state in the search
	% continue path recursively as follows:
	% first parameter: array of new current state (the smallest child)
	% second parameter: array of goal state
	% third parameter: 2D array of possible child states sorted from smallest to biggest by heuristic
	% fourth parameter: temporary empty array to be passed until goal is reached
	path(Smallest, [A1,B1,C1,D1,E1,F1,G1,H1,I1, J1], NewOpen, ClosedTemp),
	% once the goal is reached, add the current move as the head of the Moves list recursively
	% this ensures the last move is at the end, and the first move is at the start
	Closed = [Smallest|ClosedTemp].

% prints the moves from the array one at a time, from start to finish
displayPath([]):- !.
displayPath([[A,B,C,D,E,F,G,H,I, J]|T]) :-
	write('NEXT MOVE- Heuristic value: '), write(J), nl,
	write('|'), nl,
	write('V'), nl,
	write(A), write(' '), write(B), write(' '), write(C), nl,
	write(D), write(' '), write(E), write(' '), write(F), nl,
	write(G), write(' '), write(H), write(' '), write(I), nl,
	displayPath(T).

% first parameter: array of current state
% second parameter: array of next state
left([A,0,C,D,E,F,G,H,I,J] , [0,A,C,D,E,F,G,H,I,J1]):-
	h_function([0,A,C,D,E,F,G,H,I,J],[0,A,C,D,E,F,G,H,I,J1]).
left([A,B,0,D,E,F,G,H,I,J] , [A,0,B,D,E,F,G,H,I,J1]):-
	h_function([A,0,B,D,E,F,G,H,I,J],[A,0,B,D,E,F,G,H,I,J1]).
left([A,B,C,D,0,F,G,H,I,J] , [A,B,C,0,D,F,G,H,I,J1]):-
	h_function([A,B,C,0,D,F,G,H,I,J] ,[A,B,C,0,D,F,G,H,I,J1]).
left([A,B,C,D,E,0,G,H,I,J] , [A,B,C,D,0,E,G,H,I,J1]):-
	h_function([A,B,C,D,0,E,G,H,I,J],[A,B,C,D,0,E,G,H,I,J1]).
left([A,B,C,D,E,F,G,0,I,J] , [A,B,C,D,E,F,0,G,I,J1]):-
	h_function([A,B,C,D,E,F,0,G,I,J],[A,B,C,D,E,F,0,G,I,J1]).
left([A,B,C,D,E,F,G,H,0,J] , [A,B,C,D,E,F,G,0,H,J1]):-
	h_function([A,B,C,D,E,F,G,0,H,J],[A,B,C,D,E,F,G,0,H,J1]).
% these positions are invalid, so really high heuristic ensures they are not chosen:
left([0,B,C,D,E,F,G,H,I,_] , [0,B,C,D,E,F,G,H,I,99]).
left([A,B,C,0,E,F,G,H,I,_] , [A,B,C,0,E,F,G,H,I,99]).
left([A,B,C,D,E,F,0,H,I,_] , [A,B,C,D,E,F,0,H,I,99]).

% first parameter: array of current state
% second parameter: array of next state
up([A,B,C,0,E,F,G,H,I,J] , [0,B,C,A,E,F,G,H,I,J1]):-
	h_function([0,B,C,A,E,F,G,H,I,J],[0,B,C,A,E,F,G,H,I,J1]).
up([A,B,C,D,0,F,G,H,I,J] , [A,0,C,D,B,F,G,H,I,J1]):-
	h_function([A,0,C,D,B,F,G,H,I,J],[A,0,C,D,B,F,G,H,I,J1]).
up([A,B,C,D,E,0,G,H,I,J] , [A,B,0,D,E,C,G,H,I,J1]):-
	h_function([A,B,0,D,E,C,G,H,I,J],[A,B,0,D,E,C,G,H,I,J1]).
up([A,B,C,D,E,F,0,H,I,J] , [A,B,C,0,E,F,D,H,I,J1]):-
	h_function([A,B,C,0,E,F,D,H,I,J],[A,B,C,0,E,F,D,H,I,J1]).
up([A,B,C,D,E,F,G,0,I,J] , [A,B,C,D,0,F,G,E,I,J1]):-
	h_function([A,B,C,D,0,F,G,E,I,J],[A,B,C,D,0,F,G,E,I,J1]).
up([A,B,C,D,E,F,G,H,0,J] , [A,B,C,D,E,0,G,H,F,J1]):-
	h_function([A,B,C,D,E,0,G,H,F,J],[A,B,C,D,E,0,G,H,F,J1]).
% these positions are invalid, so really high heuristic ensures they are not chosen:
up([0,B,C,D,E,F,G,H,I,_] , [0,B,C,D,E,F,G,H,I,99]).
up([A,0,C,D,E,F,G,H,I,_] , [A,0,C,D,E,F,G,H,I, 99]).
up([A,B,0,D,E,F,G,H,I,_] , [A,B,0,D,E,F,G,H,I, 99]).

% first parameter: array of current state
% second parameter: array of next state
right([0,B,C,D,E,F,G,H,I,J] , [B,0,C,D,E,F,G,H,I,J1]):-
	h_function([B,0,C,D,E,F,G,H,I,J],[B,0,C,D,E,F,G,H,I,J1]).
right([A,0,C,D,E,F,G,H,I,J] , [A,C,0,D,E,F,G,H,I,J1]):-
	h_function([A,C,0,D,E,F,G,H,I,J],[A,C,0,D,E,F,G,H,I,J1]).
right([A,B,C,0,E,F,G,H,I,J] , [A,B,C,E,0,F,G,H,I,J1]):-
	h_function([A,B,C,E,0,F,G,H,I,J],[A,B,C,E,0,F,G,H,I,J1]).
right([A,B,C,D,0,F,G,H,I,J] , [A,B,C,D,F,0,G,H,I,J1]):-
	h_function([A,B,C,D,F,0,G,H,I,J],[A,B,C,D,F,0,G,H,I,J1]).
right([A,B,C,D,E,F,0,H,I,J] , [A,B,C,D,E,F,H,0,I,J1]):-
	h_function([A,B,C,D,E,F,H,0,I,J],[A,B,C,D,E,F,H,0,I,J1]).
right([A,B,C,D,E,F,G,0,I,J] , [A,B,C,D,E,F,G,I,0,J1]):-
	h_function([A,B,C,D,E,F,G,I,0,J],[A,B,C,D,E,F,G,I,0,J1]).
% these positions are invalid, so really high heuristic ensures they are not chosen:
right([A,B,0,D,E,F,G,H,I,_] , [A,B,0,D,E,F,G,H,I,99]).
right([A,B,C,D,E,0,G,H,I,_] , [A,B,C,D,E,0,G,H,I,99]).
right([A,B,C,D,E,F,G,H,0,_] , [A,B,C,D,E,F,G,H,0,99]).

% first parameter: array of current state
% second parameter: array of next state
down([0,B,C,D,E,F,G,H,I,J] , [D,B,C,0,E,F,G,H,I,J1]):-
	h_function([D,B,C,0,E,F,G,H,I,J],[D,B,C,0,E,F,G,H,I,J1]).
down([A,0,C,D,E,F,G,H,I,J] , [A,E,C,D,0,F,G,H,I,J1]):-
	h_function([A,E,C,D,0,F,G,H,I,J],[A,E,C,D,0,F,G,H,I,J1]).
down([A,B,0,D,E,F,G,H,I,J] , [A,B,F,D,E,0,G,H,I,J1]):-
	h_function([A,B,F,D,E,0,G,H,I,J],[A,B,F,D,E,0,G,H,I,J1]).
down([A,B,C,0,E,F,G,H,I,J] , [A,B,C,G,E,F,0,H,I,J1]):-
	h_function([A,B,C,G,E,F,0,H,I,J],[A,B,C,G,E,F,0,H,I,J1]).
down([A,B,C,D,0,F,G,H,I,J] , [A,B,C,D,H,F,G,0,I,J1]):-
	h_function([A,B,C,D,H,F,G,0,I,J],[A,B,C,D,H,F,G,0,I,J1]).
down([A,B,C,D,E,0,G,H,I,J] , [A,B,C,D,E,I,G,H,0,J1]):-
	h_function([A,B,C,D,E,I,G,H,0,J],[A,B,C,D,E,I,G,H,0,J1]).
% these positions are invalid, so really high heuristic ensures they are not chosen:
down([A,B,C,D,E,F,0,H,I,_] , [A,B,C,D,E,F,0,H,I,99]).
down([A,B,C,D,E,F,G,0,I,_] , [A,B,C,D,E,F,G,0,I,99]).
down([A,B,C,D,E,F,G,H,0,_] , [A,B,C,D,E,F,G,H,0, 99]).

% first parameter: array of current state
% second parameter: array of current state with last value updated as the heuristic value
h_function([A,B,C,D,E,F,G,H,I,_], [A,B,C,D,E,F,G,H,I,J1]):-
	% calculate distance from goal state for each individual tile
	a(A,Pa), b(B,Pb), c(C,Pc),
	d(D,Pd), e(E,Pe), f(F,Pf),
	g(G,Pg), h(H,Ph), i(I,Pi),
	% sum all of their distances as the heuristic value
	J1 is Pa+Pb+Pc+Pd+Pe+Pf+Pg+Ph+Pi.

% e.g. if the top-left tile holds a one, the value is zero away from the goal state,
% but if it holds a five, it is four away from the goal state, since five is supposed
% to be at the bottom-right
a(0,0). a(1,0). a(2,1). a(3,2). a(4,3). a(5,4). a(6,3). a(7,2). a(8,1).
b(0,0). b(1,0). b(2,0). b(3,1). b(4,2). b(5,3). b(6,2). b(7,3). b(8,2).
c(0,0). c(1,2). c(2,1). c(3,0). c(4,1). c(5,2). c(6,3). c(7,4). c(8,3).
d(0,0). d(1,1). d(2,2). d(3,3). d(4,2). d(5,3). d(6,2). d(7,2). d(8,0).
e(0,0). e(1,2). e(2,1). e(3,2). e(4,1). e(5,2). e(6,1). e(7,2). e(8,1).
f(0,0). f(1,3). f(2,2). f(3,1). f(4,0). f(5,1). f(6,2). f(7,3). f(8,2).
g(0,0). g(1,2). g(2,3). g(3,4). g(4,3). g(5,2). g(6,2). g(7,0). g(8,1).
h(0,0). h(1,3). h(2,3). h(3,3). h(4,2). h(5,1). h(6,0). h(7,1). h(8,2).
i(0,0). i(1,4). i(2,3). i(3,2). i(4,1). i(5,0). i(6,1). i(7,2). i(8,3).

% sorts a list from smallest to largest using bubble sort
bubblesort(List,Sorted):-
	swap(List, List1),!,
	bubblesort(List1,Sorted).
bubblesort(Sorted,Sorted).

% smallest value is defined as the array with the smallest heuristic value (called J)
swap([[A0,B0,C0,D0,E0,F0,G0,H0,I0,J0],[A1,B1,C1,D1,E1,F1,G1,H1,I1,J1]|Rest],[[A1,B1,C1,D1,E1,F1,G1,H1,I1,J1],[A0,B0,C0,D0,E0,F0,G0,H0,I0,J0]|Rest]):-
	J0>J1.
swap([Z|Rest],[Z|Rest1]):-
	swap(Rest,Rest1).

% takes a sorted list and returns the smallest value (the head), and the rest of the values as their own list
retsmallest([Smallest|OpenRest], Smallest, OpenRest).
