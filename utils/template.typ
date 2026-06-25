// The interior template: page setup, fonts, heading/figure/code styling, and
// the per-chapter counter resets. Apply once, after the cover: `#show: book`.
#import "theme.typ": *
#import "components.typ": *

#let book(body) = {
  set page(
    paper: "a4",
    fill: paper,
    margin: (x: 1.5cm, top: 2cm, bottom: 1.75cm),
    footer: context {
      set align(center)
      text(font: BODY, size: 10pt, fill: muted)[#counter(page).display()]
    },
    header: context {
      let loc = here()
      let openers = query(heading.where(level: 1)).filter(h => h.location().page() == loc.page())
      if openers.len() > 0 { return } // clean chapter-opener pages
      let prev = query(heading.where(level: 1).before(loc))
      if prev.len() == 0 { return }
      set align(center)
      set text(font: LABEL, size: 8pt, fill: muted, tracking: 0.18em)
      smallcaps(prev.last().body)
      v(3pt)
      line(length: 100%, stroke: 0.4pt + rule)
    },
  )

  set math.vec(delim: "[")
  set math.mat(delim: "[")

  // Body type — true book setting: indented paragraphs, old-style figures.
  set text(font: BODY, size: 12pt, fill: ink, lang: "en", number-type: "old-style", hyphenate: true)
  set par(
    justify: true,
    leading: 0.85em,
    spacing: 0.6em,
    first-line-indent: (amount: 1.4em, all: false),
  )
  set list(marker: text(fill: accent)[-], indent: 4pt)
  set enum(numbering: n => text(fill: accent, font: LABEL, size: 9.5pt)[#n.])

  // Theorem/exercise figures are pure cross-reference targets — render only
  // their styled block, with none of the usual figure chrome.
  show figure.where(kind: "thmenv"): it => it.body
  show figure.where(kind: "exenv"): it => it.body

  // Headings — chapters open a new page with a numbered eyebrow.
  set heading(numbering: none)
  // Structural markers (parts, appendix, notation, references) are hidden
  // headings at levels 5/6: they exist only to surface those pages in the TOC
  // and PDF bookmarks, so they render no body of their own.
  show heading.where(level: 5): none
  show heading.where(level: 6): none
  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    chapter-no.step()
    // Reset every per-chapter figure counter so all read <chapter>.<n>.
    counter(figure.where(kind: "thmenv")).update(0)
    counter(figure.where(kind: "exenv")).update(0)
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    v(0.4cm)
    page-title(it.body, top: context if appendix-state.get() [
      #eyebrow[Appendix #numbering("A", chapter-no.get().first())]
      #v(8pt)
    ])
    v(45pt)
  }
  show heading.where(level: 2): it => block(above: 2em, below: 0.85em)[
    #text(font: DISPLAY, size: 16pt, fill: accent, weight: 500)[#it.body]
  ]
  show heading.where(level: 3): it => block(above: 1.5em, below: 0.6em)[
    #text(font: BODY, size: 12.5pt, fill: ink, style: "italic", weight: 500)[#it.body]
  ]

  // Image/table figures — numbered <chapter>.<n>, matching the theorem blocks.
  // (thmenv/exenv figures override this with their own captured numbering.)
  set figure(numbering: (..n) => env-number(n.pos().last()))

  // Tables — quiet, booktabs-leaning baseline (see `ntable` for the full look).
  set table(stroke: 0.5pt + rule, inset: (x: 10pt, y: 7pt), align: left + horizon)
  show table: set text(font: BODY, size: 10.5pt, number-type: "old-style")
  // Breathing room around tables (bare tables and the `ntable` figure alike).
  show table: set block(above: 2.8em, below: 2.8em)
  show figure.where(kind: table): set block(above: 2.8em, below: 2.8em)

  // Code — gruvbox light. Path is relative to this file (utils/), so step up
  // to the project-root `themes/` folder.
  set raw(theme: "../themes/gruvbox-light.tmTheme")
  show raw.where(block: false): set text(font: CODE, size: 9.5pt, fill: accent.darken(8%))
  show raw.where(block: true): it => block(
    width: 100%,
    fill: rgb("#FBF1C7"),
    inset: 12pt,
    radius: 3pt,
    stroke: 0.5pt + rgb("#E6D5A8"),
    above: 1.5em,
    below: 1.5em,
  )[
    #set text(font: CODE, size: 9.5pt)
    #it
  ]

  show emph: set text(fill: ink)
  show strong: set text(fill: accent)
  show link: set text(fill: accent)
  show cite: set text(fill: accent)

  // Elegant block quote.
  set quote(block: true)
  show quote: it => block(above: 1.4em, below: 1.4em, inset: (left: 14pt), stroke: (left: 2pt + gold))[
    #set text(style: "italic", fill: muted)
    #it
  ]

  show figure.caption: set text(size: 9.5pt, fill: muted, style: "italic")

  set math.equation(numbering: "(1)")
  show math.equation.where(block: true): set block(above: 1.2em, below: 1.2em)

  counter(page).update(1)
  body
}
