#import "imports.typ":*

= Modular algebra

== Definition

$
a,r,m in ZZ \
m > 0 \
a equiv r mod m quad "if" m "divides" (a - r) \
"or in symbols:" m divides a - r
$


== Properties

=== Sum

$
cases(a = r mod m \ b = v mod m) arrow.double.long a + b = (r + v) mod m 
$

#proof[
  $
  a equiv r mod m => a = m k + r \
  b equiv v mod m => b = m h + b \
  arrow.b.double \
  a + b = m (k+ h) + r + v
  $
  This means that $m$ divides $(a + b) - (r + v)$, which is to say that $ ( a + b) equiv (r + v) mod m $
]
== Product

$
cases(a = r mod m \ b = v mod m) arrow.double.long a dot b = (r dot v) mod m 
$

#proof[
  $
  a b &= m^2 k h + m k v + m h r  + r v \
  &= m(m k h + k v + h r) + r v
  $
]

== Taking factors

Pay attention when taking factors in modular algebra.

#unbr_example[
  $ a dot b mod p equiv (a mod p dot b mod p) mod p $
]

#unbr_example[
  $ (x - x^2) mod p  & equiv [x(1-x)] mod p \ & equiv (x mod p) dot [(1-x) mod p] mod p $
]

== Inverse in $ZZ_m$

The inverse of $a$ in $ZZ_m$ is a number $b$ s.t. $b a = a b = 1 mod m$

#theorem("Uniqueness of the inverse")[The inverse is unique in $ZZ_m$]
#proof[Suppose $exists b, b' in ZZ_m st b a = b'a = 1 mod m$. Then 
$ 
b a equiv 1 mod m => b a = 1 + m k "for some" k in ZZ \  
b' a equiv 1 mod m => b' a = 1 + m k' "for some" k' in ZZ \  
arrow.b.double \
(b - b') a = m (k - k') equiv 0 mod m \
==> b = b' mod m \ 
$

proving that the inverse is unique (if it exists).]

#theorem("Existence of the inverse 1")[ \  $ "If" a "and" m  " are coprime" ==> exists space a^(-1) in ZZ_m $<exist_inv_1>]

#proof[
  We solve $a x = 1 mod m <==> x = 1 + m k$ for some $k$, which is to say that $a|1 + m k$.

  We should consider a watch with $a$ hours and find a $k$ for which $a = 1 + m k$:
  + If we try $k = 0$ we can see that it doesn't work
  + If we try $k = 1$ and we move  $m$ steps, when $m > a$ we wrap around the clock and get an effective increment on the watch equal to $n$ which is the remainder of $m slash a$: $ m equiv n mod a $<clock>

  We can observe that $gcd(n, a) = 1$ because otherwise we would get that exists $s$ which is a common factor, that divides both $n$ and $a$, in formulas: $n = n' dot s$ and $a = a' dot s$.
  For @clock we could thus write that, for some $h in ZZ$: $
  m &= n + a h \
  &= n' s + a' s h \
  &= s(n' + a' h) ==> s divides m
  $
  which means that $m$ and $a$ are not coprime (since $s$ divides both of them), contradicting the hypothesis (@exist_inv_1).

  We can then notice that the motion of the point on the watch is periodic since the number of position is finite (so they will repeat at some point) and since, given a position, the next one is fixed.

  We can also notice that the period cannot be $< a$ because, otherwise if $T < a$ then $ underbrace(T n, < a n) = tau a quad T, tau in NN $
  Since $T n = tau a$ is a common multiplier of both $n$ and $a$, we get that $"lcm"(a, n) < a n$ (since $T n < a n$) which means that $a$ and $n$ are not coprime, so the period is $a$. This means that:

  + The point visits all possible sites, including $a$
  + $exists macron(k) st a = 1 + macron(k)m ==> exists a^(-1)$
]

#theorem("Existence of the inverse 2")[ \  $ "If" a "and" m  "are NOT coprime" ==> exists.not space a^(-1) in ZZ_m $]

#proof[
  Having $a^(-1)$ means that exists $b st b a = 1 + m k$ for some $k$.
  
  Let $c$ be a common non-trivial divisor of $a$ and $m$, then $c divides b a$ while $c divides.not 1 + m k$, so $b = a ^(-1)$ does not exist.

]

== Domain of integrity

#definition("Domain of integrity")[
  A *domain of integrity* is a ring (see @rings) where product is commutative and with the following property: $ a dot b = 0 ==> a = 0 or b = 0$
]

In regular algebra: 

$
alpha beta = 0 arrow.double.long "either" alpha =0 "or" beta = 0
$

In modular algebra:

$
alpha beta equiv 0 mod p, p "prime" \
arrow.b.t.double \
alpha beta = k p \
"for some" k in ZZ
$

#theorem[

If $p$ is not prime then $ZZ_p$ is not a domain of integrity.

If $p$ is prime then $ZZ_p$ is a domain of integrity.
]<domain_of_int>


== Euler's $Phi$

#definition([Euler's $Phi$])[
$
n in NN \
"Given" Phi(n) = \#{p < n} + 1, p "coprime with" n
$]<eulers_phi>

#theorem("Euler's-Fermat")[

$
(a,m) "coprime" arrow.double.long a^(Phi(m)) equiv 1 mod m
$]<euler_fermat_theo>

#corollary[
  If $gcd(a, m) = 1$ then $forall b$ we have that $
    a^b equiv a^(b'), quad b equiv b' mod Phi(m)
  $
]<euler_fermat_corollary>

== Exercises on modular algebra

#exercise[
  Find all $x st x equiv x^s mod p$.

  $
  x - x^2 equiv 0 mod p \
  x (1-x) equiv 0 mod p
  $

  In $RR$ this would imply that either $x = 0$ or $x=1$ since $RR$ is a domain of integrity.

  *$p$ prime:*
  
  Since for @domain_of_int $ZZ_p$ with $p$ prime is a domain of integrity as well we can conclude that the solutions are $x = 0$ and $x=1$.

  *$p$ not prime:*

  Let's consider the example $p = 15$
  // If we consider $alpha beta equiv 0 mod p$ with $p$ prime, this is equivalent to $alpha beta = k p$ for some $k in ZZ$.

  // Suppose that $p$ does not divide neither $alpha$ nor $beta$; since $p$ is prime, it must be either $p divides alpha$ or $p divides beta$, which implies that either $alpha equiv 0$ or $beta equiv 0 mod p$, which tells us that:

  // *If $p$ is prime, $ZZ_p$ is a domain of integrity.*
]
