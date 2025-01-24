#import "imports.typ":*

= Error correcting codes

In communication, errors always occur and we want to be able to *detect* and *correct* them.

#definition("Alphabet")[Let $A$ a finite set of symbols called an *alphabet*]

#definition([$n$-word])[
  
  $ A^n = underbrace(A times A times ... times A, n "times") = {(a^1, ..., a^n), a_j in A} $ is the set of words of $n$ characters
]

#definition("Code")[ Fixed $A$ and $n$, a set $C subset.eq A^n$ is called *code*
]

== Hamming distance 

#let dh = $d_H$
#let xy = $(arrow(x), arrow(y))$

#definition("Hamming distance")[
  The map $  dh:  A^n times A^n &|-> RR^+ \  (arrow(x), arrow(y)) &|-> d_H (arrow(x), arrow(y)) = \#{i st x^i != y^i} $ is said *Hamming distance* between two $n$-words.
]

=== Properties

+ $dh xy = 0 iff arrow(x) = arrow(y)$
+ $dh xy = dh (arrow(y), arrow(x)) space forall arrow(x),arrow(y)$
+ $dh xy <= dh (arrow(x), arrow(z)) +dh (arrow(y), arrow(z)) space forall arrow(x), arrow(y), arrow(z)$ (triangular inequality)

The Hamming distance could give us an idea for implementing error correction:


when we receive $ arrow(r) in.not C$, we find $arrow(x) st dh (arrow(r), arrow(x)) = min_(arrow(y) in C) (arrow(r), arrow(y))$. The biggest problem with this idea is that the min may not be unique.

Another possible idea is based on supposing that the number of possible error is 1. If the code $C$ is constructed so that the minimum distance between two elements is 3, then $arrow(x)$ (the original word) is the only minimizer in $C$ of the distance from $arrow(x)$.

#definition("Minimal distance")[
  Given $A, n, C$, the *minimal distance* of the code is $ d(C) = min_(arrow(x), arrow(y) in C \ arrow(x) != arrow(y))  dh xy $
]

#theorem("Detection of the error")[ Let $C subset.eq A^n$ with minimum distance $d$, then $C$ detects $d-1$ errors.]

#theorem("Correction of the error")[ Let $C subset.eq A^n$ with minimum distance $d$, then $C$ corrects $ e = floor((d-1)/2) $ errors.]

#exercise[
We have a channel that applies the X gate with a probability $q=1-p$.

Alice sends 2 pairs with the following probabilities:

#table(
  columns: 2,
  gutter: 3pt,
  stroke: none,
  align: center,
  table.header("State", "Probability"),
  table.hline(),
  $ket(phi^+) ket(phi^+) = ket(alpha)$, table.vline(),  $p^2$,
  $ket(Theta^+) ket(phi^+) = ket(beta)$, $p q$,
  $ket(phi^+) ket(Theta) = ket(gamma)$, $p q$,
  $ket(Theta) ket(Theta) = ket(delta)$, $q^2$,
)

where $ket(Theta)$ is the state of the pair after corruption.
// #let arr_top(pin, body) = {
//   let off_y = -15pt
//   let off_x = 6pt
//   pinit-point-from(
//     pin,
//     offset-dy: off_y - 10pt,
//     offset-dx: off_x,
//     body-dy:off_y*0.6,
//     body-dx:-5pt ,
//     pin-dy: off_y,
//     pin-dx: off_x,
//     )[#body] 
// }


#let arr_top(pin, body) = {
  let off_y = -1em
  let off_x = .3em
  set text(size: 8pt)
  pinit-point-from(
    pin,
    offset-dy: off_y - 10pt,
    offset-dx: off_x,
    body-dy:off_y*0.8,
    body-dx:-.3em ,
    pin-dy: off_y,
    pin-dx: off_x,
    )[#body] 
}

// #arr_top(0, "A")
// #arr_top(1, "B")
+ Rewrite the state in the form $ket(A_1 A_2 B_1 B_2)$:$ 
\ \ \
// 2 ket(alpha) = (ket(#pin(0)0#pin(1)0)) + ket(1^(A_1)1^(B_1)))(ket(0^(A_2)0^(B_2)) + ket(1^(A_2)1^(B_2))) = ket(0000)+ ket(0101) + ket(1010) + ket(1111) \
2 ket(alpha) &= (#pin(0)ket(0^(A_1)0^(B_1)) + ket(1^(A_1)1^(B_1)))(ket(0^(A_2)0^(B_2)) + ket(1^(A_2)1^(B_2))) \ &= ket(0000)+ ket(0101) + ket(1010) + ket(1111) \ \
// 2 ket(alpha) = (ket(overbracket(0, A_1) overbracket(0, B_1)) + ket(overbracket(1, A_1) overbracket(1, B_1)))(ket(overbracket(0, A_2) overbracket(0, B_2)) + ket(overbracket(1, A_2) overbracket(1, B_2))) = ket(0000)+ ket(0101) + ket(1010) + ket(1111) \

2 ket(beta) &= (ket(00) + ket(11))(ket(01) + ket(10)) \ &= ket(0001)+ ket(0101) + ket(1011) + ket(1110) \ \

2 ket(gamma) &=(ket(01) + ket(10)) (ket(00) + ket(11)) \ &= ket(0010)+ ket(0111) + ket(1000) + ket(1101) \ \

2 ket(delta) &=(ket(01) + ket(10)) (ket(01) + ket(10)) \ &= ket(0011)+ ket(0110) + ket(1001) + ket(1100)
$


+ Both Alice and Bob perform the unitary transformation $U$, where the ordering of the basis vectors is $ket(00), ket(01), ket(10), ket(11)$. What happens to the states? $ 
U = mat(1,0,0,0;0,1,0,0;0,0,0,1;0,0,1,0) \
ket(alpha) "remains as is (3 and 4 swap)" \
ket(beta) "remains as is (3 and 4 swap)" \
U ket(gamma) = ket(delta) \
U ket(delta) = ket(gamma) \

"Notice that the probabilities for" ket(gamma) "and" ket(delta) "are now swapped"
$
+ Alice and Bob now measure their second qubit in the computational basis. If their result is the same, they keep the first qubits, otherwise they discard them. What is the probability that the first qubit pair is in the state $ket(phi^+)$ *given that* they found the same result in the measurement?

Case $ket(alpha)$: $ 
2 ket(alpha) &=  ket(0)_(A_1)ket(0)_(A_2)ket(0)_(B_1)ket(0)_(B_2) + ket(0)_(A_1)ket(1)_(A_2)ket(0)_(B_1)ket(1)_(B_2) + \ & +ket(1)_(A_1)ket(0)_(A_2)ket(1)_(B_1)ket(0)_(B_2) + ket(1)_(A_1)ket(1)_(A_2)ket(1)_(B_1)ket(1)_(B_2)
$
Suppose $A$ measures $A_2$ and finds $0$:
$ 2ket(alpha)= &(ket(0)_(A_1)ket(0)_(B_1)ket(0)_(B_2) + ket(1)_(A_1)ket(0)_(B_1)ket(0)_(B_2)) ket(0)_(A_2) + \ &(ket(0)_(A_1)ket(0)_(B_1)ket(1)_(B_2) + ket(1)_(A_1)ket(1)_(B_1)ket(1)_(B_2)) ket(1)_(A_2) \ "which collpses in" arrow &(ket(0)_(A_1)ket(0)_(B_1)ket(0)_(B_2) + ket(1)_(A_1)ket(1)_(B_1)ket(0)_(B_2)) ket(0)_(A_2) $

Now, as Bob measures he finds 0: $ arrow (ket(0)_(A_1)ket(0)_(B_1) +ket(1)_(A_1)ket(1)_(B_1))ket(0)_(B_2) ket(0)_(A_2) prop Phi^+_((A_1,B_1)) ket(0)_(B_2) ket(0)_(A_2) $
Analogously if Alice finds $1$, after collapse the state is:
$ prop Phi^+_((A_1,B_1)) ket(1)_(B_2) ket(1)_(A_2) $
]

#exercise[
  #set math.vec(delim: "{")
  We have a [7,4] binary (i.e. $A={0,1}$) Hamming code 
  $ C = vec((x_1, ..., x_7) st x_1 + x_2 + x_3 + x_5 = 0 \ dots.v) $<eq_sum_zero>

  + If $arrow(x) in C$, given $lambda in {0,1}$, say if $lambda arrow(x) in C$. Yes, $lambda arrow(x) in C$ because $0 in C$ and $arrow(x) in C$
  + If $arrow(x), arrow(y) in C$, does $arrow(x) + arrow(y) in C$? $ (x+y)_1 + (x+y)_2 + (x+y)_3 +(x+y)_5  \ =x_1 + y_1 +x_2 + y_2+ x_3 + y_3 + x_5 + y_5  \ = underbrace(x_1 +x_2 + x_3 + x_5, tilde(x)) + underbrace(y_1 +y_2 + y_3 + y_5, tilde(y)) $<dubbio> both $tilde(x) $ and $tilde(y) in C$, this means that the sum of the coefficients $1,2,3,5$ is equal to 0 by @eq_sum_zero. Since they are both equal to $0$  their sum is in $ C$  which means that $C$ is close with respect to the sum.

  Since both points (1. and 2.) are satisfied, we can say that $C$ is a vector subspace called a *linear code*. All the operations we made are possible becaues $ZZ_2$ has a natural sum and a natural product. In other words, $ZZ_2$ is a field
]

#definition("Linear code")[
  Given a finite field $A = F$ so that $F^n$ has a natural structure of vector space. $C in F^n$ is said to be a *linear code* if it is a linear subspace of $F^n$. This is equivalent to saying that $C$ is linear if:
  + $C$ is not empty
  + $forall arrow(x), arrow(y) in C ==> (arrow(x) + arrow(y) )in C$
  + $forall alpha in F, forall arrow(x) in C ==> alpha arrow(x) in C$
]

#definition([$[n, k]$ linear code])[
  Let $F$ a finite field. A linear code $C in F^n$ of dimension $k$ is called a *$[n, k]$ linear code*.
]

#definition("Generator matrix")[
  Given a $[n, k]$ linear code $C$, a *generator matrix* of $C$ is a matrix with $k$ rows and $n$ columns such that the rows form a basis for $C$. 

  Note that $G$ generates $C$ in the sense that $ arrow(x) in C <==> exists arrow(alpha) in F^k st arrow(alpha) G = arrow(x) $

  A generator matrix for
  $C$ where the $k × k$ identity matrix appears at the left is called a *standard generator* matrix.
]
#pagebreak()
Notice that, in a $[n,k]$ code defined in $ZZ_r^n$, the length of each codeword is $n$, the number of codewords is $r^k$ and the dimension of the code is $k$.

#example[
  #let spc = h(0.3em)
  #set math.vec(delim: "{")
  $ C = vec((x_1, ..., x_7) st quad &#pin(2)x_1 + x_2 + x_3 + x_5 = 0 \ 
      & x_1 + x_2 + x_4 + x_6 = 0 \
      & x_2 + x_3 + x_4 + x_7 = 0#pin(3)
    ) 
\

    G = overbracket(mat(#pin(4)1,0,0,0, #pin(0)1,1,0;
            0,1,0,0, 1,1,1;
            0,0,1,0,1,0,1;
            0,0,0,1#pin(5),0,1,1#pin(1)), x_1  spc x_2 spc  x_3 spc  x_4 spc  x_5 spc  x_6 spc x_7)
            
  $ <id_matr>
#let str_1 = (paint: black, thickness: 1pt, dash: "dotted")
#pinit-highlight(0, 1, stroke: str_1)
#pinit-highlight(2, 3, stroke: str_1)
#pinit-highlight(4, 5, fill:rgb(0,255,0,50), stroke: (paint: black, thickness: 0.5pt, dash: "dashed"))
#pinit-point-from(1)[Obtained from the \ constraints above]
#pinit-point-from(5, offset-dx:-35pt, pin-dx:-35pt, body-dx:-30pt)[Identity matrix]
\ \ \ \
  $G$ is a generator matrix for the $[7,4]$ Linear Hamming Code, where the identity matrix is the basis for the first four digits ($x_1, x_2, x_3, x_4$) while the other columns can be written as $x_5=x_1 + x_2+x_3(mod 2), x_6=x_1+x_2+x_4(mod 2), x_7=x_2+x_3+x_4(mod 2)$.

]
The lines of $G$ are linearly independent.

=== Computing $d_min $ for a linear code

#definition("Weight of an element")[
  The weight $w(arrow(x))$ of an element $arrow(x) in F^n$ is $ w(arrow(x)) = \# {i st  x_i != 0} $
]

#theorem[
  Given a linear code $C in F^n$ then 
  $ w(arrow(x)) = dh (0, arrow(x)) $


  $ d_min (C) &= w_min (C) =  \ &= min{w(arrow(x)), arrow(x) in C, arrow(x) eq.not 0} \  $
]


#proof[$ w_(min)(C)  &=min{d(0, arrow(x)), arrow(x) in C, arrow(x) eq.not 0} \ 
&>=min{d(arrow(y), arrow(x)), arrow(y), arrow(x) in C, arrow(x) eq.not arrow(y)} $ \ since $0 in C$ due to the linearity of $C$]


== Check matrix

The check matrix $H$ answers to the question: given $arrow(x) in F^n$, does $arrow(x)$ belong to $C$?

The answer is yes if and only if $H arrow(x) = 0$, namely if $C = ker(H)$


#definition("Dual code")[
  Given a code $C in F^n$, the *dual code* of $C$ is defined as $ C^perp eq.delta  {arrow(x) in F^n, arrow(x) dot arrow(c) = 0} forall c in C $
]

Note that, in general $C^(perp perp) = "span"(C)$. In particular, if $C$ is linear, $C^(perp perp) = C$.

Furthermore, whatever $C$ (even non linear), $C^(perp perp)$ is linear.

#theorem[
  If $C subset.eq F^n$ is an $[n,k]$ linear code, then $C^perp$ is an $[n, n-k]$ linear code.
]

==== Proposition

$ arrow(x) in C^perp <==> G arrow(x)^TT = 0 $

where $G$ is a generator matrix of $C$.

#remark[

If $H$ is a generator matrix for $C^perp$, by the previous theorem $arrow(x) in C^(perp perp)$ if and only if $H arrow(x)^TT = 0$. Now, if $C$ is linear, then $C^(perp perp) = C$ and the generator matrix for $C^perp$ is a check matrix for $C$.
]
#example[
  Find a check matrix for the binary Hamming Code [7, 4]. This means that we have to find a generator for $C^perp$. First of all, saying that $ arrow(x) in C^perp <==> G arrow(x)^TT = 0$ is the same as stating the following:
  $ mat(1,0,0,0, 1,1,0;
            0,1,0,0, 1,1,1;
            0,0,1,0,1,0,1;
            0,0,0,1,1,1,1) vec(x_1, dots.v, x_7) = vec(0,0,0,0) \
            arrow.b.double \

    vec(x_1 + x_5 + x_6 ,
        x_2 + x_5 + x_6 + x_7,
        x_3 + x_5 + x_7,
        x_4 + x_6 + x_7) = vec(0,0,0,0)\

                    arrow.b.double \

     cases(x_1 + x_5 + x_6 =0,
        x_2 + x_5 + x_6 + x_7=0,
        x_3 + x_5 + x_7= 0,
        x_4 + x_6 + x_7= 0) arrow.r.double

        cases(x_1 = x_5 + x_6 ,
        x_2 = x_5 + x_6 + x_7,
        x_3 = x_5 + x_7,
        x_4 = x_6 + x_7)
        
            
  $
  So a basis of $C^perp$ is: $ arrow(y_1)=& (1110100)\ arrow(y_2)=& (1101010) \ arrow(y_3)=&(0111001) $ which leads to the *check matrix* $H$.
  $ H=mat(1,1,1,0,1, 0,0;
          1,1,0,1,0, 1,0;
          0,1,1,1,0,0,1) $
]
$H$ coincides with the coefficient matrix of the system defining $C$



== Syndrome

Suppose that Alice sends $arrow(c) in C$ (linear) and that Bob receives (e.g. due to corruption) $arrow(r)$. Suppose also that the channel is not so bad and Bob is able to detect the error.

#definition("Error vector")[
  $ arrow(e) =arrow(r) - arrow(c) $
]

Since $H arrow(c) = 0$ for the properties of $H$ and $H arrow(c) = H(arrow(r) - arrow(e)) ==> H(arrow(r)) = H(arrow(e))$, to find the error $arrow(e)$, Bob has to look among the vectors that have the same image of $arrow(r)$ through $H$.

#definition("Syndrome")[
  Let $C subset.eq F^n$ and $[n,k]$ linear code, and let $H$ a check matrix for $C$. Let $arrow(r) in F^n$ (but not necessarily in $C$). Then $ arrow(s) = H arrow(r)^TT in F^(n-k) $ is called a *syndrome* of $arrow(r)$.
]

#theorem[
  $arrow(x), arrow(y) in F^n$ have the same syndrome if and only if $ exists space arrow(c) in C st arrow(y) = arrow(x) + arrow(c) $
]

#definition("Coset")[
  Given a linear code $C$, we define a *coset* of $arrow(x)$ by: $ arrow(x) + C eq.delta {arrow(x) + arrow(c), arrow(c) in C} $
]

#theorem[
  Given a linear code $C$, then:
  #set enum(numbering: "i.")
  + $arrow(x) in arrow(y) + C ==> arrow(x) + C = arrow(y) + C$
  + $forall arrow(x), arrow(y) in F^n$, either $arrow(x) + C = arrow(y) + C$ or $(arrow(x) + C) sect (arrow(y) + C) = emptyset$
]

#remark[
A code $C$ partitions $F^n$ in the cosets of the elements because belonging to the same set is an *equivalence relation*.
]

We can now go back to the beginning of the section and look at Bob's strategy for correcting the error:

+ Bob receives $arrow(r)$
+ Bob computes $arrow(s)(arrow(r))$
+ If $arrow(s) = 0$ then there is no error and we are done
+ If $arrow(s) eq.not 0$ then Bob has to look at $arrow(r) + C$ and find the element with the minimum weight.

#example[
  Given the $[4,7]$ binary Hamming Code 
  $
H=mat(1,1,1,0,1, 0,0;
          1,1,0,1,0, 1,0;
          0,1,1,1,0,0,1)
  $

#block(
  height: 10em,
  breakable: false,
  columns(2,
    table(
      columns: (.5fr, .5fr),
      table.header("Syndrome", " Coset leader"),
      $vecrow(0,0,0)^TT$, $vecrow(0,0,0,0,0,0,0)$,
      $vecrow(0,0,1)^TT$, $vecrow(0,0,0,0,0,0,1)$,
      $vecrow(0,1,0)^TT$, $vecrow(0,0,0,0,0,1,0)$,
      $vecrow(1,0,0)^TT$, 
      $vecrow(0,0,0,0,1,0,0)$,
      $vecrow(0,1,1)^TT$, $vecrow(0,0,0,1,0,0,0)$,
      $vecrow(1,0,1)^TT$, $vecrow(0,0,1,0,0,0,0)$,
      $vecrow(1,1,0)^TT$, $vecrow(1,0,0,0,0,0,0)$,
      $vecrow(1,1,1)^TT$, $vecrow(0,1,0,0,0,0,0)$,
      
    )
  )
)

  From the second row we get:

  $ H arrow(e) = vec(0,0,1) <==> cases(e_1 + e_2 + e_3 + e_5 = 0 \ e_1 + e_2 + e_4 + e_6 = 0  \ e_2 + e_3 + e_4 + e_7 = 1) $

  The system of equations above is obtained by picking $e_i$ from the elements of $H$ and must be solved finding the solution with the minimal number of "1"s, i.e. the coset leader which, in this case is $vecrow(0,0,0,0,0,0,1)$, in accordance with the table above.
]

#definition("Coset leader")[ A word of minimal weight in a coset is called a _coset leader_. (N.B.: there could be more than a coset leader for a given coset)
  
]

#exercise[
  #set enum(numbering: "ai)")
  Let $C subset.eq ZZ_2^6$ be the $[6,3]$ linear code with generator matrix
  $ G = mat(1,0,0,1,1,0;
            0,1,0,0,1,1;
            0,0,1,1,1,1
          )
  $
  + List the elements of $C$
  + Find the minimum distance of $C$
  + How many errors will $C$ correct?
  + Find a check matrix for $C$
  + Make a syndrome chart for $C$
  + Use the syndrome chart to correct the following errors:
    + $(110101)$
    + $(010111)$
    + $(110111)$

  \ 
  *Solution:*

  + Every element of $C$ is a linear combination of the elements of the basis (the rows): \ $x in C <==> exists alpha_1, alpha_2, alpha_3 st arrow(x) = arrow(alpha) G = alpha_1 arrow(g_1) + alpha_2 arrow(g_2) + alpha_3 arrow(g_3)$ where $arrow(g_i)$ are the rows of $G$. \ So there are $8 = 2^3$ elements where 2 are the choices between 0 and 1 and 3 are the (linearly independent) lines. \ #block(height:6em, breakable: false, columns(4, table(
    columns: 2,
    align: center,
    table.header([$arrow(alpha)$],[$arrow(x)$]),
    $(000)$, $(000000)$,
    $(001)$, $(001111)$, 
    $(010)$, $(010011)$, 
    $(011)$, $(011100)$, 
    $(100)$, $(100110)$, 
    $(101)$, $(101001)$, 
    $(110)$, $(110101)$, 
    $(111)$, $(111010)$, 
  ))) we can notice that all the elements are different since all the rows of $G$ are linearly independent.
  + Since the code is linear, we can consider just the distance from $0$ (i.e. the minimal number of "1"s). This gives $d_min = 3$
  + $floor((3-1)/2) = 1$
  + The check matrix is the generator of $C^perp$ so we need to find a basis of $C^perp$: $
    arrow(x) in C^perp \ <==> x perp arrow(g_j) forall j = 1,2,3 \ <==> G arrow(x)^TT = 0 \ <==> mat(1,0,0,1,1,0;
            0,1,0,0,1,1;
            0,0,1,1,1,1
          ) vec(x_1, x_2, dots.v, x_6) = vec(0,0,0) \
          <==> cases(x_1 + x_4 + x_5 = 0, x_2 + x_5 + x_6 = 0 \ x_3 + x_4 + x_5 + x_6 = 0 ) -> cases(x_1 = x_4 + x_5, x_2 = x_5 + x_6, x_3 = x_4 + x_5 + x_6)
  $
  $x_4, x_5$ and $x_6$ can be chosen freely (but they must be linearly independent) and, starting from them, we can calculate the other variables: 
    $ mat(x_4, x_5, x_6;\(1, 0, 0\);\(0, 1, 0\);\(0, 0, 1\);) ==> mat(x_1, x_2, x_3, x_4, x_5, x_6;
     \(1, 0, 1,#pin(10)1,0,0\);
     \(1,1,1,0,1,0\);
     \(0, 1,1,0,0,1#pin(11)\);) = H $
  We can notice that, similarly to @id_matr we end up with an identity matrix inside $H$.
  
#pinit-highlight(10, 11, stroke: (dash: "dotted"))


  5. To draw the syndrome chart, we have to find the coset leader(s) associated to each syndrome. This means solving the system $H arrow(e)^TT = s_i$ for all possible syndromes $s_i$ and picking the solution(s) with the least amount of "1"s.

  As an example we can find the coset leader for $s_2 = (001)^TT$:
  $
  H arrow(e)^TT = vec(0,0,1) \
  mat(1,0,0,1,1,0;
            0,1,0,0,1,1;
            0,0,1,1,1,1
          ) vec(e_1, dots.v, e_6) = vec(0,0,1) \
  cases(e_1 + e_3 + e_4 = 0 \
        e_1 + e_2 + e_3 + e_5 = 0\
        e_2 + e_3 + e_6 = 1) ==> e_6 = 1
  $
  Which gives (000001) as a coset leader. The same process can be repeated to obtain all coset leaders:

  #block(
    height:8em,
    breakable: false,
    columns(4, 
      table(
        columns: 2,
        align: center+horizon,
        table.header([$arrow(s)^TT$],[C.L.]),
        $(000)$, $(000000)$,
        $(001)$, $(000001)$, 
        $(010)$, $(000010)$, 
        $(011)$, $(010000)$, 
        $(100)$, $(000100)$, 
        $(101)$, $\ (000101) \ (110000) \ (001010)$, 
        $(110)$, $(100000)$, 
        $(111)$, $(001000)$, 
      )
    )
  )

  6. To correct the errors we simply have to find the syndrome associated to the message Bob received and then flip the bit (if any) corresponding to the "1" in the coset leader associated with the syndrome.

  If Bob receives $arrow(x)_1 = (110101)$:
  $ 
    arrow(s)(arrow(x)_1) = H dot arrow(x)_1^TT = vec(0,0,0)
  $
  Since the coset leader for $(0,0,0)^TT$ is $(0,0,0,0,0,0)$ this means that there was no error.

  If Bob receives $arrow(x)_2 = (010111)$:
  $ 
    arrow(s)(arrow(x)_2) = H dot arrow(x)_2^TT = vec(1,0,0)
  $
  In this case the coset leader is $arrow(e_2) = (0,0,0,1,0,0)$ which gives us the correct message:
  $ arrow(c)_2 = arrow(e)_2 + arrow(x)_2 = (0,1,0,0,1,1) $
]



