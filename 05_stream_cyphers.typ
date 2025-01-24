#import "imports.typ":*

= Stream ciphers

== Working principle

We encode the message we want to send into binary digits $x_i$. We have a key stream generator that generates a stream of $s_i$.

We transmit $y_i = x_i + s_i mod 2$.

Bob can retrieve $x_i$ by doing $x_i = y_i + s_i mod 2$.

${s_0, s_1, ..., s_i}$ is called _key stream_.

The sum modulo 2 is a good operation because it is _invertible_ and it _"mixes"_ well the digits.

== Key stream based on PRNGs

#example[
$ cases(S_0 = "seed" \ S_(i+1) = A  S_i + B mod m) $

$m =(m_0, ..., m_99)$ is public, $A$ and $B$ are 100-bits each and together they form the 200-bit key.

$|cal(K)| = 2^200$

$X_j$ are the words that Alice sends:

$X_1 = (x_0, x_1, ..., x_99), X_2 = (x_100, x_101, ..., x_199)$
]
==== A possible attack

If Eve captures 300 bits $X_1, X_2, X_3$ then she can compute $S_1, S_2, S_3$ by subtraction, because $forall i = 0, ..., 299, quad X_i+S_i=Y_i$.

Now, $S_2= A S_1 + B mod m$ and $S_3= A S_2 +B mod m $ so:
$ S_2 -S_3 = A(S_1 -S_2) mod m ==>  A = (S_2 - S_3)(S_1 - S_2)^(-1) mod m $
supposing that $S_1-S_2$ is coprime with $m$
$ B= S_2 +(S_3-S_2)(S_1-S_2)^(-1) S_1 $



== Linear shift feedback register (LFSR)
#[
#set align(center)  
#diagram(
spacing: (10mm, 5mm), // wide columns, narrow rows
node-stroke: 1pt, // outline node shapes
edge-stroke: 1pt, // make lines thicker
mark-scale: 60%, // make arrowheads smaller
edge((-1,0), "rr", "-|>"),
node((1,0), "FF2"),
edge((1,0), "rr",  "-|>"),
node((3,0), "FF1"),
edge((3,0), "rr",  "-|>"),
node((5,0), "FF0"),
edge((5,0), (8,0),  "-|>", $ quad S_i$),
edge((6,0), "u,ll", "-|>"),
node((4,-1),[*+*]),
edge((4, 0), "u", "-|>"),
edge((4, -1), "llll,d", "-|>")
)
]         


The initial state cannot be made of all zeroes and the sequence is periodic since the number of configuration is finite.

The maximal period is equal to $2^n -1$ with $n$ the number of registers.

A more generic scheme is drawn below, where the coefficients $p_i$s represent if the circuit is closed or not:
- If $p_i$ = 1 the correspondent connection is closed
- If $p_i$ = 0 the correspondent connection is open

#[
#set align(center)  
#diagram(
spacing: (10mm, 5mm), // wide columns, narrow rows
node-stroke: 1pt, // outline node shapes
edge-stroke: 1pt, // make lines thicker
mark-scale: 60%, // make arrowheads smaller
edge((-1,0), "r", "-|>"),
node((0,0), "FF n-1"),
edge((1,0)),
node((1,-1),[*+*]),
edge((1,0), "u", "-|>", $p_(n-1)$ ),
edge((1,0), "r",  "--|>"),
node((2,0), "FF2"),
edge((2,0), "rr",  "-|>"),
node((3,-1),[*+*]),
edge((3, -1),"l"),
edge((2, -1), "l", "--|>"),
edge((3, 0), "u", "-|>", $p_2$),
node((4,0), "FF1"),
edge((4,0), "rr",  "-|>"),
node((6,0), "FF0"),
edge((6,0), "rrr",  "-|>", $ #h(5em) S_i$),
edge((7,0), "u,ll", "-|>", $p_0$),
node((5,-1),[*+*]),
edge((5, -1),"ll", "-|>"),
edge((5, 0), "u", "-|>", $p_1$),
edge((1, -1), "l,d", "-|>")
)
]         

The initial state is given ($S_(n-1),..., S_1, S_0$) and the following generic state is given by:
$ S_(n+i) =sum_(j=0)^(n-1)p_j S_(i+j)mod 2 $<lfsr>


*If Eve knows:*
- All the "$y_i$s"
- The degree $m$
- A certain number of bits: $x_0, ..., x_(2m-1)$

Then the system is cracked, since the linearity of this systems is easy to reverse (thus crack). This is not cryptographically secure.

#proof[ 
  Recalling @lfsr, by iterating the system for $2n-1$ number of times we can create a system of $2n$ equations from which Eve can retrieve all the $p_i$ coefficients.
  
]


=== Generator polynomial and example

#definition[A polynomial associated with an LFSR yielding a cycle of maximal period is said to be a *primitive polynomial*.]

#remark[The coefficient $p_0$ must be 1, otherwise it will produce an _antiperiod_: the information in the "FF0" present at the beginning will be lost.

In terms of representative polynomial it means that $ P(x)=x^m+sum_(j=1)^(m-1)p_j x^j +1 $
In order to be associated to a maximal length cycle (i.e. to be a so called *primitive polynomial*) the polynomial $P$ must contain at least three non-trivial terms (the one given by $p_0$, $x^(m)$ and another one).
]

#exercise("Attack to LFSR")[
  We want to perform an attack on a LFSR-based stream cipher. Each letter of the alphabet and numbers from 0 to 5 are represented by a 5-bit vector as follows: $ A <-> 0 = 00000_2 \ dots.v \ 5 <-> 31 = 11111_2 $

  We know the following facts about the system:
  - The degree of the LFSR is $m = 6$
  - Every message starts with the header WPI

  We observe on the channel the message:
  '_j5a0edj2b_'

  + What is the initialization vector?
  + What are the feedback coefficients of the LFSR?
  + Write a program that generates the whole sequence and find the whole plaintext.
  + Where does the thing after 'WPI' live?
  + What type of attack did we perform?
  \ 
  + We can start by seeing that 'WPI' (22 15 18) gets encoded by 'j5a' (9 31 0)
  #table(
    columns: 4,
    stroke: 0pt,
    align: center,
    [],
    [W], table.vline(end: 3, stroke: 1pt),
    [P],table.vline(end: 3, stroke: 1pt),
    [I],
    table.hline(stroke: 1pt),
    ['WPI'], [1 0 1 1 0], [0 1 1 1 1], [0 1 0 0 0],
    ['j5a'], [0 1 0 0 1], [1 1 1 1 1], [0 0 0 0 0],
    table.hline(stroke: 1pt),
    [Key-stream], [*1 1 1 1 1*], [*1* 0 0 0 0], [0 1 0  0 0],
  )
  Where the bits of the key stream are obtained by addition.

  What we are interested in are first 6 bits of the key-stream, that represent the initialization vector: ($s_0, ..., s_5$) = (111111)

  2. Since we know the initialization vector, and also the following bits of the key-stream we can write: $
    s_6 &= p_5 dot s_5 &&+ p_4 dot s_4 &&+ ... &&+ p_0 dot s_0 \
    &arrow.double.b \
    0 &= p_5 dot 1 &&+ p_4 dot 1 &&+ ... &&+ p_0 dot 1 \ \
    s_7 &= p_5 dot s_6 &&+ p_4 dot s_5 &&+ ... &&+ p_0 dot s_1 \
    &arrow.double.b \
    0 &= p_5 dot 0 &&+ p_4 dot 1 &&+ ... &&+ p_0 dot 1 \
  $
  By combining the 2#super[nd] and 4#super[th] expressions we get that $p_5 =0$. Following a similar process exploiting the rest of the known key-stream, we can retrieve all the other $p_i$.

  The resulting feedback path is (1 1 0 0 0 0 0) (little-endian) and the polynomial is $ x^6 + x +1 $

  #[
  #set align(center)  
  #let x = 0.5
  #diagram(
    spacing: (10mm, 5mm), // wide columns, narrow rows
    node-stroke: 1pt, // outline node shapes
    edge-stroke: 1pt, // make lines thicker
    mark-scale: 60%, // make arrowheads smaller
    edge((-x,0), "r", "-|>"),
    node((x,0), "5", shape: rect),
    edge((x,0), "r",  "-|>"),
    node((3*x,0), "4", shape: rect),
    edge((3*x,0), "r",  "-|>"),
    node((5*x,0), "3", shape: rect),
    edge((5*x,0), "r",  "-|>"),
    node((7*x,0), "2", shape: rect),
    edge((7*x,0), "r",  "-|>"),
    node((9*x,0), "1", shape: rect),
    edge((9*x,0), "r",  "-|>"),
    node((11*x,0), "0", shape: rect),
    edge((11*x,0), "r",  "-|>"),
    
    edge((12*x,0), "u,l", "-|>"),
    node((10*x,-1),[*+*]),
    edge((10*x, 0), "u", "-|>"),
    edge((10*x, -1), "lllll,d", "-|>")
  )
]        

  3. The key-stream is the following:

#block(
  height: 22em,
  breakable: false,
  columns(3,
    table(
      align: center,
      columns: (1fr, 0.4fr),
      table.header("", "idx"),
      [11111 *1*], [0],
      [01111 *1*], [1],
      [00111 *1*], [2],
      [00011 *1*], [3],
      [00001 *1*], [4],
      [00000 *1*], [5],
      [10000 *0*], [6],
      [01000 *0*], [7],
      [00100 *0*], [8],
      [00010 *0*], [9],
      [00001 *0*], [10],
      [10000 *1*], [11],
      [11000 *0*], [12],
      [01100 *0*], [13],
      [00110 *0*], [14],
      [00011 *0*], [15],
      [10001 *1*], [16],
      [01000 *1*],[17],
      [00101 *0*],[18],
      [10010 *1*],[19],
      [11001 *0*],[20],
      [11100 *1*],[21],
      [11110 *0*],[22],
      [01111 *0*],[23],
      [10111 *1*],[24],
      [01011 *1*],[25],
      [00101 *1*],[26],
      [00010 *1*],[27],
      [10001 *0*],[28],
      [11000 *1*],[29],
      [11100 *0*],[30],
      [...], [...]
    )
  )
)

  In order to decypher we need the keys starting from 15 (since the previous ones are used for WPI), so we get:

    #table(
    columns: 7,
    stroke: 0pt,
    align: center,
    [Key-stream],
    table.vline(stroke: 1pt),
    [01100],[01010],[01111],[01000],[11100],[10010],
    ['0edj2b'], [10110],[01110],[01100],[00001],[00000],[10011],
    table.hline(stroke: 1pt),
    table.hline(stroke: 1pt),
    [Plain text], [W],[O], [M], [B],[A],[T],
  )

  4. It lives in the woods
  + It is a known plain-text attack
]

=== Polynomials associated to LFSR

#definition("Primitive polynomial")[
  A polynomial associated to with an LFSR yielding a cycle of maximal period is said to be *primitive*.
]<primitive_polynomial>

#definition("Irreducible polynomial")[
  A polynomial associated to with an LFSR yielding a cycle of maximal period, but whose length is independent on the initializing state, is said to be *irreducible and not primitive*.
]<irreducible_polynomial>

#definition("Reducible polynomial")[
  A polynomial associated to with an LFSR yielding a cycle of maximal period and whose length is dependent on the initializing state, is said to be *reducible*. 
]<reducible_polynomial>
These features of polynomials are related to the topics of Galois fields (see @galois_fields)