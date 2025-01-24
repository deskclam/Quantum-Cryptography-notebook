#import "imports.typ":*
= Diffie Hellman

The basic idea is that Alice and Bob must perform 2 mathematical operations that are easy to do and difficult to undo and must *commute* with each other. The difficult property to achieve is the second one: we want an operation easy to do and difficult to undo.

#[
#set align(center)  
#diagram(
spacing: (10mm, 5mm), // wide columns, narrow rows
node-stroke: 1pt, // outline node shapes
edge-stroke: 1pt, // make lines thicker
mark-scale: 60%, // make arrowheads smaller
node((0.3,0), $(alpha^b)^a$, stroke:0pt),
node((1,0), "Alice"),
edge((1.1,0), (5,0),  "-|>", $alpha^a$, bend: 35deg),
edge((5,0), (1.1,0),  "-|>", $alpha^b$, bend: 35deg),
node((5,0), "Bob"),
node((5.7,0), $(alpha^a)^b = alpha^(a b)$, stroke:0pt),
)
]

*Note*: $alpha$ was sent in the insecure channel and so we must assume that Eve knows that; at this point we can simplify the protocol and make $alpha$ public (i.e. Alice's public key).

- We assume that Eve knows $alpha, alpha^a, alpha^b$ but she doesn't know neither $a$ nor $b$.

To find $a$ and $b$, Eve must solve $alpha^x = M$, where $M$ is the intercepted message. This is easy to do in $RR$ but not in $ZZ_m$.

#definition("Discrete logarithm")[
$
x = log_alpha (M) \
alpha, x, M "are integers"
$
] <discrete_log>

The discrete logarithm problem is *exponential* in the number of bits.

The exponentiation in $ZZ_m$ is easy to do and difficult to undo and is thus a *1-way function*.

== Private and public keys

Note that $m$ must be public too and thus the public key is given by $k_"pub" = (alpha, m)$, the private keys, on the other hand, are $k_"priv"^A = a$ and $k_"priv"^B = b$

#example[
  Solve $3^x = 2 mod 5$ 
  
  We can do this by bruteforce and find $x = 3$
]

#example[
  Solve $3^x =7 mod 11$
  #[
  #set align(center)  
#table(
  columns: 12,
  table.header([$x$],
  ..for i in range(11){
    ([#i],)
  },
  ),
  [$3^x$],
  ..for i in (1, 3, 9, 5, 4, 1, 3){(
    [#i],
  )}, 
  table.cell(colspan: 4, align: center)[... periodic ...]
)  
  ]

This equation has no solution, $alpha =3$ and $m=11$ is a bad public key because it restricts the space of the final key that can be constructed.

]

#example[
  Solve $2^x =7 mod 11$
  #[
  #set align(center)  
#table(
  columns: 12,
  table.header([$x$],
  ..for i in range(11){
    ([#i],)
  },
  ),
  [$2^x$],
  ..for i in (1, 2, 4, 8, 5, 10, 9, 7, 3 , 6 ,1){(
    [#i],
  )}
)  
]
In this case we cover all $ZZ_11$ except $0$.
]
=== Procedure for key exchange <procedureDH>
- Setup (Alice)
  + Choose a large prime number $p$ ($ZZ_p$)
  + Choose $alpha in {2, dots, p-2} $
  + Publish $p "and" alpha$

  _Comment:_ why not $alpha = p-1$?

  Because when exponentiating $ alpha^a = (p-1)^a= sum_(j=0) ^a p^j (-1)^(a-j) equiv (-1)^(a-j) $ 
- Exchange
  + Alice ($A$) chooses $a= k_(p r, A)$ (private) $in {2, dots, p-2}$
  + $A$ computes $A= alpha^a$
  + $A$ sends $alpha^a$ to Bob ($B$)
  + Analogously, Bob chooses $b= k_(p r, b) in {2, dots, p-2}$
  + $B$ computes $B= alpha^b$ 
  + Bob sends $B$ to Alice
  + Alice computes $B^a = (alpha^b)^a$ and Bob computes $A^a = (alpha^a)^b$
  
== Finite group theory

We are given a set $G$ with an internal operation $compose$ (aka _pallicchero_).

#definition("Internal operation")[
  An internal operation is a map \
  #set math.cases(reverse: true)
  $
  cases(
    cal(G) times cal(G) |-> cal(G) \
    (x,y) |-> x compose y
  )
  "This implies that" cal(G) "is closed with respect to" quote compose quote
  $
]

#definition("Group")[
  $(cal(G), compose)$ is a group if: \
  + $forall x,y,z in cal(G) -> (x compose y) compose z = x compose(y compose z) =x compose y compose z$ (*associativity*)
  + $exists e in cal(G) st e compose x = x compose e = x quad forall x in cal(G)$ (*neutral element*)
  + $forall x in cal(G) quad exists x^(-1) in cal(G) st space x compose x^(-1) = x^(-1) compose x = e$ (*inverse*)
]

#definition("Commutative or abelian group")[
  If a group $(cal(G), compose)$ enjoys commutativity, i.e. $forall x,y in cal(G) quad x compose y = y compose x$ it is called commutative or abelian.
]

*Does $ZZ_m$ form a group?*

+ $(ZZ_m, +)$? Yes
+ $(ZZ_m, compose)$? No, because "$0$" never has an inverse
+ $(ZZ_m without {0}, compose)$ *Yes, but only if $m$ is prime*

#definition[
  Given $m in NN$, we can define \
  $ ZZ_m^* = ZZ_m without  {n in ZZ_m st gcd(n,m) > 1} $
]

It is easy to show that $ZZ_m^*$ is a group, in fact:


+ Associativity comes from $ZZ_m$
+ The neutral element "$1$" is in $ZZ_m^*$ because $gcd(1, m) =1$
+ The inverse exists by definition of $ZZ_m^*$ 
+ $ZZ_m^*$ is closed with respect to multiplication: $ x dot y in ZZ_m^* quad gcd(x dot y, m) = 1 $ because neither $x$ nor $y$ have a common factor with $m$.

#let zzms = [$ZZ_m^*$]
We can notice that $\#zzms = |zzms| = Phi(m)$.

#definition("Cyclicity")[
  $(cal(G), compose)$ is *cyclic* if $exists space alpha in cal(G) st$
  $ "Gen"(alpha) eq.delta {alpha^n, quad n=1,..., |cal(G)|} = cal(G) $
  with $ alpha^n = underbrace( alpha compose alpha compose ... compose alpha, n "times") $
]

#definition("Generator")[
  $alpha$ is said *generator* of $cal(G)$ and also a *primitive element*.
]

#definition("Subgroup")[
  A subgroup $(cal(S), compose )$ of a group $(cal(G), compose)$ is a subset of $cal(G)$ that has the structure of a group.

  A subset $cal(S)$ of a group $(cal(G), compose)$ is a subgroup of $cal(G)$ if and only if $cal(S)$ is closed with respect to "$compose$".
]
#let grp = [$(cal(G), compose)$]
#let gen = "Gen"
#remark[
Given a group #grp, the subset of $cal(G)$ defined by $gen(beta)= {beta^n, n= 1, dots ,abs(G)}$ is a subgroup if #grp.

Indeed, if we consider two elements of $gen(beta): x "and" y$, it must be $ x = beta^(n_1) and y = beta^(n_2) \ arrow.double.b \ x dot y = beta^(n_1 + n_2) = beta^(|cal(G)|) dot beta^(n_1 + n_2 mod |cal(G)|) $

If $cal(G) = ZZ_m^*$, then, by Euler's theorem (@euler_fermat_theo) we get that $beta^(|cal(G)|) = 1 mod m$ and finally $ x y = beta^(n_1 + n_2 mod |cal(G)|) in gen(beta) $
]
#definition("Order of an element of a group")[
  Given $(cal(G), compose)$ and $alpha in cal(G)$
  $
  "ord"(alpha) = min(n, st alpha^n = alpha)
  $

  (which is to say it is the "period of the orbit of $alpha$")
]

#definition("Order or cardinality of a group")[
  A group $(G, compose)$ is finite if it has a finite number of elements. We denote the *cardinality* or *order* of the group $G$ by $|G|$.
]



#theorem([Generalization of Euler's])[
  Let #grp be a finite group (i.e. with a finite number of elements), then $forall alpha in cal(G)$:
  + $alpha^(|cal(G)|) = e$ (where $e$ is the neutral element)
  + $"Ord"(alpha)$ divides $|cal(G)|$
]

#proof[ (For $zzms$)

  $|cal(G)| = Phi(m)$, then $ alpha^(|cal(G)|) &= alpha^(Phi(m)) \ #pin(60)&equiv
  1 (mod m)
  $

  #pin_left(60, [Euler, since $gcd(alpha, m) = 1$])
]

#theorem[ 
For every prime $p$, $(ZZ_p^*, compose)$ is an abelian, finite and cyclic group.
]

This is important for Diffie Hellman since we want to have $m$ prime and chose $alpha$ as a generator of #zzms

#theorem[
  Let #grp be a finite cyclic group, then:

  + The number of generators of $cal(G)$ is $Phi(|cal(G)|)$
  + If $|cal(G)|$ is prime, then all elements $alpha != e$ are generators.
]

#exercise[
  Determine wether the following groups are cyclic and, if so, find a generator:

  + $ZZ_3^*$: \ $ZZ_3^* = {1,2} quad 2^1 = 2, 2^2 = 4 equiv 1 ==>$ cyclic and 2 is a generator.
  + $ZZ_6^*$: \
    $ZZ_6^* = {1,5} quad 5^1 =5, 5^2 = 1 ==>$ cyclic and 5 is a generator
  + $ZZ_8^*$:\
    $ZZ_8^* = {1,3,5,7}$ $ &3^1 =3 quad 3^2 = 1 quad 3^3 = 3 &&==> 3 "is not a generator" \
    &7^1 = 7 quad 7^2 = 1 &&==> 7 "is not a generator" \
    &5^1 = 5 quad 5^2 = 1 &&==> 5 "is not a generator" \
    &&&arrow.double.b \  &&& ZZ_8^* "not cyclic"
    $
  
]

== Notes about Diffie Hellman


- $|ZZ_p^*| = p -1$ is *not prime*! So the number of generators of $ZZ_p^*$ is $Phi(p-1)$, then the choice of an optimal $alpha$ for Diffie Hellman is non trivial.

- Why don't we chose $alpha = p-1$? Because when we exponentiate we get the following $ alpha^a = (p-1)^a = sum_j^a p^j (-1)^(a-j) $ wich gives either $1$ or $p-1$.
- Why don't we chose $a$ and/or $b$ equal to $p-1$? Because, for Fermat's little theorem (@little_fermat_theo) $ alpha^a = alpha^(p-1) equiv 1 $
- It is important that $alpha$ generates a large subgroup of $ZZ_p^*$.

#theorem[Let #grp a finite cyclic group of cardinality $n$ and let $alpha$ be a generator of $cal(G)$.

$ forall k$ that divides $n$, $exists!$ cyclic subgroup $cal(H)$ of $cal(G)$ which has $k$ elements.

This subgroup is generated by $alpha^(n slash k)$ and consists of all elements $a st a^k = 1$.

There are no other subgroups.
]

#example[In the case of $ZZ^*_11$, $alpha = 8$ is a primitive (the order of the element $8= 10$, thus it generates all the elements of the group). In order to find a generator of a subgroup $beta$, for example the one of order $2$, we apply the theorem above, so: $ 
beta= alpha ^(n/k) = 8 ^(10/2)= 10 mod 11
$ 
Where $n$ is the order (cardinality) of the group, $k$ is the order (cardinality) of the subgroup.
]

== How to find a generator

Given $ZZ_p^*$, suppose it is a cycle, then how do we find a generator?

This is a difficult problem and, even if we manage to do that, we can use the Pohlig–Hellman algorithm to find the key in sub-exponential time.

We often look for generators of subgroups of $ZZ_p^*$ of cardinality $k$, with $k$ prime.

We can generalize the procedure seen above (@procedureDH) to overcome these problems:

We chose a group #grp and $alpha in cal(G)$. Both $cal(G)$ and $alpha$ are public.

#[
#set align(center)  
#diagram(
spacing: (10mm, 5mm), // wide columns, narrow rows
node-stroke: 1pt, // outline node shapes
edge-stroke: 1pt, // make lines thicker
mark-scale: 60%, // make arrowheads smaller
node((1,0), "Alice"),
edge((1.1,0), (5,0),  "-|>", $overbrace(alpha compose alpha ... compose alpha, a)$, bend: 35deg),
edge((5,0), (1.1,0),  "-|>", $underbrace(alpha compose alpha ... compose alpha, b)$, bend: 35deg),
node((5,0), "Bob"),
)
]

So, what Bob does is the following
$
underbrace(overbrace(alpha compose alpha ... compose alpha, a "times") compose overbrace(alpha compose alpha ... compose alpha, a "times") compose ... compose overbrace(alpha compose alpha ... compose alpha, a "times"), b "times")
$

while Alice performs the analogous operation with $a$ and $b$ swapped: 
$
underbrace(overbrace(alpha compose alpha ... compose alpha, b "times") compose overbrace(alpha compose alpha ... compose alpha, b "times") compose ... compose overbrace(alpha compose alpha ... compose alpha, b "times"), a "times")
$

By doing this, both Alice and Bob end up with "$alpha compose ...compose alpha$" repeated "$a dot b$" times.

What we would like to do now is choose a group #grp and an $alpha in cal(G)$ such that the operation of composition is difficult to invert knowing $alpha, beta$ and that $ underbrace(alpha dot dots dot alpha, x "times") = beta $

With these assumptions we would like to find $ x eq.delta log_alpha (beta) $

#definition("Generalized discrete logarithm problem")[
  $ x eq.delta log_alpha (beta) $
]

Elliptic curves provide a group structure where the discrete logarithm problem is very hard.

#exercise[8.1 and 8.3 from "Understanding cryptography"\
Determine the order of all elements of the multiplicative groups of: 
+ $ZZ^*_5$
+ $ZZ^*_7$
+ $ZZ^*_13$ 
\
+ #figure(table(
  columns: 5, table.header()[$a$][$1$][$2$][$3$][$4$][$"ord"(a)$][$1$][$4$][$4$][$2$]
),)
+ #figure(table(
  columns: 7, table.header()[$a$][$1$][$2$][$3$][$4$][$5$][$6$][$"ord"(a)$][$1$][$3$][$6$][$3$][$6$][$2$]
),)


+ #figure(table(
  columns: 13, table.header()[$a$][$1$][$2$][$3$][$4$][$5$][$6$][$7$][$8$][$9$][$10$][$11$][$12$][$"ord"(a)$][$1$][$12$][$3$][$6$][$4$][$12$][$12$][$4$][$3$][$6$][$12$][$2$]
),)

_How many elements does each of the multiplicative groups have?_:
1. $abs(ZZ^*_5)=4$
2. $abs(ZZ^*_7)=6$
3. $abs(ZZ^*_13)=12$

_Do all orders from above divide the number of elements in the corresponding
multiplicative group?_

Yes.

_Which of the elements from the tables are primitive elements?_
1. $ZZ^*_5$:$2, 3$
2. $ZZ^*_7$:$3, 5$
3. $ZZ^*_13$:$2, 6, 7, 11$
_Verify for the groups that the number of primitive elements is given by $phi.alt(abs(ZZ^*_p))$._
1. $ZZ^*_5$:$phi.alt(4)=2$
2. $ZZ^*_7$:$phi.alt(6)=2$
3. $ZZ^*_13$:$phi.alt(12)=4$

]
#exercise[ 8.5 from "Understanding cryptography"\
Compute the two public keys and the common key for the DHKE scheme with
the parameters $p = 467, alpha = 2$:
+ $a=3, b=5$
+ $a=400, b=134$
+ $a=228, b=57$ 
\
+ $a=3, b=5$:
  $
  k_A = 2^3 = 8, space k_B = 2^5 = 32, space
  k_(A B) = 2^(3*5) = 78 mod 467 
  $
+ $a=400, b=134$:
  $
  k_A = 2^ 400 = 137 mod 467, space k_B = 2^134 = 84 mod 467, \
  k_(A B) = 2^(400 dot 134) = 90 mod 467 
  $
+ $a=228, b=57$:
  $
  k_A = 2^228 = 394 mod 467, space k_B = 2^57 = 313 mod 467, \
  k_(A B) = 2^(228 dot 57) = 206 mod 467 
  $
]