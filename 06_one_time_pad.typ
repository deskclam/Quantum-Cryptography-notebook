#import "imports.typ":*

== One time pad

#[
#set align(center)  
#diagram(
spacing: (10mm, 5mm), // wide columns, narrow rows
node-stroke: 1pt, // outline node shapes
edge-stroke: 1pt, // make lines thicker
mark-scale: 60%, // make arrowheads smaller
node((1,0), "Alice"),
edge((1,0), "rr",  "-|>"),
node((3,0), [*+*]),
node((3, -1), "k"),
edge((3,-1), "d", "-|>", $s_i$),
edge((3,0), "rrr",  "-|>", $y_i= \ x_i xor s_i$),
node((6,0), "Insecure channel", shape: pill),
node((6, -1), "Eve"),
edge((6, -1), "d", "-|>"),
edge((6,0), (8,0),  "-|>", $y_i$),
node((8,0), "Bob")
)
]        
+ The keystream is generated by a TRNG
+ The keystream is communicated from A to B (or B to A) and it has to be as long as the plaintext.
+ The bits have to be used only once.

#example[
1-bit message


#grid(columns: (1fr, 2fr),
grid.cell(table(
  columns: 3,
  table.header([$x_i$],[$s_i$], [$y_i$]    
  ),
  [0],[0],[0],
  [0],[1],[1],
  [1],[0],[1],
  [1],[1],[0]
)),
[In this case, whatever $x_i$: $ y_i= cases(
  0 space "with probability" 1/2,
  1 space "with probability" 1/2
  
)  $ provided that the TRNG is perfectly balanced.],

) 
]
#theorem[Consider an arbitrary plaintext (k-bit) message $x in underbracket(ZZ_2 crossproduct ZZ_2 crossproduct ... crossproduct ZZ_2,k "times") $ 

Let $y in underbracket(ZZ_2 crossproduct ZZ_2 crossproduct ... crossproduct ZZ_2,k "times") $ be the ciphertext corresponding to $x$ through a OTP encoding. Then the probability of occurrence of $y "is" P(y)=1/2^k$

Vice-versa given $y$ the probability that a certain $x$ in the same space is the originating plaintext is $P(x)=1/2^k$ (this is the Eve probability point of view)]

#proof[Let $x=(x_0,...,x_(k-1))$ and $y=(y_0,...,y_(k-1))$ exists one and only one key stream $(s_0,...,s_(k-1))$ that maps $x "into" y$. In fact it is defined by: $ s_i=x_i xor y_i $<dd>
Now the key stream given by @dd occurs with probability $1 slash 2^k$ provided that a TRNG is used and all $S_i$s are independent of each other and balanced.
The proof for the second part is identical.] 

#definition("Correct encryption scheme")[An encryption scheme ($e, d$) is called *correct* if, for every plaintext $x$ and every key $k$, we have that $d(e(x,k),k)=x$.
]
#definition("Perfectly secure encryption scheme")[
It is also called *perfectly secure* if for any distribution $P$ (probability) over the space of the plaintext $X $, the following operations are identical:
- Generate a random plaintext $x in X$ with probability $P(x)$
- Consider an arbitrary ciphertext $y$. Generate a uniformly random key $k in K$. Generate a random plaintext $x in X$ with probability $P(x, e(x,k)=y)$]

*Comment:* In the classical One-Time-Pad one has *perfect security*. 

=== A quantum protocol for One-Time-Pad

*Idea:* Instead of classical bits, consider qubits $ x=(x_0,...,x_(k-1)) arrow.bar (ket(x_0), ..., ket(x_(k-1)))=ket(x_0 ...x_(k-1))=ket(x) $
The random generator emits the key stream $S_0...S_(k-1)$ that encodes the message in this way:
$ "If" s_i=0 &=> ket(x_i) arrow.bar ket(x_i)=II ket(x_i) \ 
"If" s_i=1 &=> ket(x_i) arrow.bar ket(x_i xor 1)= cases(ket(1) "if" x_i=0, ket(0) "if" x_i=1) = sigma_x ket(x_i)  $
Suppose that the TRNG is quantum, The state of the system made of the TRNG and the $i^(t h)$ qubit can be written as $ rho = 1/2 underbrace(ket(0)bra(0)_k times.circle ket(x_i)bra(x_i)_M, "tensor product of two" \ "density matrices" ) + 1/2 underbrace(ket(1)bra(1)_k times.circle sigma_x ket(x_i)bra(x_i)_M sigma_x, "tensor product of two" \ "density matrices" ) $ 
The first factor is related to the key stream, the second to the message

*N.B:* This is the density matrix of the encoded message and the key stream

Suppose Eve intercepts the ciphertext, she can have at her disposal nothing but the _reduced density matrix_ of the qubit of the message
$ rho_M = Tr_k (rho)&= ket(x_i)bra(x_i) + sigma_x ket(x_i)bra(x_i) sigma_x = \
&=cases(1/2 ket(0)bra(0)+1/2 ket(1)bra(1) = II /2 quad x_i =0, 1/2 ket(1)bra(1)+1/2 ket(0)bra(0) = II /2 quad x_i =1)
$ Whatever $M$ is, Eve gets the same $rho$.
Supposing that the $s_i$s are equally distributed and independent, for a k-qubit message $M$ one has: $ rho= times.circle.big_(i=1)^k [1/2 ket(0)bra(0)_k times.circle ket(x_i)bra(x_i)_M  + 1/2 ket(1)bra(1)_k times.circle sigma_x ket(x_i)bra(x_i)_M sigma_x] \ rho_M=(II/2)^(times.circle k)=II/2^k $

*A genuinely quantum One-Time-Pad protocol*

The main difference between classical and quantum communication lies in the fact that quantum theory is non-commutative

*Idea: * use both $sigma_x "and" sigma_z$ because the first flips the computational basis, while the other flips the Hadamard basis.
Consider a key stream made of two bits, $k_1,k_2$ randomly chosen in $ZZ^2$. Now recall that the transformation of the state was $ rho & arrow.bar 1/2 II rho II +1/2 sigma_x rho sigma_x quad ("with" rho=ket(x_i)bra(x_i)) \ &=1/2 sigma_x^0 rho sigma_x^0 + 1/2 sigma_x^1 rho sigma_x^1 = 1/2 sum_(k=0)^1 sigma_x^k rho sigma_x^k $

The generalization to the case of a 2-bit key stream can be written as follows $ rho arrow.bar 1/4 sum_(k_1,k_2 in {0,1}) sigma_x^(k_1)sigma_z^(k_2) rho sigma_z^(k_2)sigma_x^(k_1) $

#example[Consider the case $rho =sigma_x$
$ &1/4 (sigma_x+overbrace(sigma_z sigma_x, -sigma_x sigma_z) sigma_z + overbrace(sigma_x sigma_x, II) sigma_x + sigma_x overbrace(sigma_z sigma_x, -sigma_x sigma_z)sigma_z sigma_x) = \ &= 1/4 (sigma_x-sigma_x overbrace(sigma_z sigma_z, II) + sigma_x - overbrace(sigma_x sigma_x, II) overbrace(sigma_z sigma_z, II) sigma_x) \ &= 1/4(sigma_x -sigma_x + sigma_x -sigma_x)=0 $

The same reasoning can be applied if:
- $rho=sigma_y quad arrow quad =0$
- $rho=sigma_z quad arrow quad =0$
- $rho=II quad space arrow quad =II$]
Now every density matrix can be written as: $rho = II/2 + 1/2 (v_x sigma_x + v_y sigma_y + v_z sigma_z)$
This time all bases are effectively encoded but Eve can gain information. For a k-qubit one obtains the same result.

*One-Time-Pad protocol: *
+ The key ($k_1, k_2$) is chosen uniformly in ${0, 1}^2$
+ To encrypt, Alice applies $sigma_x^(k_1)sigma_z^(k_2)$
+ To decrypt, Bob applies the inverse $sigma_z^(k_2)sigma_x^(k_1)$


== Trivium
Is a combination of three LFSRs as shown in @triv_int. For every register the input is the XOR of two bits: 
- The first bit is the output of another register
- The second is a feedback from the same register
#figure(
  image("Images/Trivium_int_str.png", width: 70%), caption: [Trivium internal structure]
)<triv_int>

#figure(
  image("Images/Trivium_spec.png", width: 60%), caption: [Trivium specification]
)<Triv_spec>
The output of each register is the sum of three bits (specification in @Triv_spec):
+ The rightmost component of the register
+ A particular bit of the same register that feeds foreward
+ the AND operation carried out on particular bits of the same register

*N.B.:* The most important feature is the AND, which introduces a non-linearity (quadratic term)

=== Encryption with trivium 
+ Initialization value $I V$:
  - $80$-bit $I V$ into the $80$ leftmost bits of register A
  - $80$-bit $I V$ into the $80$ leftmost bits of register B
  - $3$-bit $I V$ into the $3$ rightmost bits of register C
+ Warm-up phase: Trivium is clocked $1152$ times
+ Encryption phase: from $S_1152$ on, the stream ciphers are considered and build up the key stream
