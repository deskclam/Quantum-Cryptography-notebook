#import "imports.typ": * 
= Quantum error correction
== Introduction to Shor's correcting code
=== X-correcting code
*_Problem:_* protecting the state of one qubit $ket(s)= a ket(0)+b ket(1), a,b in CC, abs(a)^2 + abs(b)^(2) = 1 $

Meaning that if the state  is corrupted (modified by accident in an uncontrollable way), then we are able to recover it again, i.e. recover $a "and" b$. Every possible accident is represented by a $2 times 2$ unitary matrix.

We can:
+ Add other qubits
+ Apply any unitary transformation on the whole system
+ Perform measurements: projective and "incomplete" (i.e. the eigenspaces are not one-dimensional)

=== 1st step: X-correcting code
We suppose that the only possible error is described by: 
$ 
sigma_x = mat(0,1 ;1, 0), quad cases(sigma_x ket(0)= ket(1), sigma_x ket(1)= ket(0))
$

Preliminary step: $ket(s) arrow ket(s)underbrace(ket(00), "Two new" \ "qubits")=a ket(000)+b ket(100)$

Now we use a unitary transformation that maps 
$ 
ket(000) arrow ket(000) quad quad ket(100) arrow ket(111)
$
(the action on the other elements of the computational basis is irrelevant) so:
$ 
ket(s_c) =a ket(000) +b ket(111) quad "quantum coding"
$

The error $sigma_x$ affects one of the three qubits but we don't know which one.
$ 
ket(s_c)= cases(sigma_x "on 1st" arrow a ket(100)+ b ket(011)= ket(s_(c 1)), 
                sigma_x "on 2nd" arrow a ket(010)+ b ket(101)= ket(s_(c 2)),
                sigma_x "on 3rd" arrow a ket(001)+ b ket(110)= ket(s_(c 3)),)
$
We measure the observable $O$ whose eigenspaces are:
$
lambda=1, quad E_1 = "span"{ket(100), ket(011)} => P_1 = ket(100) bra(100)+ ket(011) bra(011)  
\ 
lambda=2, quad E_2 = "span"{ket(010), ket(101)} => P_2 = ket(010) bra(010)+ ket(101) bra(101) 
\
lambda=3, quad E_3 = "span"{ket(001), ket(110)} => P_3 = ket(001) bra(001)+ ket(110) bra(110)  
\ 
lambda=4, quad E_4 = "span"{ket(000), ket(111)} => P_4 = ket(000) bra(000)+ ket(111) bra(111) 
$

Suppose now that $sigma_x$ affected the 1st qubit, after the measurement, we obtain $lambda=1 $ so we discover that the wrong bit is the first.

We apply $sigma_x$ on the first qubit and obtain $ ket(s_c)= (sigma_x times.circle II times.circle II)ket(s_(c 1)) $
The same procedure holds in the case the error affects the other qubits or in the case there is no error to correct.

#remark[
  + We always assume that only 1 qubit is affected by the error
  + The measurement did not perturb $ket(s_c)$ but only revealed which bit was affected
  + This protocol can correct more general errors
]

Consider an error represented by:
$ 
U = mat( cos(theta) , i sin(theta);
         i sin(theta), cos(theta)) quad quad theta in [0, 2 pi )
$<unitary_xcorr>

Assume e.g. $U$ affects the 2#super[nd] qubit:

As before 
$
&ket(s) arrow ket(s_C) arrow (II times.circle U times.circle II)ket(s_C)= \ &= a(ket(0)U ket(0) ket(0)) +b(ket(1) U ket(1) ket(1)) \ 
&= a(ket(0) (cos(theta)ket(0)+i sin(theta) ket(1)) ket(0)) + b(ket(1) (cos(theta)ket(1)+i sin(theta) ket(0)) ket(1)) \
&= a(cos(theta)ket(000)+i sin(theta) ket(010)) + b((cos(theta)ket(111)+i sin(theta) ket(101)) 
$

Applying the same observable as before, two outcomes are possible: $lambda=2 "and" lambda=4$

If $lambda=2$:

$ 
(P_2 ket(s'_C))/(norm(P_2) ket(s'_C)) &= (i sin(theta)(a ket(010)+b ket(101)))/
(sqrt(sin^2 (theta)(abs(a)^2 +abs(b)^2))) = \
&= i sin(theta)/abs(sin(theta)) (a ket(010) +b ket(101))

tilde a ket(010) +b ket(101)
$
Applying $sigma_x$ to the 2#super[nd] qubit, we get $ket(s_C)$


If $lambda=4$:

$ 
(P_4 ket(s'_C))/(norm(P_4) ket(s'_C)) = (cancel(cos(theta))(a ket(0)+b ket(1)))/cancel(abs(cos(theta)))  tilde.equiv a ket(000) +b ket(111) = ket(s_C)
$

#remark[ The protocol cannot correct Z-type errors:
$
II times.circle II times.circle sigma_z ket(s_C)= a ket(000) - b ket(111)
$
The information of which qubit was affected by the error is lost.

Notice that in this case the measurement modified the state
]
=== Quantum correcting code for Z-type errors

$
ket(+) = (ket(0)+ket(1))/(sqrt(2)) quad ket(-)= (ket(0)-ket(1))/(sqrt(2)) \
sigma_z ket(+) = ket(-) quad sigma_z ket(-) = ket(+)
$
We start from $ket(s)= a ket(0) +b ket(1)$
with a unitary transformation  $ H: &ket(0) arrow ket(+) \ &ket(1) arrow ket(-) $
So the state becomes: $ket(s')= a ket(+)+b ket(-)$

Adding two qubits and proceeding like in the previous case $ket(s_C)= a ket(+++) + b ket(---)$

Considering an another observable:

$
mu=1, quad Q_1 =  ket(-++) bra(-++)+ ket(+--) bra(+--)  
\ 
mu=2, quad Q_2 =  ket(+-+) bra(+-+)+ ket(-+-) bra(-+-) 
\
mu=3, quad Q_3 = ket(++-) bra(++-)+ ket(--+) bra(--+)  
\ 
mu=4, quad Q_4 =  ket(+++) bra(+++)+ ket(---) bra(---) 
$

#example[
  This protocol corrects one error of the kind 
  $ 
  V= mat(1, 0; 0, e^(i phi.alt))
  $
  In the basis ${ket(0), ket(1)}$

  Writing $V$ in the basis ${ket(+), ket(-)}$ 

  $
  V ket(+) &= V (ket(0)+ket(1))/(sqrt(2)) = (ket(0)+e^(i phi.alt) ket(1))/(sqrt(2)) \ 
  &= (ket(+) + ket(-)+ e^(i phi.alt)ket(+) - e^(i phi.alt)ket(-))/(2) = \
  &= (1+e^(i phi.alt))/(2) ket(+) + (1 - e^(i phi.alt))/(2) ket(-) \
  &tilde cos(phi.alt/2)ket(+) - i sin(phi.alt/2) ket(-) \ \
  $
  $ 
  V ket(-) &= (1-e^(i phi.alt))/(2) ket(+) + (1+e^(i phi.alt))/(2) ket(-) \
  &tilde cos(phi.alt/2)ket(-) - i sin(phi.alt/2) ket(+)

  $
  So the the matrix can be written as: $ V'= mat(cos(phi.alt /2), -i sin(phi.alt /2);-i sin(phi.alt /2), cos(phi.alt /2) ) $
  which is the same example made for the X-correcting code (see @unitary_xcorr)
]
== The Shor code #footnote[A possible implementation of the Shor code can be found #link("https://algassert.com/quirk#circuit={%22cols%22:[[%22%E2%80%A2%22,1,1,%22X%22],[%22%E2%80%A2%22,1,1,1,1,1,%22X%22],[%22H%22,1,1,%22H%22,1,1,%22H%22],[%22%E2%80%A2%22,%22X%22],[%22%E2%80%A2%22,1,%22X%22],[1,1,1,%22%E2%80%A2%22,%22X%22],[1,1,1,%22%E2%80%A2%22,1,%22X%22],[1,1,1,1,1,1,%22%E2%80%A2%22,%22X%22],[1,1,1,1,1,1,%22%E2%80%A2%22,1,%22X%22],[1,1,1,1,1,1,%22%E2%80%A6%22],[%22%E2%80%A2%22,%22X%22],[%22%E2%80%A2%22,1,%22X%22],[%22X%22,%22%E2%80%A2%22,%22%E2%80%A2%22],[1,1,1,%22%E2%80%A2%22,%22X%22],[1,1,1,%22%E2%80%A2%22,1,%22X%22],[1,1,1,%22X%22,%22%E2%80%A2%22,%22%E2%80%A2%22],[1,1,1,1,1,1,%22%E2%80%A2%22,%22X%22],[1,1,1,1,1,1,%22%E2%80%A2%22,1,%22X%22],[1,1,1,1,1,1,%22X%22,%22%E2%80%A2%22,%22%E2%80%A2%22],[%22H%22,1,1,%22H%22,1,1,%22H%22],[%22%E2%80%A2%22,1,1,%22X%22],[%22%E2%80%A2%22,1,1,1,1,1,%22X%22],[%22X%22,1,1,%22%E2%80%A2%22,1,1,%22%E2%80%A2%22]]}")[here]]
Now we put the two schemes together to create an error-correction protocol that protects against _all_ single-qubit errors. We begin by appending eight additional qubits in a standard state and then perform a unitary transformation so that the state $ket(0)$ ends up encoded as: 
$ ket(0_C)= 1/(2sqrt(2)) (ket(000)+ket(111)) times.circle (ket(000)+ket(111)) times.circle (ket(000)+ket(111)) $ 
And the state $ket(1)$ is encoded as:

$ ket(1_C)= 1/(2sqrt(2)) (ket(000)-ket(111)) times.circle (ket(000)-ket(111)) times.circle (ket(000)-ket(111)) $ 
Thus the initial state $ket(s)=a ket(0)+b ket(1)$ is encoded as $ket(s_C)=a ket(0_C)+b ket(1_C)$ 

Let's see this encoding step by step:
\ As a first thing we do a "_partial cloning_":
$ ket(0) arrow ket(000000000) \ 
  ket(1) arrow ket(111111111)
$
And then we use some unitary operators that, analogously with the X-correcting code:
$ 
(ket(000))^(times.circle 3) arrow ((ket(000)+ket(111))/sqrt(2))^(times.circle 3) \

(ket(111))^(times.circle 3) arrow ((ket(000)-ket(111))/sqrt(2))^(times.circle 3)

$
Thus this code can correct:
$X_1,...,X_9; quad Z_1, ...,Z_9; quad X_1Z_1, ..., X_9Z_9 "errors"$ that apparently are 27 single qubit errors, but:
$ Z_1 ket(0_C)&= 1/(2sqrt(2)) (ket(000)-ket(111)) times.circle (ket(000)+ket(111)) times.circle (ket(000)+ket(111)) \ 
&= Z_2 ket(0_C) = Z_3 ket(0_C) $

and the same true is for $Z_1 ket(1_C) =Z_2 ket(1_C) = Z_3 ket(1_C) $.

 So the possible errors are 21: $ underbracket((X_1,...,X_9), 9); quad underbracket((Z_1, Z_2,Z_3), 1),underbracket((Z_4, Z_5,Z_6), 1), underbracket((Z_7, Z_8,Z_9), 1); quad underbracket((X_1Z_1, ..., X_9Z_9), 9) $

We need an observable $O$ whose eigenspaces are the spans of $(theta.alt ket(0_C),theta.alt ket(1_C))$ where $theta.alt$ is any of the allowed errors. 

*How to construct the observable?*

We define the subspaces 
$ 
 E_X_1 = "Span"{ & X_1 ket(0_C), X_1 ket(1_C)}= 
\  = "Span"{ & 1/(2sqrt(2)) (ket(100)+ket(011)) times.circle (ket(000)+ket(111)) times.circle (ket(000)+ket(111)), \ & 1/(2sqrt(2)) (ket(100)-ket(011)) times.circle (ket(000)-ket(111)) times.circle (ket(000)-ket(111))} \  dots.v 
\ E_X_9 = "Span"{ & dots, dots} \  dots.v \
E_Z_8 = "Span"{ & 1/(2sqrt(2)) (ket(000)+ket(111)) times.circle (ket(000)+ket(111)) times.circle (ket(000)-ket(111)), \ & 1/(2sqrt(2)) (ket(100)-ket(011)) times.circle (ket(000)-ket(111)) times.circle (ket(000)+ket(111))} \  dots.v \
E_(X_5 Z_5)="Span"{ & 1/(2sqrt(2)) (ket(000)+ket(111)) times.circle (ket(010)-ket(101)) times.circle (ket(000)+ket(111)), \ & 1/(2sqrt(2)) (ket(000)-ket(111)) times.circle (ket(010)+ket(101)) times.circle (ket(000)-ket(111))} \  dots.v
$

In this way we construct $22$ two-dimensional mutually orthogonal subspaces (the listed ones plus $"Span"{ket(0_C), ket(1_C)}$). But the whole space has $512$ ($2^9$) dimensions. What is the meaning of the missing $490$? They describe spaces with more than one error.

=== Arbitrary one-qubit errors
*Proposition:* Every unitary matrix U can be written as a linear combination of $II, sigma_x, sigma_y, sigma_z$, so by a linear combination of $II, sigma_x, sigma_z, sigma_x sigma_z$.

So, $exists t, u, v, w st W = t II, u sigma_x, v sigma_z, w sigma_x sigma_z ("where" t, u, v, w in CC)$

Take $j in {1, dots, 9}, quad ket(s'_C)= W_j ket(s_C)$. Measuring with our previous observable, the state precipitates to one of the $22$ subspaces $=>$  no perturbation is the collapsed state $=>$ we gain $ket(s_C)$.

If we find an eigenvalue corresponding to a subspace related e.g. to $X_5 Z_5$, then we know that the collapsed state is 
$
P_(X_5 Z_5) W_5 ket(s_C) = & t ket(s_C) + u sigma_X_5 ket(s_C) + v sigma_Z_5 ket(s_C) + w sigma_X_5 sigma_Z_5 ket(s_C) \ =& (w sigma_X_5 sigma_Z_5 ket(s_C))/(abs(w)) tilde sigma_X_5 sigma_X_5 ket(s_C)
$
That is reversed by applying $sigma_X_5 sigma_Z_5$, obtaining $ket(s_C)$.

#exercise[Problem 5 from Loepp-Wootters
\
Consider the code defined by @7.37. Suppose that the last
of the three qubits interacts with a fourth qubit from outside the quantum computer. This fourth qubit starts out in the state $1/2(ket(0)+ket(1))$
and the third and fourth qubits are acted upon by the operation $"CNOT"_(43)$.
(The subscripts indicate that the fourth qubit is the control and the third
qubit is the target.) Show that the standard error-correction process for
the X-correcting code also corrects this error. (For this problem you will
need to use new versions of the projection operators $P_1, dots, P_4$, since the
space that needs to be acted upon is now a four-qubit state space. This
is a straightforward extension, in which the P operators leave the fourth
qubit unaffected. For example, whereas the original version of $P_1$ projects
onto the subspace spanned by $ket(100) "and" ket(011)$, the new version will project
onto the four-dimensional subspace spanned by $ket(1000),ket(1001), ket(0110), ket(0111)$. In other words, the new version of $P_1$ is $P_1 times.circle II$, where $II$ is the identity operator on the fourth qubit.

Solution: $
ket(s_c)= a ket(000) + b ket(111)
$<7.37>

$ ket(s_c) &times.circle 1/sqrt(2)(ket(0)+ ket(1)) 
\ &=(1/sqrt(2))(a ket(0000) + b ket(1110) + a ket(0001) + b ket(1111) ) \ &arrow.double.b "cnot = error" \
&= (a ket(0000)+ b ket(1110))/(sqrt(2)) + (a ket(0011)+ b ket(1101))/(sqrt(2)) = ket(s'_c)
$
$
P_1 &= "error on 1st qubit" = (ket(100)bra(100)+ket(011)bra(011)) times.circle II_4 \
P_2 &= "error on 2nd qubit" = (ket(010)bra(010)+ket(101)bra(101)) times.circle II_4 \
P_3 &= "error on 3rd qubit" = (ket(001)bra(001)+ket(110)bra(110)) times.circle II_4 \
P_4 &= "error on 4th qubit" = (ket(000)bra(000)+ket(111)bra(111)) times.circle II_4
$
Now we compute the application of $P_1$ to $ket(0000)$
$
P_1 ket(0000) &=  ket(100)bra(100) ket(0000)+ket(011)bra(011)ket(0000) = \
&= ket(100)underbracket(bra(100) ket(000), =0)ket(0)+ket(011)underbracket(bra(011)ket(000), =0)ket(0) = 0
$
Notice that only the first three qubit play a role when one applies the projection (on the 4th there is the identity)

So, $P_1 ket(s'_c)=0$ and analogously $P_2 ket(s'_c)=0$. Omitting the terms equal to 0 and some other calculations, the application of $P_3$ and $P_4$ gives, with an example of application of $P_3 "on" ket(0011)$:
$
P_3 ket(0011) &=  ket(001)bra(001) ket(0011)+ket(110)bra(110)ket(0011) = \
&= ket(001)underbracket(bra(001) ket(001), =1)ket(1)+ket(110)bra(110)ket(001)ket(1) = ket(001) ket(1) 

$
$
P_3 ket(s'_c) &= (a ket(001)+ b ket(110))/(sqrt(2)) times.circle ket(1) arrow X_3 arrow ket(s_c) times.circle ket(1) \

P_4 ket(s'_c) &= (a ket(000)+ b ket(111))/(sqrt(2)) times.circle ket(0) arrow II arrow ket(s_c) times.circle ket(0)
$]

