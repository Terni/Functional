% Author: Terni
% License: MIT, see LICENSE

% Prolog port of goedel/fibonacci-prime-gcd.gdl.

% ------- Fibonacci

fib(0, 0).
fib(1, 1).
fib(K, N) :-
	K > 1,
	K2 is K - 2,
	fib_it(K2, 1, 1, N).

% F, G = the last two Fibonacci numbers.
% Unlike the Gödel version there is no `G < N` pruning: Prolog arithmetic needs N bound.
fib_it(0, _, G, G).
fib_it(K, F, G, N) :-
	K > 0,
	K1 is K - 1,
	FG is F + G,
	fib_it(K1, G, FG, N).
%?- fib(10, N).   % N = 55

% ------- Prime

prime(P) :-
	P > 1,
	P1 is P - 1,
	\+ ( between(2, P1, X), P mod X =:= 0 ).
%?- prime(7).   % true
%?- prime(1).   % false

% ------- GCD

gcd(I, J, D) :-
	common_divisor(I, J, D),
	\+ ( common_divisor(I, J, E), E > D ).

% The cut keeps the zero case from falling through to the general case.
common_divisor(I, J, D) :-
	( I =:= 0 ; J =:= 0 ), !,
	D is max(abs(I), abs(J)).
common_divisor(I, J, D) :-
	M is min(abs(I), abs(J)),
	between(1, M, D),
	I mod D =:= 0,
	J mod D =:= 0.
%?- gcd(12, 18, D).   % D = 6
