#import "imports.typ":*

= Random number generators

== True random number generators

Like coin tossing, noise in currents in semiconductors, measurements in chaotic systems (quantum measurements), for which the output is not reproducible.

== Pseudo random number generators

The output is deterministic but the sequences generated using this type of generators have good statistical properties.

$
cases(
  s_0 \
  s_(i +1) = f(s_i, s_(i-1), ..., s_(i-t))
) quad "t is called 'memory'"
$

=== Linear congruential generator

$ f(s)= a s + b mod m $

== Cryptographically secure PRNG

A PRNG such that, even knowing a part of the stream $s_i, s_(i+1), dots, s_(i+n)$ it is computationally infeasible to predict the following numbers of the stream.