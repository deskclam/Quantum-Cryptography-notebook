#import "imports.typ":*

= Galois Fields (Theory of finite fields) <galois_fields>


#let GF = "GF"
Take a look at Rings, @rings



=== Properties with respect to sum

$ 
cases(
(a + b) + c = a + (b + c) = a + b + c   \
a + b = b + a\
exists 0 in ZZ_p "s.t." a + 0 = 0+ a = a quad forall a \
forall a in ZZ_p exists b in ZZ_p "s.t." b + a = 0
) \ ==> (ZZ, +) "is a commutative group"
$<sum_axioms>

=== Properties with respect to product


$ 
cases(
(a  dot b) c = a  dot (b  dot c)\

a dot  b = b  dot a\

exists bb(1) in ZZ_p "s.t." a bb(1) = bb(1) a = a quad forall a \

a dot (b + c) = a dot b + a dot c

) \ ==> (ZZ, dot) "is NOT a group (due to lack of the inverse)"
$<prod_axioms>

$(ZZ, + , dot)$ is a *commutative ring with unity*.

Notice that one of the differences between rings and groups is that rings have *two* operations while groups have only *one* operation. 

== Examples 
#[
  #set table(
    fill: (x, y) => {
      if (x ==0 or y == 0){
        luma(90%)
      }
      else if (calc.rem(y, 2) == 0){
        luma(95%)
      }
    },
  )
  #set figure(
    numbering: none
  )
#block(
  breakable: false,
example[
  Considering $ZZ_5$:

  #grid(
    columns: (1fr, 1fr),
    figure(
      table(
          columns: 6,
          [$+$], [0], [1], [2], [3], [4],
          [0], [0], [1], [2], [3], [4],
          .."1 1 2 3 4 0".split(" "),
          .."2 2 3 4 0 1".split(" "),
          .."3 3 4 0 1 2".split(" "),
          .."4 4 0 1 2 3".split(" "),
        ),
        caption: [We generate the whole group ciclically: $ZZ_5 = {a + x, x in ZZ_5}$]
 
    ),
    figure(
      table(
        columns: 6,
        [$dot$], [0], [1], [2], [3], [4],
        ..([0],) * 6,
        .."1 0 1 2 3 4".split(" "),
        .."2 0 2 4 1 3".split(" "),
        .."3 0 3 1 4 2".split(" "),
        .."4 0 4 3 2 1".split(" "),
      ),
    caption: [$ZZ_5 = {a dot x, x in ZZ_5}$ except for the first row]
    )
  )
]
)
\
#block(
  breakable: false,
example[
Now we do the same for $ZZ_6:$

  #grid(
    
    columns: (1fr, 1fr),
    figure(
      table(
        columns: 7,
        [$+$], [0], [1], [2], [3], [4], [5],
        [0], table.cell(rowspan: 6, colspan: 6, align: center+horizon)[... As before ...],
        [1], [2], [3], [4], [5],
      ),
      caption: []
    ),
  figure(
    table(
      columns: 7,
      [$dot$], [0], [1], [2], [3], [4], [5],
      ..([0],) * 7,
      [1], [0], [1], [2], [3], [4], [5],
      .."2 0 2 4 0 2 4".split(" "),
      .."3 0 3 0 3 0 3".split(" "),
      .."4 0 4 2 0 4 2".split(" "),
      .."5 0 5 4 3 2 1".split(" "),
    ),
    caption: [Now we don't get all the elements]
  )
)
]
)
]
*Observations:*

+ Some lines do not contain the whole set
+ This is not a *domain of integrity* (we get $0$ when neither of the elements are $0$)
+ When an element is missing in a line, also "$1$" is missing

The three phenomena above do not occur if $m$ is prime. In this case we also get property 4. for multiplication:

$ forall a in ZZ_p \\ {0}quad  exists a^(-1) "s.t." a^(-1)a = bb(1) $<mul_axiom>

#definition("Field")[
  If all the axioms in @sum_axioms, @prod_axioms and @mul_axiom are satisfied, we say that the set is a *field*.
]

#theorem("Fields")[
  $ZZ_m$ is a field $<==>$ $m$ is prime
]

*How many elements can a finite field have?*

#theorem[
  Given $m in NN$, a field with $m$ elements exists iff $m = p^n$ with $p$ prime and $n in NN$
]

#example[$128 = 2^7==> exists "a finite field with 128 elements"$]

#theorem[
  Given $m = p^k$ ($p$ prime) there is ("essentially") #underline[one] finite field with $m$ elements. \ It is denoted by $GF(m)$
]

Finite fields are split into 2 categories:

- *Prime fields:* with $m = p$, they are the $ZZ_p$
- *Extension fields:* with $m = p^n, n > 2$

== Structure of $G F(2^m)$

Intuition: consider $m$ copies of $ZZ_2$. We can imagine to construct a polynomial with $a_i$ as the coefficients:

$ A(x) = a_(m-1) x^(m-1) + a_(m-2) x^(m-2) + ... + a_1 x +a_0 quad a_i in ZZ^2 $

We want to define the *sum* and *product* operations:



#definition([Sum in extension fields $G F(2^m)$])[
$
A(x) = sum_(j=0)^(m-1)a_j x^j  quad 

B(x) = sum_(j=0)^(m-1)b_j x^j \

A(x) + B(x) = sum_(j=0)^(m-1) (a_j plus.circle b_j) x^j
$
]

For the product it is not as easy since the classical polynomial product is not closed (because when doing the classical product, we sum the exponents and this can cause them to become $> m$). We can "close" the multiplication by taking the modulo with respect to an irreducible polynomial (@irreducible_polynomial).

#definition([Product in extension fields $G F(2^m)$])[ \
Let $P(x) = sum_(j=0)^(m-1)p_j x^j, quad p_i in ZZ_2 = G F(2)$ be an irreducible polynomial, then: \
$ 
C(x) = A(x) dot B(x) mod P(x)
$
]
#exercise[
  Compute $A(x)B(x) mod P(x)$ given
  $ A, B in GF(2^4) \ A(x) = x^3 + x^2 + 1\ B=x^2 + x \ P(x) = x^4 + x + 1 in.not GF(2^4) $

  $ A(x) B(x) = x^5 + cancel(x^4 + x^4) + x^3 + x^2 +x = x^5 + x^3 + x^2 + x $

  We now have to perform polynomial division:
  #[
  #set align(center)
  #block(
    breakable: false,
      table(
        columns: 8,
        stroke: none,
        $x^5$, $+ x^3$, $+x^2$, $+x$, [], table.vline(), $x^4$, $+ x$, $+1$,
        table.hline(),
        $x^5$, $+ 0$, $+x^2$, $+x$, [], $x$, [], [],
        [], [*$x^3$*]
      )
    )
]

  This means that $ underparen(x^5 + x^3 + x^2 + x, a) = underparen(x^4 +x + 1, m) dot underparen(x, k) + underparen(x^3, r) ==> underparen(A B, a) = underparen(x^3,r) mod underparen(P, m) $
]


=== Inversion in $G F(2^m)$ <gf_inversion>

(This is the operation (with $m=8$) involved in AES)

Find $A^(-1) st A^(-1)(x)A(x) = 1 mod P(x)$ is difficult.

#example[
Find the inverse of $A(x) = x^7 + x^6 + x$ with $P=x^8 + x^4 + x^3 + x + 1$ (which is the AES polynomial).

+ Write $A$ as a binary string:
  - $A = (underbrace(1 1 0 0, "x = C") space underbrace(0 0 1 0, "y = 2")) = (C 2)_"hex"$
  
+ Go to the table in @lookup_inverrse at row $C$, column $2$ and you will find $2 F = (0010 space 1111) = x^5+ x^3 + x^2 + x + 1$

So $(x^7 + x^6 + x)(x^5+ x^3 + x^2 + x + 1) = 1 mod P(x)$
]

#exercise("Inverting a polynomial")[
  Compute the inverse of $B(x) = x^2+ x$ in $GF(2^4)$ using $P(x) = x^4 + x + 1$ as the inverting polynomial.
  
  We will use the algorithm described in @euclid_wallis.
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
    $x^4+x+1$, $0$, $1$, [],
    $x^2+x$, $1$, $0$, [],
    $1 = \ (x^4 + x + 1) - (x^2+x)$, $underline(x^2 + x + 1) = \ 0 - 1 dot x^2 + x + 1$, $1 = \ 1 - 0 dot x^2 + x + 1$, $x^2 + x + a = \ floor(x^4 + x + 1 slash x^2 + a)$
  )
  ]
  We can see that $B^(-1)(x) = x^2 + x + 1$.
] <inverting_polynomial>