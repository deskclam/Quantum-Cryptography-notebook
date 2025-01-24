
#import "imports.typ":*

= Block cyphers

Block cyphers are based on two principles by Shannon:

+ *Confusion*: make the connection between the key and the cyphertext as hidden as possible.
+ *Diffusion*: a single bit should influence the ciphertext of other bits. Ideally, changing a bit in the plaintext should result in changes that go beyond the position of that single bit.

In block ciphers, the plaintext is not ciphered bit by bit but block by block so that each bit affects the whole block.

$
x_0, ...,x_(k-1) |-> y_0, ..., y_(k-1)
\
x_(k), ...,x_(2k-1) |-> y_k, ..., y_(2k-1)
$

== Hill cipher

The Hill cipher is the first historical block cipher, in which each block is ciphered with another block, e.g. $A A |-> W Y, A B -> O A, ..., Z Z |-> R B$.

If each block is composed of 2 letters of the alphabet, the substitution table is made of $26 dot 26 = 676$ elements, for block of 3 letters we would have $17476$ elements, too many to memorize. To make the encryption easier, we can use a matrix $K$ with $m$ rows and $m$ columns.

$
K vec(x_0, dots.v, x_(m-1)) = vec(y_0, dots.v, y_(m-1))
$

Diffusion is given by non diagonal elements of the matrix, which tell how a bit affects the other bits in the block.

#exercise([Encoding the word _'snow'_])[
$
K = mat(4, 3 ; 1, 2) \
\"s n\" |-> vec(18, 13) = arrow(x_1) \
\"o w\" |-> vec(14, 22) = arrow(x_2)
$

$
arrow(y_1) = K arrow(x_1) = mat(4, 3 ; 1, 2) vec(18, 13) = mat(4 dot 18+ 13dot 3 mod 26 ; 1 dot 18 + 2 dot 13 mod 26) = vec(7,18) = \"H S\" \
arrow(y_2) = K arrow(x_2) = ... = \"S G\"
$

Note that diffusion is limited inside the block.

In order to decrypt "HSSG", Bob needs to invert the matrix $K$, i.e. find $B$ such that $B K = II$.

Since we are working in modular algebra, it is *not true* that $ "matrix is invertible" <=> det(dot)!=0 $
]<exerc_snow>

#example("Matrix with no inverse")[
  We now consider the matrix $ K' = mat(3,1;1,1) $ wich has determinant $det(K') = 2 eq.not 0$.

  Suppose that $exists B st B K' = II$: $
  mat(a,b;c,d) mat(3,1;1,1) = identitymatrix(2) \
  mat(3a +b, a+b; 3c+d,c+d) = identitymatrix(2) \
  cases(3a+b = 1 quad &(suit.heart) \ a+b = 0 quad &(suit.diamond) \ 3c+d = 0 \ c+d =1)
\
  cases(suit.heart \ suit.diamond) ==> 2a =1 mod 26 ==> "no solution since" gcd(2, 26) = 2 != 1
  $

  This implies that $B$ does not exists and thus that $K'$ has *no inverse in modular algebra*.
]

Another problem is that the matrix must be *injective*, otherwise two different block may be mapped to the same block, making decryption impossible. This condition, in linear algebra, as well as in modular algebra, corresponds to the matrix being invertible.

#theorem("Hill")[

Consider the matrix $K = mat(a, b ; c, d)$ with elements in $ZZ_26$, then the following statements are equivalent:

+ $ a d - b c (equiv det(k)) "is not divisible by neither 2 nor 13" $
+ $ exists B ", a " 2 times 2 " matrix with elements in " ZZ_26 "s.t." B K = II $
+ $ K "satisfies: " arrow(x_1) != arrow(x_2) => K arrow(x_1) != K arrow(x_2) "(Injective)" $
]<hill_theo1>

#proof[We have to prove that $1) ==> 2) ==> 3) ==> 1)$, we do this in three steps:

- $1) ==> 2)$ 

$a b - c d$ is not divisible by 2 or 13 $==> exists h in ZZ_26 st h(a d - b c) = 1 mod 26$

Let $B eq.delta mat(h d , -h b ; - h c, h a)$ then $ B K = h mat(d, -b; -c, a) mat(a, b; c, d) = h mat(a d - b c,  cancel(d b -b d); cancel(-c a + c a), a d - b c) = h(a d - b c) II = II $

- $2) ==> 3)$

We suppose $exists B st B K = II$, if $k arrow(x_1) = k arrow(x_2) ==> underbrace(B K, II) arrow(x_1) = underbrace(B K, II) arrow(x_2) ==> arrow(x_1) = arrow(x_2)$.

Conversely, if $arrow(x_1) !=arrow(x_2) ==>B arrow(x_1) != B arrow(x_2)$

- $3) ==> 1)$

Suppose that $arrow(x_1) != arrow(x_2) => K arrow(x_1) != K arrow(x_2)$, we want to prove that $a d - b c$ is not divisible neither by 13 nor by 2. Suppose that $2 | (a d - b c)$, then $13 (a d - b c) = 0 mod 26$. Then consider $ K vec(13 d, -13 c) =mat(a, b; c, d) vec(13 d, -13 c) = 13 vec(a d - b c, c d - c d) = 13 underbracket(vec(a d - b c, 0), suit.heart) = vec(0, 0) $

Analogously $ K underbracket(vec(-13 b, 13 a),suit.diamond) = vec(0,0) $

Obviously, the two vectors $suit.heart$ and $suit.diamond$ cannot be both $vec(0,0)$, otherwise we would have $K = vec(0,0)$. 

But $K vec(0,0) =vec(0,0)$ implies that there are two vectors ( $mat(0,0)^TT$  and at least one among $suit.heart$ and $suit.diamond$) contradicting  "3)".

The same contradiction can arise from the hypothesis $13|(a d - b c)$
]


#theorem("Generalization of Hill")[
For a Hill cypher with an alphabet of $N$ letters, block size of $m$ and a key matrix $K$, with elements in $ZZ_N$, the following statements are equivalent:

+ $ det(k) "and" N "are coprime" $
+ $ exists B "an" m times m "matrix s.t. " B K = II $
+ $ arrow(x_1) != arrow(x_2) => k arrow(x_1) != k arrow(x_2) $
]

#exercise[
  #set enum(numbering: "1.a)")
  + With the $K$ used to encode _"snow"_ (@exerc_snow) decrypt "HSSG" as if you were Bob.
  + Using $K_2 = mat(25, 0; 2, 1)$
    + Encode _"four"_.
    + Let $alpha_1 alpha_2 alpha_3 alpha_4$ be the answer of a). Encode it with $K_2$ again.
    + Explain
  + Bob receives "SMKH" from Alice with $K_3 = mat(2, 1; 3, 6)$, what is the plaintext?
\
  + $
    K = mat(4, 3 ; 1, 2), det(K)= 5 arrow K^(-1)= 21 dot mat(2, -3 ; -1,4 ) = mat(-10, 15; 5, 6)  \
    \"H S\" |-> vec(7, 18) = arrow(x_1) \
    \"S G\" |-> vec(18, 6) = arrow(x_2) \
    
    arrow(y_1) = K^(-1) arrow(x_1) = mat(-10, 15 ; 5, 6) vec(7, 18) = mat(-70 + 15 dot 18 mod 26 ; 35 - 48 mod 26) = vec(18, 13 ) = \"s n\" \
    arrow(y_2) = K arrow(x_2) = ... = \"o w\" \

    \"H S S G\" |-> \"s n o w\"
  $

  2. \
    + $
    K = mat(25, 0; 2, 1 ) \
    \"f o\" |-> vec(5, 14) = arrow(x_1) \
    \"u r\" |-> vec(20, 17) = arrow(x_2) \
    
    arrow(y_1) = K arrow(x_1) = mat(25, 0 ; 2, 1) vec(5, 14) = mat((25 dot 5) mod 26 ; 10 + 14 mod 26) = vec(21, 24) = \"W Y\" \
    arrow(y_2) = K arrow(x_2) = ... = \"G F\" \

    \"f o u r\" |-> \"W Y G F\"
  $

    + We can notice that $K_2$ is the inverse of itself since $ K_2 dot K_2 &= mat(25, 0; 2, 1) dot mat(25, 0; 2, 1) \ #pin(0) &= mat((-1 dot -1+ 0), 0; 0, (2 dot -1 +1)) \ &= mat(1, 0; 0, 1) $ So encoding twice with $K_2$ is the same as encoding and decoding which is to say doing nothing.
    #pin_left(0, $25 equiv -1 mod 26$)

  3. We start by computing the inverse of $K_3$:
  $
    K_3^(-1) = mat(a, b; c, d) \
    K_3 dot K_3^(-1) = mat(1, 0; 0, 1)\ arrow.double.b \

    cases(2a + c = 1 \ 2b + d = 0 \ 3a + 6c = 0 \ 3b + 6 d = 1 ) ==> cases(a = 18 \ b = 23 \ c = 17 \ d = 6) \

    K_3^(-1) = mat(18, 23; 17, 6)
  $

  The rest of the exercise is the same as the one done before, simply encode the words into vectors and perform the matrix-vector multiplication. The result is _"code"_.
]


#exercise("Attack to Hill cypher 1")[ You have intercepted the message "WGTK" and know it has been encrypted using a Hill cipher. You know also that "cd" is encrypted as "RR" and "jk" is encrypted as "OV", what is the plaintext?
\ As a first thing we need to find the matrix for the encryption by constructing the system of equations given by $c d arrow R R "and" j k arrow O V$: 

$ mat(a, b; c,d) vec(2 , 3) = vec(17, 17) "and" mat(a, b; c,d) vec(9 , 10) = vec(14, 21)  $
This leads to: $ cases(2a +3b =17 \ 2c +3d =17
\ 9a +10b =14 \ 9c +10b = 21
) $  Since we are working in modular algebra in order to find the elements of the matrix is easier to multiply their coefficients that have an inverse in $mod 26$ by this inverse: $ 9 times cases(2a +3b =17 \ 2c +3d =17 ) arrow cases(18a +b =23 =-3 \ 18c +d =23 = -3) => cases(b=-3 -18a \ d = -3 -18c) \
cases(9a + 10(-3-18a)=14 \ 9c + 10(-3-18c)=21) => cases(11a = 18 \ 11c =25) arrow 19 times cases(11a = 18 \ 11c =25) => cases(a = 56 = 4 \ c =-19 = 7)  
$ 
And substituting $a "and" c$ in the previous relations we find $b=3 "and" d= 1$ so the matrix $k$ is:
$ mat(4, 3; 7,1 ) $

To decrypt the message we need now to find the inverse. $ det(K)= 4-21 = -17 = 9$ and its inverse is $3$
$ K^(-1)= 3 dot mat(1, -3; -7, 4) = mat(3, -9; 5, 12) $

Now we decrypt by applying $K^(-1)$ to the vectors corresponding to "WGTK", that are $(22, 6)^T$ and $(19, 10)^T$: $ mat(3, -9; 5, 12) vec(22, 6) = vec(12, 0) = vec(M, A) \
mat(3, -9; 5, 12) vec(19, 10) = vec(19, 7) = vec(T, H )
$
]
