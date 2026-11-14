# le_storie_di_mowgli_agesci

Queste sono le storie di Mowgli utilizzate per il percorso della branca L/C dell'Agesci.

## Prerequisiti

- [typst](https://typst.app/)

oppure typst cli:
- https://github.com/typst/typst


## Creare un pdf

Formato pagina a4:
> typst compile main_a4.typ

Formato libretto (pagina a5):
> typst compile main_a5.typ

Formato a4 orizzontale, due pagine a5 per foglio:
> typst compile main_a4_2pp.typ

Oppure, per creare tutti i formati in `target/`:
> just compile