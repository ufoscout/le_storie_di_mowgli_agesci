#show heading.where(level: 1): it => { pagebreak(weak: true); it }
#show heading: set block(below: 1.2em, above: 2em)
// #set heading(numbering: "1.")

// Global Style
#set page(paper: "a5")

#set text(
  // font: "New Computer Modern",
  size: 0.92em,
)

#set par(
  justify: true,
)

#include "./capitoli/cover.typ"
#pagebreak()
#pagebreak()
#include "./capitoli/prima_pagina.typ"
#pagebreak()
#pagebreak()

// Outline
#show outline.entry.where(
  level: 1
): it => {
  v(12pt, weak: true)
  strong(it)
}
#outline(indent: auto, title: "Indice")

// Header: Add heading
#import "@preview/hydra:0.6.2": hydra
#set page(margin: (y: 8em), numbering: "1", header: context {
  if calc.odd(here().page()) {
    align(right, emph(hydra(1)))
  } else {
    align(left, emph(hydra(1)))
  }
})

// Footer: Enables page numbering
#set page(numbering: "1")  

#include "./capitoli/i_fratelli_di_mowgli.typ"
#include "./capitoli/la_caccia_di_kaa.typ"
#include "./capitoli/come_venne_la_paura.typ"
#include "./capitoli/il_fiore_rosso.typ"
#include "./capitoli/la_tigre_la_tigre.typ"
#include "./capitoli/l_invasione_della_giungla.typ"
#include "./capitoli/l_ankus_del_re.typ"
#include "./capitoli/i_cani_rossi.typ"
#include "./capitoli/la_corsa_di_primavera.typ"
#include "./capitoli/appendice.typ"
