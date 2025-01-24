#import "@preview/gentle-clues:1.0.0": *
#import "@preview/ctheorems:1.1.3": *
#import "@preview/physica:0.9.4": *
#import "@preview/fletcher:0.5.3" as fletcher: diagram, node, edge
#import fletcher.shapes: pill
#import "@preview/subpar:0.2.0"
#import "@preview/pinit:0.2.2": *

#let MATH_BREAK_THRESHOLD = 200pt

// #show thmbox.where()
#let theorem = thmbox(
  "theorem",
  "Theorem",
  stroke: rgb("#000000")+0.5pt,
  radius: 0pt,
  breakable: false,
).with(base_level:1)

#let br_theorem = theorem.with(breakable: true)

// #let theorem(..args) = {
//   let name = if (args.pos().len() == 2) {
//     args.at(0)
//   } else { none }
//   let content = if (args.pos().len() == 2) {
//     args.at(1)
//   } else { args.at(0) }
  
//   context {
//     let t = theo(name)[#content]
//     if (measure(t).height > MATH_BREAK_THRESHOLD){
//       return t
//     }
//     else {
//       return unbr_theo(name)[#content]
//     }
//   }
// }

#let corollary = thmplain(
  "corollary",
  "Corollary",
  base: "theorem",
  titlefmt: strong,
  breakable: false,
).with(base_level:1)

#let br_corollary = corollary.with(breakable: true)

// #let corollary(name, it) = {
//   context {
//     let t = coroll(name)[#it]
//     if (measure(t).height > MATH_BREAK_THRESHOLD){
//       t
//     }
//     else {
//       unbr_coroll(name)[#it]
//     }
//   }
// }

#let definition = thmbox(
  "definition",
  "Definition",
  inset: (x: 1.2em, top: 1em),
  breakable: false,
).with(base_level:1)

#let br_definition = definition.with(breakable: true)

#let example = thmplain(
  "example",
  "Example",
  breakable: true,
).with(numbering: none)
#let unbr_example = example.with(breakable: false)

#let proof = thmproof(
  "proof",
  "Proof",
  breakable: true,
).with()
#let unbr_proof = proof.with(breakable: false)

#let exercise = thmbox(
  "exercise",
  "Exercise",
  inset: (x: 1.2em, top: 1em),
  breakable: true,
).with(base_level:1)
#let unbr_exercise = exercise.with(breakable: false)

#let remark = thmplain(
  "remark",
  "Remark",
  breakable:true
).with(numbering: none)
#let unbr_remark = remark.with(breakable: false)

// Such That
#let st = [_s.t._]

// If and only if
#let iff = [_iff_]

#let pin_right(pin, text) = {
  let x = 2em
  let y = -0.3em
  pinit-point-from(
    pin,
    offset-dx:x,
    offset-dy:y,
    pin-dx:0.5em,
    pin-dy:y,
    body-dx:0.2em,
    body-dy:y * 3/2
  )[#text]
}

#let pin_left(pin, text) = {
  let x = 2em
  let y = -0.3em
  context {
    let w = measure(text).width
    return pinit-point-from(
      pin,
      offset-dx:-x,
      offset-dy:y,
      pin-dx:-0.5em,
      pin-dy:y,
      body-dx: - w - 0.5em,
      body-dy:y * 3/2
    )[#text]
  }
}
