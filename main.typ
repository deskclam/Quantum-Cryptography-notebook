#import "@preview/ilm:1.4.0": *
#import "imports.typ":*
#import "@preview/cades:0.3.0": qr-code

#show: thmrules.with(qed-symbol: $square$)
// #set page(margin: (inside: 2.5cm, outside: 2cm, y: 1.75cm))

#set text(lang: "en")
#show link: set text(fill: blue.darken(40%))
#show: ilm.with(
  title: [
    #set align(left)
    Quantum Cryptography notebook \ \
  ],
  author: "Eva Ricci, Giacomo Bertelli",
  date: datetime.today(),
  abstract: [
    #set align(left)
    \ \
    Politecnico di Torino, \ Master Degree in Quantum Engineering
    \ \
  ],
  preface: [
    #align(center + horizon)[
      These notes are based on the lectures of \ Quantum Cryptography by Professor Adami but they have not\ been revised by the teacher and may thus contain \ mistakes. \ If you find any please let us know.

      If you found these notes useful, you can offer us a coffee at the link below:

      
      #qr-code("https://paypal.me/deskclam?country.x=IT&locale.x=it_IT", width: 4cm)

      #rect(
        stroke: luma(80%),
        radius: 5pt,
      )[
        #link("https://paypal.me/deskclam")
      ]
    ]
  ],
  // bibliography: bibliography("refs.bib"),
  figure-index: (enabled: false),
  table-index: (enabled: false),
  listing-index: (enabled: false),
  chapter-pagebreak: true
  
)
// Set equation numbering to reset at the beginning of each chapter

#set math.equation(numbering: (..nums) => {
  let section = counter(heading).get().first()
  numbering("(1.1)", section, ..nums)
})

#show heading.where(level: 1): it => {
  counter(math.equation).update(0)
  it
}


// Remove numbers from "smaller" headers
#set heading(numbering: (..ns) => {
  let ns = ns.pos()
  if ns.len() >3 {
    return ""
  }
  return numbering("1.", ..ns)
})

// Add page number to the references
#show ref: it => {
  set text(fill: blue.darken(40%))
  let l = it.target // label
  let he = it.element // heading
  let pag = he.location().page()
  if here().position().page == pag {
   it 
  }
  else{
    [#it \[p. #counter(page).at(l).first()\]]
  }
}
#set page(numbering: "1")


#counter(page).update(1) 

#include "01_Intro&cesar.typ"
#include "02_Modular algebra.typ"
#include "021_Vigenere_affine.typ"
#include "03_Equivalence classes.typ"
#include "04_random_number_generators.typ"
#include "05_stream_cyphers.typ"
#include "06_one_time_pad.typ"
#include "07_Block_cypher.typ"
#include "08_DES.typ"
#include "081_GaloisF.typ"
#include "09_AES.typ"
#include "11_RSA.typ"
#include "12_DH.typ"
#include "13_elliptic_curves.typ"
#include "14_ecc.typ"
#include "15_bb84.typ"
#include "16_Q_error_correction.typ"
#include "17_Shor.typ"
#include "helper.typ"
