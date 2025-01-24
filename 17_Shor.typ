#import "imports.typ": * 

= Shor's Algorithm

The aim is to factor a natural number in polynomial (in the number of bits) time.
In RSA it takes an exponential amount of time to find the factors of $N= p q$, with $p$ and $q$ primes, knowing $N$.

Shor's algorithm finds the order of some $a in ZZ_N$ prime with respect to $N$.

#exercise[Factor the number $M=39$

Choose $a= 5$, $gcd(a, M)=gcd(5,39)= 1$ ($a "and" M$ are relatively prime)

*N.B.:* It is fast to compute gcd and then to decide whether two numbers are relatively prime or not, through Euler's algorithm.

_Step 1_: Compute the order of $5$ in $ZZ_39$ or with respect to $39$.

The order of $a$ with respect to $M$ is the smallest number $r$ such that $ a^r=1 mod M $
$5^0=1, space 5^1=5, space 5^2=25, space 5^3=125= 8 mod 39, space 5^4=40 equiv 1 mod 39$

So the order $r= 4$ 

_Step 2_: Factor $a^r -1$

$k dot 39= 0 mod 39 = 5^4-1 = (5^2+1)(5^2-1)=24 dot 26 $
#remark[From the identity $26 dot 24= k dot 39$ all the prime factors of $39$ are contained in $26 dot 24$ so they are present either in $24$ or $26$.

In order to find such prime divisors, instead of decomposing $24$ and $26$ (which is in general long) we can proceed by the following step (_Step 3_) ]

_Step 3_: Computing the $gcd(a^(r slash 2)-1, M)$ and $gcd(a^(r slash 2)+1, M)$ 

$gcd(24, 39)=3, quad gcd(26, 39)=13$

As a result, $39=3 dot 13$
]

#example[
  $ 2^4 &=1 mod 15 => (2^2 -1)(2^2 +1) = k dot 15 \ 
  2^8 &= 1 mod 15 => (2^4 -1)(2^4 +1) = k dot 15
  $
*N.B.:* From this identity one does not get the factorization of $15$
]

#example[
  
$M=26, quad a=3, quad => quad 3^0=1, 3^1=3,
3^2=9, 3^3=27 = 26 +1 equiv 1 mod 26$

Thus $r=3$ and following the previous steps $space (3^(3 slash 2)-1)(3^(3 slash 2)+1)  $ but it is not allowed in $ZZ_(26)$

The method works for all cases in which: 
- the order is even 
- the factors of M are not all in either $a^(r slash 2)-1 "or" a^(r slash 2)+1$
  
]

== A bit of theory
+ Existence of the order
+ Choosing $a$ randomly gives a probability larger than $1/2$ to succeed in passing from the order of $a$ to the factor of $M$
#proof[Existence of the order

Given $M$ and $0<a<= M-1, quad gcd(a, M)=1$. This means that $a^x $ is periodic in $x$ and $exists macron(x) st a^x equiv 1 mod M$

$a^x in {1, dots, M-1}$ which is a finite set, while $x in NN $ then $ exists space x "and" y, x<y st space a^x =a^y= a^(x+T) quad "where" T=y-x >0 $


Now $gcd(a,M)=1 => gcd(a^x, M)=1 => exists b in ZZ_M space st space b a^x = 1$

Therefore, $ b a^x = b a^y = b a^(x+T) =b a^x a^T => a^T=1 $
Moreover, $forall x in NN$, $ a^x =a^x 1 = a^x a^T = a^(x+T) => a^x "is periodic in "x $ 
]
#corollary[It exists a minimal period, which is also the minimal number $r$ such that: $ a^r =1 mod M $
This is called the *order* of $a$]

#remark[The fact that $M$ is not prime is used in the method we developed in the identity $(a^(r slash 2)-1)(a^(r slash 2)+1) equiv 0 mod M$.] Since this is fulfilled by both non-trivial factors, this implies that $ZZ_M$ is not an integrity domain, which is equivalent to saying that $M$ is not prime.

=== The choice of $a$:
To factor $M$, pick $a in {2, dots, M-1}$ and compute the order $r "of" a$ 
$ a^r = 1 mod M \ 

(a^(r/2)-1)(a^(r/2)+1)=0 mod M \ 

gcd(a^(r/2)-1, M) "and" space gcd(a^(r/2)+1, M) "are divisors of " M $
$a$ is to be chosen such that:
+ $r$ is even.
+ $a^(r/2)-1 "and" a^(r/2)+1$ are not zero.

#example[ factor $M=77$

$a$ has to be coprime with respect to $77 space (77 = 11 dot 7)$ \
*Lemma*: Let $r_1$ be the order of $a$ with respect to $7$, $r_2$ the order of $a$ with respect to $11$, then $ r eq.delta "lcm"(r_1, r_2) $\
#proof[$r$ must be a multiple of $r_1$ and $r_2$. Indeed: \
$ a^r = 1 mod 77 => a^r = 1+77k = 1+ 7 dot 11k \
a^r = 1 mod 7 "and" a^r = 1 mod 11
$<shorr> 
Now, $a^r = 1 mod 7$ implies that  $r$ is a multiple of $r_1$. If not, $ 1 equiv a^r = a^([r"/"r_1]r_1)a^(r') $<shorrrr> where $[dot]$ denotes the integer part and $r'$ is the remainder of the division $r/r_1$, so $r'< r_1$ and starting from @shorrrr:
$ 1 equiv 1^([r"/"r_1])a^r' => a^r'=1 mod 7 $
Which is impossible since $r'< r_1$. $r'$ cannot be the order of $a mod 7$, i.e. the least number $rho$ for which $a^rho =1$.

Analogously, $r$ is a multiple of $r_2$. Now we need to prove that if $rho$ is a multiple of $r_1$ and $r_2$, then $a^rho = 1 mod 77$.
\ Indeed, $rho = k_1r_1= k_2r_2$. Then,  
$
a^rho = a^(k_1r_1) equiv 1^(k_1) mod 7 = 1 mod 7 = 1+ j_1 dot 7 \
a^rho = a^(k_2r_2) equiv 1^(k_2) mod 11 = 1 mod 11 = 1+ j_2 dot 11 \
j_1 dot 7 = j_2 dot 11 = j dot 7 dot 11 \
a^rho = 1+ j dot 77equiv 1 mod 77
$
Finally $a^rho equiv 1 mod 77$ iff $rho$ is a multiple of $r_1$ and $r_2$. The order $r$ must be the $"lcm"(r_1, r_2) $.
]
In conclusion, to single out the elements $a$ that have odd order, one has to study the order of the elements of $ZZ^*_7$ and $ZZ^*_11$
]

*Lemma:* The problem $ x equiv a_1 mod 7 \ x equiv a_2 mod 11 $
Always admits one solution only.

#proof[Firstly, we prove the existence:
$ x equiv a_1 mod 7 &=> x= a_1 +11 k_2\ x equiv a_2 mod 11 &=> x= a_1 +7 k_1  \ &=> a_1 +7k_1 = a_2 +11 k_2 \ &=> a_1 -a_2 = 11k_2 -7k_1 $
The problem is to find a couple $k_1, k_2$ that fulfills the relation. 

We can see that choosing $k_2= 2(a_1 -a_2)$ and $k_1= 3(a_1 -a_2)$ it is fulfilled, which means:
 $ x &= a_1 + 3 dot 7 (a_1-a_2) = 22 a_1 - 21 a_2 \
 
 x &= a_2 + 2 dot 11 (a_1-a_2) = 22 a_1 - 21 a_2
 $

 Now we have to prove uniqueness. Suppose to have two such solutions: \
 $
 x &= a_1 + 7 dot k_1 = a_2 + 11 dot k_2 \ 
 y &= a_1 + 7 dot k'_1 = a_2 + 11 dot k'_2 
\
x-y &= 7(k_1 - k'_1) = 11(k_2 - k'_2) = 5 dot 77
 =>  x equiv y mod 77  $]
 Then one has to exclude $8$ possible $a$'s from the initial choice, that was of $60$ elements.
 #remark[instead of $77$, one can choose another number with two prime factors $p$ and $q$. The final result is a corollary of the _Chinese Remainder Theorem_!
]
=== Second and last problem
We want to find the $a$'s for which $r$ is even but 
$
(a^(r/2)-1)(a^(r/2)+1) equiv 0 mod M (= 77)
$
but $ gcd(a^(r/2)-1, M)=M "or" gcd(a^(r/2)+1, M)=M  $
and this is impossible. If $ gcd(a^(r/2)-1, M)=M => a^(r/2) -1 =k M \ a^(r/2) equiv  1 mod M $  
But $r/2 < r = min { rho st a^rho equiv 1 mod M}$ is *absurd*.
So, the only possible occurrence to discuss is $ gcd(a^(r/2)+1, M) = M => a^(r/2) equiv -1 mod M $

*Lemma:* If $b equiv -1 mod 77$, then $b equiv -1 mod 7$ and $b equiv -1 mod 11$

#proof[$ b equiv -1 mod 77 <=> b= -1 + k dot 77= -1 + k_1 dot 7 = -1 + k_2 dot 11 $
\ So $b equiv -1 mod 7 "and" b equiv -1 mod 11$
]

We have that $a^(r/2) equiv -1 mod 7 "and" b equiv -1 mod 11$. Now, which element of $ZZ_7 ^*$ and of $ZZ_11 ^*$ can $a$ be? Only an element whose power is $-1$.

After looking at the respective multiplicative tables of $ZZ_7 ^*$ and $ZZ_11 ^*$, a can be: 
$ 
a equiv cases(3 "or" 5  "or" 6 "in" ZZ_7 ^*,
2 "or" 6  "or" 7 "or" 8 "or" 10 "in" ZZ_11 ^*)
$
They are $15$ elements. We have to exclude *at most* 15 elements, plus 8 from the previous observations, obtaining $23$. We prove that this result is optimal. This means that out of $60$, $37$ are good.

*Lemma:* If $x = b mod 7 "and" x = b mod 11 => x = b mod 77$

#proof[ $
x = b +7 dot k_1 = b + 11 dot k_2 => 7k_1 = 11k_2 = 77k
$]

So, in the case we analyzed throughout this topic, $a^15 = -1 mod 77$

#example[ consider the case : $ 
a equiv 3 mod 7 &"and" a equiv 10 mod 11 \
r_1 = 6, &space r_2 = 2
\ => a^3 &equiv -1 mod 7   
\ a^3 &equiv -1 mod 11
\ => a^3 &equiv -1 mod 77

$ 

]