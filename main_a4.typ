#show heading.where(level: 1): it => { pagebreak(weak: true); it }
#show heading: set block(below: 1.2em, above: 2em)
// #set heading(numbering: "1.")

// Global Style
#set page(paper: "a4")

#set text(
  // font: "New Computer Modern",
  size: 1.1em,
  lang: "it",
)

#set par(
  justify: true,
)

#include "./capitoli/0_0_cover.typ"
#pagebreak()
#pagebreak()
#include "./capitoli/0_1_prima_pagina.typ"
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
  align(right, emph(hydra(1)))
})

// Footer: Enables page numbering
#set page(numbering: "1")  

#include "./capitoli/1_0_i_fratelli_di_mowgli.typ"
#include "./capitoli/1_1_la_caccia_di_kaa.typ"
#include "./capitoli/1_2_come_venne_la_paura.typ"
#include "./capitoli/1_3_il_fiore_rosso.typ"
#include "./capitoli/1_4_la_tigre_la_tigre.typ"
#include "./capitoli/1_5_l_invasione_della_giungla.typ"
#include "./capitoli/1_6_l_ankus_del_re.typ"
#include "./capitoli/1_7_i_cani_rossi.typ"
#include "./capitoli/1_8_la_corsa_di_primavera.typ"
#include "./capitoli/2_0_appendice.typ"
