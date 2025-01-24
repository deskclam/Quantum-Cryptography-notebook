#import "imports.typ":*

= AES (Advanced Encryption Standard)

== Properties

+ Must support key sizes of $128, 192, 256$ bits
+ The number of rounds is related to the key size: the longer the key the more the rounds.
== Internal structure of AES
#figure(image("Images/AES_block_diagr.png", width: 95%),caption: [AES block diagram])

In the _Byte Substitution Layer_ we need the knowledge of _Galois Fields_ (@galois_fields)

AES is a _byte-wise_ algorithm, in the case of $x=128$, the 16 bytes are grouped in groups of 4 bytes.

=== Key addition layer
The inputs are the current 16-byte state matrix and a 16-bytes sub-key, they are combined through as XOR operation (XOR in the Galois fields is equivalent to the sum).

=== Key schedule
This process takes the original input key and derives the 16 sub-keys. Note that in AES the addition of a sub-key is used bot at the input and output: this is called _key whitening_. 
#grid( columns: 3, column-gutter: 3em,
figure(
  table( columns: 4, table.header($A_0$,$A_4$, $A_8$, $A_12$ ),
                $A_1$, $A_5$, $A_9$, $A_13$,
                $A_2$, $A_6$, $A_10$, $A_14$,
                $A_3$, $A_7$, $A_11$, $A_15$
    
  ), caption: [Input state \ $A$ as a matrix]
 ),
figure(
  table( columns: 4, table.header($k_0$,$k_4$, $k_8$, $k_12$ ),
                $k_1$, $k_5$, $k_9$, $k_13$,
                $k_2$, $k_6$, $k_10$, $k_14$,
                $k_3$, $k_7$, $k_11$, $k_15$
    
  ), caption: [state matrix \   of a $128$-bit key]
 ),
figure(
  table( columns: 6, table.header($k_0$,$k_4$, $k_8$, $k_12$, $k_16$, $k_20$ ),
                $k_1$, $k_5$, $k_9$, $k_13$, $k_17$, $k_21$,
                $k_2$, $k_6$, $k_10$, $k_14$, $k_18$, $k_22$,
                $k_3$, $k_7$, $k_11$, $k_15$, $k_19$, $k_23$,
    
  ), caption: [state matrix \   of a $192$-bit key]
 )


)


=== Byte substitution layer <Byte_sub_layer>
Every byte undergoes the transformation _S_, which is done by 16 _S-boxes_. In contrast to DES, these _S-boxes _ are all identical. In the layer each byte state $A_i$ is substituted with another byte $B_i$. The _S-boxes_ are the only non-linear element of AES, the substitution is a bijective mapping, which allows to uniquely reverse the _S-box_ for decryption. 

#figure(image("Images/AES_round.png", width: 100%),caption: [AES round block scheme])<round>

\

#grid(columns: (1fr, 0.7fr),
rows: (auto,auto),
column-gutter: 2em,
grid.cell(
  [#figure(image("Images/inverse-table_GF2^8.png", width: 100%),caption: [Multiplicative inverse table in $G F(2^8)$ used in AES S-box ])<lookup_inverrse>] ),

  grid.cell(rowspan: 2, [The _S-boxes_ can be seen as a two-step mathematical transformation, the first one is a _Galois field inversion_ (see @gf_inversion). For each $A_i$ the inverse is computed, obtaining the byte $B'_i $, with the fixed irreducible polynomial $P(x)=x^8+x^4+x^3+x+1$. A lookup table for all the inverse is reported in  @lookup_inverrse. The inverse of zero is not defined, but in AES $A_i=0$ is mapped to itself.
 ]),

)
In the second part of the substitution each byte undergoes an _affine mapping_, described by: $ vec(b_0,b_1,b_2,b_3,b_4,b_5,b_6,b_7) equiv mat(1,0,0,0,1,1,1,1;
    1,1,0,0,0,1,1,1;
    1,1,1,0,0,0,1,1;
    1,1,1,1,0,0,0,1;
    1,1,1,1,1,0,0,0;
    0,1,1,1,1,1,0,0;
    0,0,1,1,1,1,1,0;
    0,0,0,1,1,1,1,1;)
    vec(b'_0,b'_1,b'_2,b'_3,b'_4,b'_5,b'_6,b'_7) +
    vec(1,1,0,0,0,1,1,0)mod 2
$

#example[Assume the input $A_i = (C 2)_("hex")=(1100 space 0010)_2$

From the table in @lookup_inverrse we can see that the inverse is $ A_i ^(-1) =B'_i=(2F)_("hex")=(0010 space 1111)_2 $ We now apply the affine transformation to $B'_i$ $ B_i=(0010 space 0101)_2=(25)_("hex") $]

=== Diffusion layer
This layer consists of two sublayers: the _ShiftRows_ transformation and the _MixColumn_ transformation, these perform a linear operation.

*_ShiftRows_*

The state matrix is shifted as reported below, following the rules:
- The first row is left untouched
- The second row is shifted right of three positions
- The third row is shifted right of two positions
- The fourth row is shifted right of one position

#grid(
 columns: (1fr, 3fr),
figure(table(columns: 4, align: horizon, table.header([$B_0$], [$B_4$],[$B_8$],[$B_12$]),
[$B_1$],[$B_5$],[$B_9$],[$B_13$],
[$B_2$],[$B_6$],[$B_10$],[$B_14$],
[$B_3$],[$B_7$],[$B_11$],[$B_15$],
),caption: [Input state]),
figure(table(columns: 4, align: horizon, table.header(
[$B_0$], [$B_4$],[$B_8$],[$B_12$ #pin(20)]),
[$B_5$],[$B_9$],[$B_13$],[$B_1 space$ #pin(21)],
[$B_10$],[$B_14$],[$B_2$],[$B_6 space$ #pin(22)],
[$B_15$],[$B_3$],[$B_7$],[$B_11$ #pin(23)],
),caption: [Output state]) )

#pin_right(20, "No shift")
#pin_right(21, "One position shift left")
#pin_right(22, "Two positions shift left")
#pin_right(23,"Three positions shift left")
 
*_MixColumns_*

This linear transformation mixes each column of the state matrix. This is a major diffusion element in AES. The transformation takes as input the state $B$ after the _ShiftRows_.

$ "MixColumn"(B)=C $
Each 4-byte column is considered as a vector and multiplied by a fixed $4 times 4$ matrix. The multiplication and addition of coefficients is done in $G F(2^8)$

#example[Calculation of the first four output bytes
$ vec(C_0,C_1,C_2,C_3) =
mat(02,03,01,01;
    01,02,03,01;
    01,01,02,03;
    03,01,01,02;)  vec(B_0,B_5,B_10,B_15) $
]
The other columns of bytes are computed by multiplying the correspondent column of the input state by the same matrix

#example[Calculation of the coefficient $C_0$ for the first column.

Assuming that the input state to the _MixColumn_ layer is $B=(25,25,...,25)$

since the input column has only the value $(25)_("hex")$ only two multiplication have to be computed: $02 dot 25 "and" 03 dot 25$. They can be computed in polynomial notation. Notice that $(25)_"hex" = 2^5 + 2^2 + 2^0$.
$ 02 dot 25 &= x dot (x^5 +x^2 +1) \ &=x^6 +x^3 +x, \

03 dot 25 &= (x+1)dot(x^5+x^2+1) \ &= (x^6 +x^3 +x) +(x^5+x^2+1) \ &= x^6 + x^5 +x^3 +x^2 +x+1 $

Since both have a degree smaller than 8, no modular reduction with $P(x)$ is necessary.

The output bytes of $C$ result from the following addition in $G F (2^8)$:

$ 01 dot 25 &= &&      &&x^5+ &&     &&x^2+ &&   &&1 \
  01 dot 25 &= &&      &&x^5+ &&     &&x^2+ &&   &&1 \
  02 dot 25 &= &&x^6+  &&     &&x^3+ &&     && x+ && 0\
  03 dot 25 &= &&x^6+  &&x^5+ &&x^3+ &&x^2+ &&x+ && 1\
 & &&&&&&&&&&&&#line(start: (-43%, 0pt), end: (3%, 0pt)) \
 C_0 &= &&      &&x^5+ &&     &&x^2+ &&   &&1 \
  $
  Which corresponds to $(25)_("hex")$. 
  Since the input state as stated before presents only the hexadecimal byte $25$, the output state will be C=(25,25,...,25).

]
=== Key addition layer
The two inputs to this layer are the current 16-byte state matrix and a sub-key of 16 bytes. The two are combined in a XOR operation, which in the _Galois Field_ $G F(2^8)$ is equal to addition.

=== Key schedule
This step takes the original input key and derives the sub-keys, as in @keyschedule. The number of keys is equal to the number of rounds plus one (due to the key whitening). The AES key schedule is word oriented ($1 "word" = 32 "bits"$). 
 
  
  #example[First round of the key schedule with $K_(0,..., 15)= (F F)_("hex")$.

The first word $W_0= (F F, F F, F F, F F)$ is XORed with $g(W_3)$.

The _g_-box, as shown in @keyschedule on the right, takes the input word and shifts its bytes, then each byte enters in a _S-box_.
In our case the bytes are all the same and this transformation gives (see @lookup_inverrse):
$ S(F F)=  (16)_("hex") $ 

 #figure( placement: top,
    image("Images/AES_key schedule.png", width: 100%), caption: [AES key schedule for 128-bit key]
  )<keyschedule>

Then the output of the first _S-box_ is XORed with $R C[i]$, in this case $R C[1]$.
The _round coefficients_ $R C$ vary from round to round according to the following rule (computed in $G F(2^8)$, with the same irreducible polynomial, see @Byte_sub_layer): 
$ R C[1]&= x^0 = (00000001)_2 \ 
  R C[2]&= x^1 = (00000010)_2 \
  & #h(0.3em) dots.v \
  R C[10]&= x^9 = (00110110)_2 \
  
$
 So $(00010110) xor (00000001) = (00010111) = (17)_("hex") $. The output bytes of the _g_-box will be $(17, 16, 16, 16)_("hex")$.

$K_1$ will then be, after all the XORing, with the bytes in hexadecimal notation:
 
 #table(
   columns: 16,
   table.header("E8", "E9","E9","E9",
                "17","16","16","16",
                "E8", "E9","E9","E9",
                "17","16","16","16")
 )
 Since $"FF" xor 16 = "E9" $ and $"FF" xor 17 = "E8"$
]
== Decryption 
For what concerns the decryption, all the layers must be inverted and the order of the sub-keys is reversed, i.e. we need a reversed key schedule.

#figure(
  image("Images/aes_decr.png", width: 100%),
)

=== Inverse MixColumn Sublayer
// #example[Calculation of the first four output bytes
$ vec(B_0,B_1,B_2,B_3) =
mat(0E,0B,0D,09;
    09,0E,0B,0D;
    0D,09,0E,0B;
    0B,0D,09,0E;)  vec(C_0,C_1,C_2,C_3) $
  The other columns are computed the same way by multiplying by this matrix. Also here all the elements $in G F(2^m)$ and the values in the matrix are in hexadecimal notation.
=== Inverse ShiftRows Sublayer

// Usually the _S-box_ is realized as a lookup table, as given in @lookup.
// #example[ Assume the input byte to the _S-box_ is $A_i=(C 2)_("hex")$. Then, the substituted value, by looking at the table in @lookup is: $ S((C 2)_("hex")=(25)_("hex")) $]
#grid(
 columns: (1fr, 3fr),
figure(table(columns: 4, align: horizon, table.header([$B_0$], [$B_4$],[$B_8$],[$B_12$]),
[$B_1$],[$B_5$],[$B_9$],[$B_13$],
[$B_2$],[$B_6$],[$B_10$],[$B_14$],
[$B_3$],[$B_7$],[$B_11$],[$B_15$],
),caption: [Input state]),
figure(table(columns: 4, align: horizon, table.header(
[$B_0$], [$B_4$],[$B_8$],[$B_12$ #pin(200)]),
[$B_13$],[$B_1$],[$B_5$],[$B_9 space$ #pin(210)],
[$B_10$],[$B_14$],[$B_2$],[$B_6 space$ #pin(220)],
[$B_7$],[$B_11$],[$B_15$],[$B_3$ #pin(230)],
),caption: [Output state]) )

#pin_right(200, "No shift")
#pin_right(210, "One position shift right")
#pin_right(220, "Two positions shift right")
#pin_right(230,"Three positions shift right")
=== Inverse byte substitution layer

#figure(
  image("Images/AES_Inverse_sbox.png", width: 60%), caption: [Inverse AES S-box]
)

*WARNING:* The substitution values in the table are the substitution values in AES, comprehensive of the $G F (2^8)$ inverse and the affine mapping! The inverse affine mapping is still reported below for completeness.

 $
 vec(b'_0,b'_1,b'_2,b'_3,b'_4,b'_5,b'_6,b'_7) equiv
mat(0,1,0,1,0,0,1,0;
    0,0,1,0,1,0,0,1;
    1,0,0,1,0,1,0,0;
    0,1,0,0,1,0,1,0;
    0,0,1,0,0,1,0,1;
    1,0,0,1,0,0,1,0;
    0,1,0,0,1,0,0,1;
    1,0,1,0,0,1,0,0;)
    vec(b_0,b_1,b_2,b_3,b_4,b_5,b_6,b_7) +
    vec(0,0,0,0, 0,1,0,1)mod 2
$
=== Decryption key schedule 
Since the first decryption round requires the last subkey, the second round requires the second-to-last subkey and so on we need the reversed key schedule, which in practice translates to compute and store all the subkeys and use them as needed.