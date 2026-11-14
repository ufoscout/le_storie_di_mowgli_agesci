// The book printed two A5 pages per sheet, side by side on landscape A4 sheets.
//
// Typst cannot put two pages on one sheet, so each sheet has two columns, each laid out as an A5 page. Typst only
// counts the sheets, so the A5 page numbers, in the footer and in the outline, and the headers are worked out here
// from where things are on the sheet.

#let half = 297mm / 2
#let a5-margin = 2.5 / 21 * 148mm // Typst's default margin for an A5 page, around each half of the sheet

// The A5 page number of a location: the left half of a sheet is one page, the right half the next one.
#let a5-page(location) = {
  let position = location.position()
  2 * position.page - if position.x < half { 1 } else { 0 }
}

// Each chapter starts on a new A5 page, that is a new column. Typst leaves the location of the heading before the
// column break, at the bottom of the previous column, so a marker after the break records where the chapter starts.
#show heading.where(level: 1): it => {
  colbreak(weak: true)
  [#metadata(it.location()) <chapter-start>]
  it
}
#show heading: set block(below: 1.2em, above: 2em)
// #set heading(numbering: "1.")

// The A5 page a heading is on.
#let heading-page(heading) = {
  let start = query(<chapter-start>).find(marker => marker.value == heading.location())
  a5-page(if start == none { heading.location() } else { start.location() })
}

// Global Style
#set page(paper: "a4", flipped: true, columns: 2, margin: (x: a5-margin, y: a5-margin))
#set columns(gutter: 2 * a5-margin)

#set text(
  // font: "New Computer Modern",
  size: 0.92em,
  lang: "it",
)

#set par(
  justify: true,
)

// The first sheet: the cover on the left half, the first page on the right one. The cover is not included from
// 0_0_cover.typ, which makes a whole page (the whole sheet here) of it: it is the same image, covering the left half
// of the sheet, margins included.
#place(top + left, dx: -a5-margin, dy: -a5-margin, image("immagini/Cover.png", width: half, height: 210mm))
#colbreak()
#include "./capitoli/0_1_prima_pagina.typ"

// Outline, with the A5 page numbers
#show outline.entry: it => link(it.element.location(), it.indented(it.prefix(), {
  it.body()
  [ ]
  box(width: 1fr, it.fill)
  [ ]
  sym.wj
  context str(heading-page(it.element))
}))
#show outline.entry.where(
  level: 1
): it => {
  v(12pt, weak: true)
  strong(it)
}
#outline(indent: auto, title: "Indice")

// The title of the chapter an A5 page is in, like hydra(1) in main_a5.typ: none on the page where a chapter starts.
#let chapter-title(page) = {
  let chapters = query(heading.where(level: 1, outlined: true)).map(chapter => (
    page: heading-page(chapter),
    title: chapter.body,
  ))
  let previous = chapters.filter(chapter => chapter.page < page)
  if previous.len() > 0 and chapters.all(chapter => chapter.page != page) {
    emph(previous.last().title)
  }
}

// The header or the footer of the two A5 pages of a sheet, each one on its half. Nothing on the blank right half of
// the last sheet, when the book ends on the left one.
#let halves(content-of) = context {
  let first = 2 * here().page() - 1
  let last = a5-page(query(<end>).first().location())
  grid(
    columns: (1fr, 1fr),
    column-gutter: 2 * a5-margin,
    ..(first, first + 1).map(page => if page <= last { content-of(page) }),
  )
}

// Header: the chapter title, on the right of the odd pages and on the left of the even ones, as in main_a5.typ.
// Footer: the page number.
#set page(
  margin: (x: a5-margin, y: 8em),
  header: halves(page => align(if calc.odd(page) { right } else { left }, chapter-title(page))),
  footer: halves(page => align(center, str(page))),
)

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

#metadata("end of the book") <end>
