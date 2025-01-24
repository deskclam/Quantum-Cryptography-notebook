#import "imports.typ":*
#import fletcher.shapes: pill

= Elliptic curves

#definition([Elliptic curve in $RR_2$])[
  An elliptic curve in $RR_2$ is the set of points $(x,y)$ that satisfies: $ cases(y^2 = x^3 + a x + b  \ 
  4 a^3 + 27 b^2 = 0)quad a,b in RR
  $
]
#let d=70%
#subpar.grid(
  columns: (1fr, 1fr, 1fr),
  figure(image("Images/ec_non_diff.png", width: d), caption: $4 a^3 + 27 b^2 = 0$),
  figure(image("Images/ec_class_1.png", width: d), caption: $4 a^3 + 27 b^2 > 0$), 
  figure(image("Images/ec_class_2.png", width: d), caption: $4 a^3 + 27 b^2 < 0$)
)

*Remarks*

#let EC = [$E C$]

- The upper branch tends to $y ~ x^(3 slash 2)$ as $x -> infinity$
- The curve is symmetric with respect to the $x$ axis, i.e. if $(x, y) in EC ==> (x, -y) in EC$

We now want to find a group structure in the elliptic curve, namely an internal operation "$+$" (improperly called "sum") that takes a couple of points in the EC and maps them to the elliptic curve itself: $ +: EC times EC |-> EC \ (x_1, y_1) times (x_2, y_2) |-> (x_3, y_3) $

For the following, we will need another point, called *point at infinity* $cal(O)$. We will then work with $cal(G)' = EC union {cal(O)}$.

#definition("Sum")[ \
   $ P = (x_1, y_1) \
   Q = (x_2, y_2) \
   R = (x_3, y_3) = P + Q $ 
   
  + $forall P in cal(G)' quad P + cal(O) eq.delta P = cal(O) + P$
  
  + If $x_1 != x_2$ we consider the line going through $P$ and $Q$, it will intersect the #EC in another point $R'$. $R$ is the symmetric of $R'$ with respect to the $x$ axis: $ cases(x_3 = ((y_2 - y_1)/(x_2 - x_1))^2 -x_1 -x_2\ 
        y_3 = -y_1 + ((y_2 - y_1)/(x_2 - x_1))dot (x_1 - x_3)) $
  + If $x_1 = x_2" and " y_1 != y_2$ (the points are one above the other), then $P + Q = cal(O) ==> Q = P^(-1)$
  + If $P = Q$ and the tangent to the #EC passing through $P$ is not vertical, then it will intercept the #EC in another point $R'$. Similarly to above, the sum will be the symmetric of $R'$ with respect to the $x$ axis. What we get is $ cases(x_3 = ((3x_1^2 + a)/(2y_1))^2 - 2x_1 \ y_3 = -y_1 + (3 x_1^2 + a)/(2y_1) (x_1 - x_3)) $ which is coherent with case 2.
  + If $P = Q$ and the tangent passing through them is vertical then $P + Q = cal(O)$

    #figure(
      image("Images/ellipsum.svg", width: 110%),
      caption: [Sum with elliptic curves]
    )

] <ec_sum>

*Proposition*

$(cal(G)', +)$ is an Abelian group.

Since we want to work with finite fields (and elliptic curves are infinite), we work in modulo.

#definition[
  Consider $p>3$ prime. Let $a,b in ZZ_p st 4 a^3 + 27 b^2 != 0 mod p$
  $
  cal(G)= {(x,y) st y^2 = x^3 + a x + b mod p} union {cal(O)}
  $
  with the internal operation given by the formulas for $cal(G)'$ (@ec_sum) in $mod p$.
]

The following theorem tells us how many points we have in the resulting group $cal(G)$:

#theorem("Hasse")[
  $ p+1 - sqrt(p) <= |cal(G)| <= p + 1 + 2 sqrt(p) $
]
