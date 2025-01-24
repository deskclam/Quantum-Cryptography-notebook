 #import "imports.typ":*

= DES Algorithm

DES is a symmetric (i.e. the same key is used both for encryption and decryption) cipher that encrypts blocks of length of 64 bits with a key of size 56 bits.

#figure(image("Images/DES_structure.png", width:80%), caption: "DES Feistel structure")<all_all>

The $"IP"$ and the $"IP"^(-1)$ are two bitwise permutations, the $"IP"$ is the first operation performed on the plaintext, while the $"IP"^(-1)$ is the last operation being performed to obtain the ciphertext.

The way to read the tables is simply to read it cell by cell and take the bit corresponding to the current element in the cell and place in the current position. Reading IP, for example, we have to place bit 58 in the 1#super[st] position, bit 50 in the 2#super[nd] and so on.

#figure(image("Images/DES_perms.png", width:60%), caption: "DES initial and final permutations")<DES_perm>

=== The $f$ function
This function plays a crucial role for the security of DES. In the $i"-th"$ round it takes the right half of the output of the previous round and the current key $k_i$ as inputs; the result of the $f$ function is used as a XOR-mask for encrypting the $"L"_{i-1}$ part. 

#grid(columns: (2.5fr, 1fr),
rows: (auto, auto),
grid.cell(
    rowspan: 2,
    colspan: 1,
    [#figure(image("Images/DES_f_func.png", width: 75%), caption: [$f$-function block scheme])<f_block>],
  ),[#figure(
    image("Images/E_f_func_DES.png"), caption: [Expansion \ matrix],
  )],  
  [#figure(image("Images/P_f_func_DES.png"), caption: [Permutation matrix],
  )],
)

#figure(
  image("Images/DES_E_bitswaps.png", width: 50%), caption: [ Bit swaps for the Expansion function] 
)
The expansion table is to be read similarly to the IP table, noting that some of the numbers appear more than once in the table.
As a first thing the 32-bit input is expanded and the bits are permutated as shown in @f_block. Then the 48-bit result of the expansion is XORed with the key $k_i$  and the eight 6-bit blocks of the result are fed into eight _Substitution boxes_ (or *S-boxes*). Each box maps the 6-bit input into a 4-bit output and every _S-box_ is unique. The mapping is done by reading in the 6-bit input the row and the column correspondent to the position in the table of the referred _S-box_, and finding in the position the decimal number corresponding to the 4-bit output. In the example in @S_box_address, we use the first and last bit to get the index of the row (in this case $(11)_2 = 3$, which means we the the row with index 3; the same is done to get the column number using the remaining bits.


#figure(
  image("Images/DES_addr_sbox.png", width: 40%), caption: [Example of the decoding of the input $(100101)_2$ for the _S-box_]
)<S_box_address>
The matrices corresponding to the _S-boxes_ are omitted in this notebook for the sake of brevity.
The _S-boxes_ are designed following multiple criteria in order to achieve a high cryptographic strength.
The importance of the _S-boxes_ is the _non-linearity_ they introduce to the cipher:

$ S(a) xor S(b) != S(a xor b) $

The permutation _P_ in the _f_-function introduces diffusion, affecting various _S-boxes_ in the following round. The diffusion given by the permutation, the _S-boxes_ and the expansion is called *avalanche effect*.

=== Key schedule

#grid(
  columns: 2,
  grid.cell([#figure(image("Images/DES_pc1.png", width: 70%), caption: [$P C -1$ table])]),
  grid.cell([#figure(image("Images/DES_PC2.png", width: 80%), caption: [$P C -2$ table])])
)
#grid( columns: (2fr, 1fr),
grid.cell([#figure(
  image("Images/DES_keysched.png"), caption: [DES key schedule block diagram]
)<deskeysched>]),
[The key schedule in DES derives 16 round keys $k_i$, each consisting of 48 bits, from the original 56-bit key. the input key is 64-bit long, where every eighth bit is used as an odd parity bit over the preceding seven bits. Thus those parity bits are ignored, they are stripped in the initial $P C -1$ permutation. The resulting 56-bit key is halved in $C_0 "and" D_0$ and the key schedule starts as shown in @deskeysched and the two parts are cyclically shifted left ($"LS"_i$) following the rule: \ 
- In rounds $i= 1,2,9,16$ the two halves are rotated *left by one bit*.
- In the other rounds ($i != 1,2,9,16$) the two halves are rotated *left by two bits*. 

To derive each sub-key the two halves are permuted bitwise again but with the permutation $P C-2$. ]
)
=== Decryption

One of the advantages of DES is that decryption is essentially the same function as encryption: only the key schedule is reversed i.e. in decryption round 1 the subkey $k_16$ is needed. Thus in decryption the key schedule algorithm has to generate the round keys as the sequence $k_(16), k_15, ..., k_1$.

With the initial key $k$ it is possible to obtain directly $k_16$: $ k_16 &= P C -2(C_16, D_16) "but since " C_16=C_0 "and" C_16=C_0 \ &=P C -2(C_0,D_0) \ &= P C-2(P C -1(k)) $
