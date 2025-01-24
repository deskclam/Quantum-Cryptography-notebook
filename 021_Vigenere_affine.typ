#import "imports.typ":*

== Vigenère and affine ciphers
=== Vigenère
In the Vigenère cipher every letter is encoded according to a different permutation, according to a permutation table and the encryption key: the table is reported in @vige.

#[
  #show figure: set block(breakable: false)
  #figure(
    [
      #set text(size: 7pt)
      #let alphabet = upper("a b c d e f g h i j k l m n o p q r s t u v w x y z")
      #let alpharray = alphabet.split(" ")
      #let c = 3
      #set table(
        fill: (x, y) =>
          if (x == 0 or y == 0) and not(x==0 and y == 0) {
            gray.lighten(60%)
          } else if (calc.rem(y, 2) == 0) and not(x==0 and y == 0) {
            gray.lighten(80%)
          },
      )
      #set align(center)
      #table(
        inset: 3pt,
        align: center+horizon,
        columns: alpharray.len() + 1,
        table.header("",..for x in alpharray{([*#x*],)}),
        // table.hline(stroke: 2pt),
        ..for (i, ll) in alpharray.enumerate(){
          (
            table.cell()[*#ll*],
            // table.vline(stroke: 2pt),
          ..for (j, l) in alpharray.enumerate(){
            ([#alpharray.at(calc.rem(j + i, alpharray.len()))],)
          })
        }
      )
    ],
    caption: "Vigenère table of permutations (tabula recta)"
  )<vige>
]
#example[
  
  + *plaintext*: "_It was late evening_"
  + *key*: "_KAFKA_"
  + *message*: "_St bks vayo efessnq_"
]

=== Affine
In the affine cipher the plaintext is encrypted by mapping each letter in the correspondent numerical, the encryption is then done by using a simple mathematical expression and each number converted back in the correspondent letter.
The expression is: $ E(x)=(a x+b)mod m $
where the $x$ is the numerical correspondent of the letter of the plaintext to be encrypted and $m$ is the length of the alphabet used.
The relation for the decryption is:
$ D(x)= a^(-1)(x-b mod m) $

