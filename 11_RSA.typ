#import "imports.typ":*
= RSA

// #image("Images/rsa idea.png")
#[
#set align(center)  
#diagram(
spacing: (10mm, 5mm), // wide columns, narrow rows
node-stroke: 1pt, // outline node shapes
edge-stroke: 1pt, // make lines thicker
mark-scale: 60%, // make arrowheads smaller
node((0,0), "Alice"),
edge((0,0), "r", "--|>"),
edge((1,1), "u", "-|>"),
node((1,1), $e$),
node((1,0), "      "),
edge((1,0), "rr",  "-|>", $y = x^e$),
node((3,0), "Insecure channel", shape:pill),
edge((3,0), "rr",  "-|>", $y = x^e$),
edge((5,1), "u", "-|>"),
node((5,1), $d$),
node((5,0), "      "),
edge((5,0), (7,0),  "--|>", $y^d = x$),
node((7,0), "Bob"),
)
]

Advantage: no need of a secure channel

How can it be safe if we are only doing an exponentiation?

Finding the inverse is easy in $RR$, not so difficult in $ZZ$ and extremely difficult in $ZZ_m$ without knowing $m$.

== Example <examp_rsa>

#[
  #set enum(numbering: "a)")
  
  + Bob choses two prime numbers $p=5, q=7$
  
  + Bob multiplies them and gets $n=p dot q = 35$
  + Bob computes $Phi(35) =$ "\# of coprimes with 35, including 1" $={k >= 1, k < 35 st gcd(k,n) = 1}$
  + Bob choses $e in {1, ..., Phi(n) = 24}$ in a way that $gcd(e, 24) = 1$
  + Bob publishes the public key $= (e,n), 11, 35$ ($Phi$ is secret)
  + Alice encrypts the message $x = quote x quote = 88 mod 35 = 18$:
    - Encryption:
    $
    y = 18 ^ e = 18 ^ 11 mod 35 = ... = 2 mod 35
    $
  + To be able to decrypt, Bob must be able to know $d$, but $d = e ^(-1) mod bold(Phi(n))$

  To understand why we take the $mod bold(Phi(n))$, we should look at @euler_fermat_corollary.
  
=== Two possible sources of mistake!
+ Working with elements of $ZZ_m$, so in $mod(m)$, the exponents are to be computed $mod(Phi(m))$
+ All of this holds in the hypothesis $gcd(a,m)=1$. Then under such hypothesis, if $d=e^(-1) mod(Phi(n))$ then, $y^d equiv (x^e)^d equiv x^(e d) equiv x^(1 mod(Phi(n)))equiv x mod(n)$  
  #theorem[
    $
    p,q "primes and" n = p dot q \
    forall x in ZZ_m, forall e in ZZ_(Phi(n)), gcd(e, Phi(n)) = 1 \
    arrow.double.b \
    (x^e)^d equiv x mod n "where" d =e^(-1) "in" ZZ_(Phi_n)
    $
  ]
]

// #set enum(numbering: "1.")

#proof[
  We can split the proof into 2 parts:

  + Suppose that $gcd(x, n) = 1$, then $ (x^e)^d equiv x^(e d) equiv x^(1+t Phi(n)) equiv x dot ( x^Phi(n))^t equiv x $
  
  + Suppose now that $gcd(x, n) > 1$. Since $x != n$ (since $x in ZZ_n$), we get that either $x = r p$ or $x = s q$. \ Suppose that $x = r p$: $ x^(t Phi(n)) &= (r p)^(t Phi(n)) \ &= x^(t(p - 1)(q - 1)) \ &= (x^(Phi(q)))^(t(p-1)) \ &= 1^(t(p-1)) mod q \ &= 1 mod q \ &= 1 + u q $ Now $ x dot x^(t Phi(n)) &= r p (1 + u q) \ &= r p + r u p q \ &= x + r u n  \ & equiv x mod n \ &= x^(1 dot mod Phi(n)) \ &= x^(1 + t Phi(n)) \ & ==> x^(e d) = x mod n $
]
#remark[This does not imply the existence of $x^(-1)$]
== Complexity of RSA


We take a number $N= cal(A B C D)$, $N$ is "the number" and $n$ is the number of digits of $N$ (equal to 4 in this example).   

$n tilde.eq log N$

#definition("Polynomial complexity")[If a mathematical operation requires a number of steps that grows polynomially with $n$, it is said to be of *polynomial complexity*.]

#definition("Exponential complexity")[If a mathematical operation requires a number of steps that grows polynomially with $N$, it is said to be of *exponential complexity*]

We now look at the complexity of the different steps that need to be performed in RSA:
#[
#set enum(numbering: "1. a.")  
+ Key generation
  + Choice of $p$ and $q$: 
    - Polynomial
  + Compute $n = p dot q$:
    - Polynomial
  + Compute $Phi(n)$:
    - *Polynomial with the clever way*
    - *Exponential without knowing $p$ and $q$*
  + Selection of the public exponent $e in ZZ_(Phi(n))$:
    - Easy
  + Compute the private key $d = e^(-1) mod Phi(n)$:
    - Brute force: exponential
    - Extended Euclidian Algorithm: polynomial (but it requires to know $Phi(n)$)

+ Encryption:
  + $x^e = underbrace(x dot x dot x ... dot x, e "times")$:
    - Exponential
    - Polynomial (with fast exponentiation)
+ Decryption:
  + Same as encryption
]

== Euclidian algorithm

It is used to compute the $gcd$ and it is polynomial since the complexity decreases every 2 steps.

=== Example

Find $gcd(8151, 5390)$:

$
8151 = 3 dot 11 dot 14 dot 19 \
5390 = 2 dot 5 dot 7^2 dot 11 \
arrow.b.double \
gcd(8151, 5390) = 11
$

With the Euclidian algorithm: we write them as integer division with quotient and rest, recursively in order to find the gcd.

$ 

8151 &=  q dot &&5390 + r \
     &= 1 dot  &&underbracket(5390, arrow.b) + &&&&underbracket(2761, arrow.b) \ 
      & && 5390= &&&& underbracket(2761, arrow.b) + &&underbracket(2629, arrow.b)  \
     
 & &&&& &&2761= && underbracket(2629) + && underbracket(132, arrow.b) \ 
 & &&&& && &&2629= && underbracket(132, arrow.b) dot 19&&  + underbracket(121, arrow.b) \

 & &&&& && && &&132 = && quad  underbracket(121, arrow.b) + underbracket(11, arrow.b) \
 & &&&& && && && && quad 121 = 11 dot underbrace(11, gcd) + 0

$
The algorithm stops when $r=0$ meaning that we found the gcd.
// #warning[Non c'ho capito nulla]

#theorem[
  $
  r_0, r_1 in NN, r_0 > r_1
  $
  Then $ gcd(r_0, r_1) = gcd(r_1, r_2) $ where $ r_0 = q r_1 + r_2 $
  
]

== Extended Euclidian Algorithm (EEA)

The goal of this algorithm is to solve the Diophantine equation: $ gcd(r_0, r_1) = s r_0+ t r_1 $ in the unknowns $s$ and $t$ (which means that $r_0, r_1$ are given).

As a byproduct, if we want to find $b st b a = 1 mod m$, assuming $gcd(a, m) = 1$, we can then use $ 1= gcd(a,m) = s a + t m overbrace(-->, mod) 1= s a mod m $ and we finally get $ b = a ^(-1) = s $ 

#example[ Find $t "and" s$ for $r_0=8151, r_1=5390$

 #[
    #set math.equation(numbering: none,)
    #set text(size: 10pt)
    #table(
      align: left + horizon,
      columns: (0.1fr, 1fr, 1fr),
      [1], [$8151 = 5390 dot 1 + 2761$], [$ 2761 &= underbracket(1) dot 8151 space underbracket(- 1) dot 5390 $],
      [2], [$5390 = 2761 + 2629$], [$ 2629 &= 5390 - 2761 \ &= underbracket(-1) dot 8151 space underbracket(+2) dot 5390 $],
      [3], [$2761 = 2629+ 132$], [$ 132 &= 2761 - 2629 \ &= underbracket(2) dot 8151 space underbracket(-3) dot 5390 $],
      // table.cell(colspan: 3, align: center)[We can avoid computing the factors of $999$],
      [4], [$2629 = 19 dot 132 + 121 $], [$ 121 &= 2629 -19 dot 132 \ &= underbracket(-39) dot 8151 space underbracket(+59) dot 5390 $],
      [5], [$132 = 121 + 11$], [$ 11 &= 132 - 121 \ &= underbracket(41) dot 8151 space underbracket(-62) dot 5390 $],
      [6], [$121 = 11 dot 11 + 0$], []
    )
  ]
  
So $11 =underbracket(41, s) dot 8151 underbracket(-62, t) dot 5390 $.

=== Euclid-Wallis algorithm <euclid_wallis>

Another way of performing the same calculation is by using the Euclid-Wallis algorithm #footnote[You can find a detailed explanation here: #link("https://math.stackexchange.com/a/68021"). Notice that the table has been transposed to make the process easier for computing the inverse of polynomials: @inverting_polynomial.]:

#[
#let cred(x) = text(fill: red, $#x$)
#let cblue(x) = text(fill: blue, $#x$)
#let cgreen(x) = text(fill: green, $#x$)
#let corange(x) = text(fill: orange, $#x$)
#let cpurple(x) = text(fill: purple, $#x$)
  #show table: set text(size: 9pt)
  #set align(center)
  #table(
    columns: 4,
    align: center,
    fill: (x, y) => {
      let hl = ((0,0), (0,1), (1,0), (1,1), (2,0), (2,1))
      let res = ((0,6), (1,6), (2,6))
      if (hl.contains((x,y))){
        blue.lighten(50%)
      }
      else if (res.contains((x,y))) {
        red.lighten(60%)

      }
    },
    $r_0$, $B_0 = 0$, $C_0 = 1$, [/],
    $r_1$, $B_1 = 1$, $C_1 = 0$, [/],
    $r_2 = r_0 - r_1 dot D_2$, $B_2 = B_0 - B_1 dot D_2$, $C_2 = C_0 - C_1 dot D_2$, $D_2 = floor(r_0 slash r_1)$,
    table.cell(colspan: 4)[...],
    $r_i = r_(i-2) - r_(i-1) dot D_i$, $B_i = B_(i-2) - B_(i-1) dot D_i$, $C_i = C_(i-2) - C_(i-1) dot D_i$, $D_i = floor(r_(i-2) slash r_(i-1))$,
    table.cell(colspan: 4)[...],
    $gcd(r_0, r_1)$, $t$, $s$, $dots$,
    $0$,table.cell(colspan: 2)[/], [...]
  )

Applying this method to the example above gives:
  
#table(
  columns: 4,
  fill: (x, y) => {
      let res = ((0,6), (1,6), (2,6))
      if (res.contains((x,y))) {
        luma(90%)

      }
    },
  $8151$, $0$, $1$, [],
  $5390$, $cblue(1)$, $cblue(0)$, [],
  $2761$, $cgreen(-1) = 0 - (cblue(1) dot cred(1))$, $cgreen(1) = 1 - (cblue(0) dot cred(1))$, $cred(1) = floor(8151 slash 5390)$,
  $2629 = 8151 - cred(1) dot 2761$, $cpurple(2) = cblue(1) - (cgreen(-1) dot cred(1))$, $-1 = cblue(0) - (cgreen(-1) dot cred(1))$, $corange(1) = floor(5390 slash 2761)$,
  $132 = 2761 - corange(1) dot 2629$, $-3 = cgreen(-1) - (corange(1) dot cpurple(2))$, $2 = cgreen(1) - (-1 dot cpurple(1))$, $cpurple(1) = floor(5390 slash 2761)$,
  $121 = 2629 - 19 dot 132$, $59 = cpurple(2) - (-3 dot 19) $, $-39 = -1 -(2 dot 19)$, $19 = floor(2629 slash 132)$,
  $gcd =11 = 132 - (121 dot 1)$, $t = -62 = -3 - (59 dot 1) $, $s = 41 = 2 - (-39 dot 1)$, $1 = floor(132 slash 121)$,
  $0 = 121 - 11 dot 11$, [], [], $11 = floor(121 slash 11)$
)
]
Notice that the algorithm stops when we find $0$ in the first column. When we stop we can find the values of interest in the second to last row. Notice that if the two starting numbers $r_0$ and $r_1$ are coprime with each other, we will not find a $0$ in the first column but rather a $1$ (which is the $gcd$); in this case we will find the inverse of $r_1 mod r_0$ in the second column, last row.
]




== Fast exponentiation

Let's say we want to compute $x^8$:

*Naive method*:

$ underbrace(#diagram($x edge(->,M) & x^2 edge(->, M)& ... edge(->, M) & x^8$), 7 "multiplications") $

*Smart method*:

$ underbrace(#diagram($x edge(->, M) & x^2 edge(->,x^2 dot x^2) & x^4 edge(->, x^4 dot x^4)&  x^8$), 3 "steps") $

We went from $2^(n-1)$ steps to $n$.


== Improvement of RSA

Instead of using $Phi(n) = (p-1)(q-1)$, we replace it with $m = gcd(p-1, q-1) < Phi(n)$

Recalling @examp_rsa, where we had $p=7, q=5$, we get 

$ 
p-1 = 6, q-1 = 4 \ m = 12 < 24  = Phi(n) \
e = {0, 1, ..., m-1} \
gcd(e, m) = 1
$

The protocol still works since $forall x in ZZ_m, x^(e d) = x mod n ,  d = e ^(-1) in ZZ_n$ but the advantage is that the exponentiation is faster.

#theorem("Little Fermat Theorem")[
If $p$ is prime, then $forall a in ZZ$ $ a^(p-1) equiv 1 mod p $
] <little_fermat_theo>

@little_fermat_theo is a particular case of Euler's theorem, as $Phi(p) = p -1 forall p "prime"$

#proof[ Consider the set, given $a in ZZ_p$:
$ a(ZZ_p without {0})= {a, 2a, 3a, dots, (p-1)a} \ "and we want to prove that " = ZZ_p without {0}   $
First we want to prove that $0 in.not a(ZZ_p without {0}) $. \ Suppose that $0 in a(ZZ_p without {0}) <=> k a=0 mod p$. Now we consider the possible identity of the two elements in $a(ZZ_p without {0})$, which means the following: 

$ 
  r a = s a quad r,s in ZZ_p without {0}
$ <lft_eq1>

If $p$ is prime this means that the inverse exists, so that we can multiply both sides of @lft_eq1 by $a^(-1)$, giving us:

$
r cancel(a a^(-1)) = s cancel(a a^(-1))
$

which means that the two elements must coincide. Then, $a(ZZ_p without {0})$ is made of $p-1$ *distinct* elements of $ZZ_p without {0}$, which has cardinality equal to $p- 1$. Then:
$
  a(ZZ_p without {0}) = ZZ_p without {0} \
  arrow.double.b \
  product_(k in ZZ_p without {0}) k = product_(j in ZZ_p without {0})j
\
  cancel(1 dot 2 dot ... dot (p-1)) equiv a dot 2a dot 3a dot ... dot(p-1)a = cancel(1 dot 2 dot ... (p-1))a^(p-1)
\
  a^(p-1) equiv 1 mod p
$
  
]


#theorem("RSA with slight improvement")[
Given $x in ZZ_n$ \ $ x^(e d) = x mod n \ e d = 1 mod m => e d = 1+ k m 
\ x^(e d) = x dot x^(k m) 

$
but $m = r(p-1)$ so: $ x dot x ^(k r (p-1)) =  x dot (x ^(k r))^(p-1) equiv x mod p $
]
#proof[
$
x^(e d) = 1 mod n => e d = k m + 1, \
m= r(p-1) "(since "m" must be a multiple of" (p-1)")" \
x^(e d) = x dot x^(k m) = x dot x^(k r(p-1)) = x(x^(k r))^(p-1) overbrace(=, "FLT") x mod p \ arrow.double.b \
p | x^(e d) - x
$

Now we can do the same considering $m = s (q-1)$:

$
cases(q | x^(e d) - x \ p | x^(e d) - x) ==> underbrace(p q, n)| x^(e d) -x \
==> x^(e d) -x = cal(l) n \ ==> x^(e d) - x equiv 0 mod n \ ==> x^(e d) = x mod n
$
]


#exercise[

Find all the inverses of the elements in $ZZ_24$

#grid(
  columns: 3,
  column-gutter: 8pt,
  align: center+horizon,
table(
  columns: 2,
  [*$x$*], [*$x^(-1)$*],
  [1], [1],
  [2], [/],
  [3], [/],
  [4], [/],
  [5], [5],
  [6], [/],
),
table(
  columns: 2,
  [*$x$*], [*$x^(-1)$*],
  [7], [7],
  [11], [11],
  [13], [13],
  [17], [17],
  [19], [19],
  [23], [23],
),
[Every item with an inverse is the \inverse of itself like in Liguria]
)

Why is it true that $forall x in ZZ_24 space x equiv x^(-1) "if" gcd(x, 24) = 1$ ?

The condition $x^2 = 1$ means $x^2 = 1 + 24 k$ for some $k$  $<=> (x-1)(x+1) dot 24k$ it is a multiple of 24 thus contains the factors $2^3 dot 3$

One among $x-1, x, x+1$ is divided by $3$, but not $x$ which is coprime with 24. then either $x-1 "or" x+1$ is divisible by $3$ meaning that $(x-1)(x+1)= x^2 -1$ is divisible by $3$.

Moreover $x$ is odd, so $x-1 "and" x+1$ are two consecutive even numbers, then one of them must be divisible by $4$. So we have $2^2$ from one and $2$ from the other and the condition $x^2 = 1 + 24 k$ for some $k$ is satisfied $forall x$ coprime with $24$.

For which other $ZZ_n$ does it happen the same?
$(x+1)(x-1)= k n$. From three consecutive numbers one always collects the factors $2^3 dot 3$, then $n/24$ is the necessary and sufficient condition for having $x^2 =1 quad forall x$ coprime with $n$.

]

#exercise[
  Find the inverse of $19$ in $ZZ_999$.

  Since $gcd(19, 999) = 1$ we can be sure that the inverse $t$ exists and is unique:
  $
  exists! space t, s in ZZ st 1 = t dot 19 + s dot 999 \
  arrow.double.b \
  1 equiv t dot 19 mod 999 <==> t = 19^(-1)
  $
  #[
    #set math.equation(numbering: none,)
    #table(
      align: left + horizon,
      columns: (0.1fr, 1fr, 1fr),
      [], [Euclidian algorithm], [Finding the inverse],
      [1], [$999 = 52 dot 19 + 11$], [$ 11 &= underbracket(1) dot 999 space underbracket(- 52) dot 19 $],
      [2], [$19 = 11 + 8$], [$ 8 &= 19 - 11 \ &= underbracket(-1) dot 999 space underbracket(+53) dot 19 $],
      [3], [$11 = 8+ 3$], [$ 3 &= 11 - 8 \ &= underbracket(2) dot 999 space underbracket(-105) dot 19 $],
      table.cell(colspan: 3, align: center)[We can avoid computing the factors of $999$],
      [4], [$8 = 2 dot 3 + 2 $], [$ 2 = ... space underbracket(+263) dot 19 $],
      [5], [$3 = 2 + 1$], [$ 1 = ... space underbracket(-368) dot 19 $],
      [6], [$2 = 2 dot 1 + 0$], []
    )
  ]

  So $-368 equiv 19^(-1)$, which we can also write as $631 equiv 19^(-1)$ since $631 = 999 - 368$.
]

This algorithm can be used also for computing multiplicative inverses in Galois fields (@galois_fields, @inverting_polynomial): In $G F (2^m)$ the inputs of the algorithm are the field element $A(x)$ and the irreducible polynomial.
