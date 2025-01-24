#import "imports.typ":*

= Intro and Caesar cipher

- Key space: set of all possible keys
- Size of the key space $K = \#K$ must be large enough to avoid brute force

== Kerchoff rules

+ The system must be indecipherable
+ A cryptographic system must be secure even if the attacker knows all the details about the system with the exception of the key
+ It must be possible to communicate without written notes
+ It must apply to the telegraph
+ It must be portable
+ It must be simple

== Caesar's cipher

We translate letters to numbers $A -> 0, B -> 1, ...$ and the key is given by how 'A' is encrypted. For example:

$
A->S equiv 0 ->18 \
quad arrow.b.double \
e(0) = 0+ 18 quad ("18 is the key")
$

$e(x)$ is the remainder of the division

$
(x +18)/26 forall x in [0, 25]
$
