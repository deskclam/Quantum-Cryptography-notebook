#import "imports.typ":*

= BB84

== Steps

#[
 #set enum(numbering: "1.i.") 
+ Alice generates 2 random sequences: $ A = (a_1, ..., a_n) quad a_j in {0,1} \ S = (s_0, ..., s_n) quad s in {plus, times} $
+ Alice sends photons to Bob in this way:
  - If $s_j = + $ Alice filters the $j$#super[th] photon with the polarizer oriented along $+$
  - If $a_j =0$ and the $j$#super[th] photon exits through the ordinary ray, Alice keeps the photon
  - If $a_j =0$ and the $j$#super[th] photon exits through the extraordinary ray, Alice destroys the photon and tries again
  - Analogously for $a_j = 1$ and/or $s_j = times$
+ Before receiving the photons, Bob generates a random sequence $R =(r^1, ..., r^n)$ with $r^j in {+, times}$. He then filters the incoming photons using a polarizer oriented according to $r^j$ and records the digit 0 if the photon exits through the ordinary ray and 1 otherwise. In this way he obtains the sequence $ B = (b_1, ..., b_n) quad b_j in {0,1} $
+ Alice and Bob publish the sequences $S$ and $R$ and throw away the bits of $A$ and $B$ corresponding to different choices of the basis, obtaining $A'$ and $B'$. On average, the length of $A'$ and $B'$ is $n slash 2$. In an ideal world, at this point, Alice and Bob share a secret key without never having to meet.
+ There are 2 sources of non-ideality:
  + Photons can be lost or perturbed during transmission
  + Someone (Eve) can intercept the communication
+ The previous non-idealities imply that some of the bits in $B'$ present a small fraction of errors. Depending on the amount of errors, Alice and Bob can detect the presence of Eve.

]

== One possible attack

Eve could intercept the photons before they arrive to Bob, measure them and them send to Bob a new photon. The problem for Eve is that she doesn't know what basis Alice used, so she must chose at random. If Eve performs this attack, the probability that $A' != B'$ is $n_e slash 4$, where $n_e$ is the number of photons that were eavesdropped.

To detect this kind of attacks, Alice and Bob can sacrifice a small portion of the their qubits, count the discrepancies, measure the number of errors and the proceed. For the following, it is important to estimate the amount of information that Eve can obtain.

#definition("Rényi entropy")[
  We want a function that embodies our ignorance: if we have a binary process with 2 possible outcomes, characterized by the probabilities $p_0$ and $p_1 = 1 - p_0$, when $p_0 = 1 slash 2$, the ignorance is maximal. $ H_R = - log_2 (p_0 ^2 + p_1^2) $
  In a more general form: $  H_R = - log_2 (sum_(arrow(a)) p^2(arrow(a))) $
]<renyi_entropy>

#definition("Rényi information")[
  Let $arrow(a)$ be a string of length $n$, then the Rényi information is defined as:
  $ I_R = n - H_R $
]<renyi_info>

#definition("Shannon entropy")[ $ H_S (x)equiv - sum_x p_x log_2 p_x $]

== Example: Loepp-Wooters

Suppose that Eve intercepts a photon using the basis ${ket(m_1), ket(m_2)} = {vec(1 slash 2, sqrt(3) slash 2), vec(sqrt(3) slash 2, - 1 slash 2)}$ and obtains the state $ket(m_1)$.

When Alice publishes $S$, Eve discovers that Alice used the basis $M_+$ to filter the photons. How much information did Eve gain on the original state of the photon?

We must compute the probability that the state of the photon released by Alice had horizontal polarization, knowing that, when filtered by Eve, its polarization was turned to $ket(m_1)$.

Notice that this is not the quantum transition probability (QPT). In fact, QPT is
$ cal(P)(ket(m_1) | ket(<->)) = "probability of having" ket(m_1) $ after the measurement, given that, before the measurement, it was $ket(<->)$. We find out that $cal(P)(ket(m_1) | ket(<->)) equiv |braket(m_1, <->)|^2$.

What we want now is the opposite, namely $cal(P)(ket(<->)|ket(m_1))$. We can compute it using Bayes, formula: $ cal(P)(ket(<->)|ket(m_1)) = underbrace(cal(P)(ket(m_1|<->)), 1 slash 4) overbrace(cal(P)(<->), 1 slash 4)/(cal(P)(m_1)) $

The remaining probability $cal(P)(m_1)$ is the probability that Eve obtains $ket(m_1)$ after measurement,computed as if we were Eve, who doesn't know the state of the photon. According to her, the photon is in a mixed state of $<->$ and $arrow.b.t$: $ rho_"eve" = 1/2ketbra(<->) + 1/2 ketbra(arrow.b.t) $

The probability of finding $ket(m_1)$ is thus:

$ 
Tr(rho_"eve" dot cal(P)_m_1) = (1/2 ketbra(arrow.r.l) + 1/2 ketbra(arrow.t.b)) (ketbra(m_1)) = ... = 1/2
$

So, $p_0 = cal(P)(arrow.r.l | m_1)= 1/4$ and $p_1 = cal(P)(arrow.t.b | m_1) =3/4$. This gives a Rényi entropy: $ H_R = - log(1/16 + 9/16) = 0.678 $

Since, without Eve's intervention, we had $H_R = 1$, we can calculate the gain in information, which is equal to the loss in entropy as: $H_(R "initial") - H_(R "final") = 0.322 "bits"$.

#theorem("No cloning")[
+ $exists.not$ a unitary operator on $H times.circle H st$ $ U(ket(psi) ket(0)) = ket(psi)ket(psi) e^(i phi(psi)) $
+ There exists a unitary operator $U$ on $H times.circle H$ such that, given a specific set ${ket(psi_j), j in NN}$, $ U(ket(psi_j) ket(0)) = ket(psi_j)ket(psi_j) $ if and only if ${ket(psi_j), j in NN}$ form an orthonormal set.
]

The no cloning theorem prevents Eve from being able to duplicate information sent by Alice.

== Teleportation strategy

 Alice and Bob share an entangled pair:
 + $ket(Phi^+)=1/sqrt(2)(ket(00)+ket(11))$
 + Alice owns a further two level-system in the (possibly unknown) state $ket(s)= alpha ket(0)+beta ket(1)$. Alice aims at conveying $ket(s)$ to Bob. The three particle state is $ 
 ket(s) times.circle 1/sqrt(2)(ket(00)+ket(11)) = 
 
 1/2[&ket(Phi^+) times.circle (alpha ket(0)+beta ket(1))+ \ 
 + &ket(Phi^-)times.circle (alpha ket(0)-beta ket(1))+\
 + &ket(Psi^+)times.circle (beta ket(0)+alpha ket(1))+\
 + &underbracket(ket(Psi^-), A)times.circle underbracket( (-beta ket(0)+alpha ket(1)), B)]\
 $

  The set ${ket(Phi^+), ket(Phi^-), ket(Psi^+), ket(Psi^-)}$ is called a _Bell's basis_ of the two particle space. Notice that such states are attributed to Alice's pair.
+ Alice measures a non-degenerate observable that has Bell's basis as a set of eigenvectors
+ Alice tells Bob her result. N.B.: this communication is not made through the entangled pair, it is "classical" and not superluminal
+ Depending on Alice's result, Bob applies the following gates on his qubit: $
ket(Phi^+) &arrow II
\ ket(Phi^-) &arrow sigma_z
\ ket(Psi^+) &arrow sigma_x
\ ket(Psi^-) &arrow sigma_z sigma_x
$

#remark[At the end the state of the qubit initially in $ket(s)$ is an entangled state with the other qubit of Alice. So, individually it is a mixed state. Sending it to Bob provokes perturbation exactly like measuring it. \
The teleportation strategy gives no advantage to Eve. In fact the cloning strategy was:\

#[
#set align(center)  
#diagram(
spacing: (10mm, 5mm), // wide columns, narrow rows
node-stroke: 1pt, // outline node shapes
edge-stroke: 1pt, // make lines thicker
mark-scale: 60%, // make arrowheads smaller
node((1,0), "Alice"),
edge((1,0), "rrr",  "-|>", $ket(s)$),
node((4,0), "Eve", shape: pill),
node((4, -2), "Bart"),
edge((4, -0), "uu", "-|>", $ket(s)$),
edge((4,0), (7,0),  "-|>", $ket(s)$),
node((7,0), "Bob")
)
]    
]
But this cannot work because after teleportation, Eve has not $ket(s)$ to send to Bob. The idea was "cloning at a distance + ancilla" (the ancilla is the second qubit of Alice). Even for this setting a no-cloning result can be proved.


== Obtaining a secret shared key

As stated before, after Alice and Bob have obtained the sequences $A$ and $B$, they are still far from having a secret shared keys due to the following problems that cause $A eq.not B$:

+ Alice and Bob chose different basis and thus have a probability $P = 1 slash 4$ of ending up with the same bit in a given position
+ The channel is not perfect and can thus introduce errors
+ Eve can perturb the channel and introduce additional errors


The first issue is straightforward to solve since all is required to do is compare publically the sequence of the basis and discard the bits corresponding to different base choices. This results in a reduction of the total number of bits:

$
A --> A' = (a'_1, ..., a'_n') \
B --> B' = (b'_1, ..., b'_n') \
n approx n/2
$

It is important to notice that, at this point, $A',B'$ are *neither identical nor private* due to issues 2. and 3.

Starting from $A'$ and $B'$ we need to use *error correction* and *privacy amplification* to constructs two identical and secure sequences. Steps 5 and 6 of BB84 need to be modified to account for these changes:

#[
  #set enum(numbering: "a)")
  + Check some of the bits of $A'$ and $B'$ to estimate the probability of error and then discard these bits
  + Correct the errors in the remaining bits, obtaining two sequences that are (hopefully) identical but not private
  + Perform *privacy amplification* to extract a secure substring starting from an insecure one
]

=== Estimating the probability of error

If we suppose that $B'$ is composed of 10000 bits, then Bob can select 100 of them and compare them publically with the corresponding bits of $A'$. Supposing that there are 2 errors in the 100-bits sequences, Alice and Bob can estimate $ P("error") = 2%$ (without accounting for Eve's contribution). Obviously, all 100 bits used for the comparison have to be discarded after this step, giving $A''$ and $B''$ of length $n'' = 9900$ bits.

=== Error correction (using Hamming)

Continuing with the example above (e.g. $P("error") = 2%$), if we consider strings which are 50 bits long, we will have, on average, 1 error per string. Since we want to work with strings which have a probability of error $<< 1$, we can consider strings of length 7 and split $A''$ and $B''$ in 7 bits long strings:

#let cells = 7 
#let blocks = 4
#let thick = 4pt
#let str = 1.2pt + black
#table(
  align: center,
  columns: cells*blocks,
  table.hline(stroke: str),
  table.vline(stroke: str, end: 1),
  ..for i in range(cells){
    ([],)
  },
  table.vline(stroke: str, end:1),
  ..for i in range(cells){
    ([],)
  },
  table.vline(stroke: str, end: 1),
  table.cell(colspan: cells)[#h(5em)$...$#h(5em)],
  table.vline(stroke: str, end: 1),
  ..for i in range(cells){
    ([],)
  },
  table.hline(stroke: str),
  table.vline(stroke: str, end: 1),
  
  table.cell(colspan: cells, stroke: (bottom: 0pt, right: 0pt, left: 0pt))[$arrow(a)_1$],
  table.cell(colspan: cells, stroke: (bottom: 0pt, right: 0pt, left: 0pt))[$arrow(a)_2$],
  table.cell(colspan: cells, stroke: (bottom: 0pt, right: 0pt, left: 0pt))[#h(5em)$...$#h(5em)],
  table.cell(colspan: cells, stroke: (bottom: 0pt, right: 0pt, left: 0pt))[$arrow(a)_n''$],
)  
#table(
  align: center,
  columns: cells*blocks,
  table.hline(stroke: str),
  table.vline(stroke: str, end: 1),
  ..for i in range(cells){
    ([],)
  },
  table.vline(stroke: str, end:1),
  ..for i in range(cells){
    ([],)
  },
  table.vline(stroke: str, end: 1),
  table.cell(colspan: cells)[#h(5em)$...$#h(5em)],
  table.vline(stroke: str, end: 1),
  ..for i in range(cells){
    ([],)
  },
  
  table.hline(stroke: str),
  table.vline(stroke: str, end: 1),
  
  table.cell(colspan: cells, stroke: (bottom: 0pt, right: 0pt, left: 0pt))[$arrow(b)_1$],
  table.cell(colspan: cells, stroke: (bottom: 0pt, right: 0pt, left: 0pt))[$arrow(b)_2$],
  table.cell(colspan: cells, stroke: (bottom: 0pt, right: 0pt, left: 0pt))[#h(5em)$...$#h(5em)],
  table.cell(colspan: cells, stroke: (bottom: 0pt, right: 0pt, left: 0pt))[$arrow(b)_n''$],
)  

We can now take the check matrix for the $[7,4]$ binary Hamming code and compute the syndromes: $ H = mat(1,1,1,0,1,0,0;1,1,0,1,0,1,0;0,1,1,1,0,0,1) $

Alice can compute $arrow(s)^A = H arrow(a)^TT$ and send it to Bob. Bob, on the other hand, can compute $arrow(s)^B = H arrow(b)^TT$ and compare it with $arrow(s)^A$. I we define $arrow(e) = arrow(b) - arrow(a)$ we get $ H arrow(e)^TT = H arrow(b)^TT - H arrow(a)^TT = underparen(arrow(s)^B - arrow(s)^A, "known by Bob") $ 

At this point, Bob can get $arrow(s)^E = H arrow(e)^TT$; by computing the syndrome chart for the $[7,4]$ Hamming code, we can see that every coset has exactly one coset leader and this means that the error can be uniquely determined (provided that we are sure that we have at most one error in $arrow(b)$).

It is important to notice that, during this procedure, Eve can gain the knowledge of both $H$ and $arrow(s)^A$, which is to say: $
  a_1 + a_2 + a_3 + a_5 = arrow(s)_1^A\ 
  a_1 + a_2 + a_4 + a_6 = arrow(s)_2^A\ 
  a_2 + a_3 + a_4 + a_7 = arrow(s)_3^A\ 
$

#example[
  $
    arrow(a) = mat(1,0,0,0,1,1,1) \
    arrow(b) = mat(1,1,0,0,1,1,1)
  $

  + Alice computes $arrow(s)^A = mat(0,0,1)^TT$ and sends it to Bob
  + Bob computes $arrow(s)^B = mat(1,1,0)^TT$
  + Bob computes $ arrow(s)^E = arrow(s)^B - arrow(s)^A = vec(1,1,1) = H arrow(e)^TT $ which means that $arrow(e)$ is the coset leader of $mat(1,1,1)^TT$ which is $mat(0,1,0,0,0,0,0)$
  + Bob can, finally, flip the second bit and correct the error.
]

The advantage of this strategy is that Alice sends only one information to Bob for each sub-block and Bob doesn't send anything back.

The drawback is that computing the syndrome involves matrix product, which can be costly for large matrices.

=== Error correction (using parity check)

Another strategy that Alice and Bob can adopt is the following: 

+ Alice and Bob must agree on a permutation of bits which has to be applied to the whole string to randomize the distribution of errors (this is useful in cases where errors are concentrated in a small section of the string).
+ Similarly to before, Alice and Bob divide the string in blocks of a suited size so that the probability of error in each block is $<< 1$.
+ They compute the parity of each block and publically compare the outcomes. I the parity is the same, Bob leaves the block untouched, otherwise the affected block gets divided into equal parts and the procedure starts again, similarly to binary search. This process will get to an end when they find the affected bit.
+ When the error is found, Bob flips the corresponding bit.
+ The process continues until all the string has been error-corrected, with the difference that, the more we proceed, the fewer the errors and thus larger blocks can be used.

Using this strategy, Eve gets to know the parity of all sub-blocks which, like in the previous case, are a linear combination of Alice's bits.

=== Privacy amplification

At this point in the protocol, the strings shared by Alice and Bob are identical but we want them also to be private, which is to say that, to Eve, all strings should be equiprobable.

#example[
  Alice and Bob know that Eve knows exactly one bit of $arrow(a) = (a_1, a_2, a_3)$ but they don't know which one it is. 

  We can define $ arrow(alpha) eq.delta (a_1 + a_2, a_2 + a_3) $

  It is easy to see (looking at the "truth table"), that Eve doesn't know anything about $arrow(alpha)$, which is to say that all $alpha$s are equiprobable to her.

  $alpha$ is called a *privacy amplification scheme* because Eve went from knowing something about the information shared between Alice and Bob to knowing nothing.

  Such a scheme can be represented by the matrix $
  G = mat(1,1,0;0,1,1) \
  arrow(alpha)^TT = G arrow(a)^TT
  $
]

#example[
  Similarly to before, we know that Eve knows *two* bits of $arrow(a) = (a_1, a_2, a_3, a_4)$ but we don't know which ones. We decide to try with the scheme $ G = mat(1,1,1,0;0,1,1,1) $
  which gives the following: $ arrow(alpha) = (a_1 + a_2 + a_3, a_2 + a_3 +a_4) $

  If we suppose that the bits known by Eve are $a_1$ and $a_4$ it is easy to see that Eve can compute $a_1 + a_2 = a_1 + cancel(a_2) + cancel(a_3) + cancel(a_2) + a_4 + cancel(a_3)$.

  Differently from before, Eve now *knows* a linear combination of $a_1$ and $a_2$, this means that, in this case, for Eve, not all $alpha$s are equiprobable and thus *this amplification scheme fails*.

  If we look at the minimal weight of the code generated by G, we see that it is 2, given by $mat(0,1,1,0)$ and 2 is also equal to the information (in the sense of the number of bits) known by Eve.
]

#theorem[
  Suppose $arrow(a) in ZZ_2^n$ and that Eve knows exactly $t$ bits of $arrow(a)$. Let $G$ generate a linear $[n,k]$ code with minimum weight $w$.

  Let $arrow(alpha)^TT = G arrow(a)^TT$ a privacy amplification scheme, then:
  + If $w > t$, then Eve knows *nothing* about $arrow(alpha)$
  + If $w<=t$, then Eve could know *something* about $arrow(alpha)$ (in the sense that there exists a sequence of $t$ bits that would allow Eve to know something about $arrow(alpha)$)
]<privacy_ampl_theo>

Let's now consider the more realistic case in which Eve knows some linear combination of the bits $a_i$ as Eve typically knows the syndrome of Alice $arrow(s)^A$.
#pagebreak()
#example[ Linear binary $[7,4]$ code:

  $ arrow(s)^A = H arrow(a)^TT &= mat(1,1,1,0,1,0,0;1,1,0,1,0,1,0;0,1,1,1,0,0,1) dot arrow(a)^TT \
  &= mat(a_1 + a_2 + a_3 + a_5;
          a_1 + a_2 + a_4 + a_6;
        a_2 + a_3 + a_5 + a_7;) \
  &= vec(s_1^A, s_2^A, s_3^A)
  $

  Eve knows three linear combinations:

  We do some trials to see what happens and how many bits we need to sacrifice. 

  + Drop $a_4, a_6, a_7$ and remain with $alpha = (a_1, a_2, a_3, a_5)$. This is not good because $s_1^A$ is left untouched and known by Eve $==>$ *all the lines of $arrow(s)^A$* must be involved. $ mat(#pin("unt1")a_1 + a_2 + a_3 + a_5#pin("unt") ;
          a_1 + a_2 + cancel(a_4) + cancel(a_6);
        a_2 + a_3 + a_5 + cancel(a_7);) $
        
  + Drop $a_1, a_2, a_7$, now we affect all the rows but the first two are affected in the same way and thus Eve can gain information by summing $s_1^A + s_2^A$ $==>$ *we must "touch" all equations and all linear combinations of them*.$ mat(#pin("same")cancel(a_1) + cancel(a_2) + a_3 + a_5 ;
          cancel(a_1) + cancel(a_2)#pin("same2") + a_4 + a_6;
        cancel(a_2) + a_3 + a_5 + cancel(a_7);) $
        
  + Drop $a_5, a_6, a_7$. Now it works. $ mat(a_1 + a_2 + a_3 + cancel(a_5);
          a_1 + a_2 + a_4 + cancel(a_6);
        a_2 + a_3 + cancel(a_5) + cancel(a_7);) $
        
]

#pin_right("unt", "Untouched")
#pin_left("same", "Affected in the same way")
#pinit-highlight("unt1", "unt", fill: red.transparentize(70%))
#pinit-highlight("same", "same2", fill: red.transparentize(70%))
// #pinit-point-from(15, [Affected in \ the same way],offset-dy:5pt, body-dy:-5pt, pin-dy: 5pt, offset-dx:-50pt, body-dx:-60pt, pin-dx:-10pt )

#theorem[
  #let pat = pattern(size: (5pt, 5pt))[
    #place(line(start: (0%, 0%), end: (100%, 100%)))
    #place(line(start: (0%, 100%), end: (100%, 0%)))
  ]
  Suppose that Eve has $I_R < t$ and $t < n$, where $I_R approx$ "number of bits known" and $n$ is the number of bits of $arrow(a)$.

  Let $s < n-t$ and $k = n - t - s$.

  Let $arrow(alpha)^TT = G arrow(a)^TT$ where $G$ is a randomly chosen $k times n$ matrix. Then Eve's average Rényi information (@renyi_info) about $alpha$ is $ I_R^(E) <= (2^(-s))/log(2) $

  Which tells us that the more bits we sacrifice, the less Eve knows.
  $
  #stack(
  $arrow(a) =$, "", spacing: 2pt)
  & overbrace(
    #stack(
      
      dir: ltr,
    stack(rect(width: 40%, height: 10pt, inset:0pt, outset: 0pt), ""),
    stack(spacing: 2pt, rect(width: 10%, height: 10pt, fill:pat, inset:0pt, outset: 0pt, stroke: 1pt), "t"),
    ),
    n
  ) \
    #stack([Final string $=$], "")
    
    &#stack(
    dir: ltr,
    stack(rect(width: 30%, height: 10pt), ""),
    stack(spacing: 2pt, line(length: 10%, start: (0pt, 5pt), stroke: (dash: "dotted")),"s") ,
    line(end:(0pt, -30pt), start: (0pt, 10pt), stroke: (paint: black, thickness: 1pt, dash: "dashed"))
  )
  $

  Moreover, Shannon's entropy $>= H_R$
]

We will now look at some examples that show us the relationship between the information available to Eve and the Shannon's and Rényi's entropies.

#example("No information")[
  If Eve has access to no information at all, then every $arrow(a)$ is equiprobable. Thus
  $ H_R &= log_2 sum_arrow(a) (1/2^n)^2  \
  &= -log_2 sum_arrow(a)1/2^(2n) \
  &= -log_2 2^n/2^(2n) \
  &= n ==> I_R = n - n = 0
  $
]

#example("One string is known")[
  In this case there is one $arrow(a)^*$ with probability 1 and all the other have probability 0:
  $
    H_R = 0 ==> I_R = n\
    H_S = 0 ==> I_S= n
  $
]

#example("Intermediate case")[
  We have one $arrow(a)^*$ with probability $1 slash 2$ and all the other strings have probability $ p(arrow(a)) = (1 slash 2)/(2^n - 1) = 1/(2^(n+1) - 2) $

  In this case we get the following:
  $ H_R &= - log_2 (p^2(arrow(a)^*) + sum_(arrow(a) != arrow(a)^*)p^2(arrow(a))) \
  &= -log_2 (1/4 + 1/(2^(n+1)-2)^2 (2^n - 1)) \
  &= -log_2(1/4 + 1/4 dot 1/(2^n - 1) ) \
  &= -log_2[1/4 (1+ 1/(2^n-1))] \
  &= -log_2 2^(n-2) - log_2 1/(2^n - 1) \
  &= 2-n + log_2(2^n - 1)
  $

  We can compute $H_R$ for different values of $n$ to see what we get:

  - For $n =3$: $H_R = 1.8 ==> I_R = 1.2$
  - For $n = 9$: $H_R = 1.997 ==> I_R = ???$
  - For $n -> infinity$: $  H_R &= 2 + overbrace(log_2 1/2^n, n) + log_2(2^n - 1) \
  &= 2 + underbrace(log_2 (2^n - 1)/2^n, -> 0 " as " n -> infinity) -> 2 \ I_R &-> infinity $
  
]