// Front-matter pages and styled content blocks: cover, toc, notation,
// references, part dividers, the appendix switch, and booktabs tables.
#import "theme.typ": *
#import "components.typ": *

// Booktabs-style table: top rule, a hairline under the header, bottom rule, no
// verticals; header in the label face. Wrapped in a numbered, referenceable
// `figure` (#ntable(..) <tab-x>).
//   #ntable(columns: 3, header: ([A], [B], [C]), caption: [..], ..cells)
#let ntable(columns: auto, header: none, caption: none, ..cells) = figure(
  caption: caption,
  table(
    columns: columns,
    stroke: none,
    inset: (x: 11pt, y: 8pt),
    align: left + horizon,
    table.hline(stroke: 0.9pt + ink),
    ..if header != none {
      (
        ..header.map(h => table.cell(
          text(font: LABEL, size: 9pt, fill: ink, weight: 600, tracking: 0.03em)[#h],
        )),
        table.hline(stroke: 0.6pt + rule),
      )
    },
    ..cells,
    table.hline(stroke: 0.9pt + ink),
  ),
)

// Notation / symbol glossary — a two-column reference, symbol then meaning.
// Place at the front (after `#toc()`).
//   #notation(($bb(E)[dot]$, [expectation]), ($Pr[dot]$, [probability]))
#let notation(..entries, title: [Notation]) = {
  pagebreak(weak: true)
  // Hidden marker so the page shows up in the TOC (see `book`, level-6 headings).
  heading(level: 6, outlined: true, bookmarked: true)[#title]
  page-title(title)
  v(36pt)
  table(
    columns: (auto, 1fr),
    stroke: none,
    inset: (x: 8pt, y: 8pt),
    align: (right + horizon, left + horizon),
    ..entries
      .pos()
      .map(((sym, meaning)) => (
        text(font: CODE, fill: accent)[#sym],
        text(font: BODY, fill: ink)[#meaning],
      ))
      .flatten(),
  )
}

// Styled table of contents echoing the chapter-opener look: chapters in display
// type, sections indented and muted with a dotted leader, folios in old-style
// figures. Place after `#show: book`.
#let toc(title: [Table of Contents]) = {
  pagebreak(weak: true)
  page-title(title)
  v(40pt)

  // Chapters — prominent, clean whitespace, no dot leaders.
  show outline.entry.where(level: 1): it => link(
    it.element.location(),
    block(above: 18pt, below: 0pt, width: 100%)[
      #text(font: DISPLAY, size: 14pt, fill: ink, weight: 500)[#it.body()]
      #box(width: 1fr)
      #text(font: BODY, size: 11pt, fill: muted, number-type: "old-style")[#it.page()]
    ],
  )

  // Sections — indented, muted, subtle dotted leader.
  show outline.entry.where(level: 2): it => link(
    it.element.location(),
    block(above: 6pt, below: 0pt, width: 100%, inset: (left: 18pt))[
      #set text(font: BODY, size: 11pt, fill: ink.lighten(10%))
      #it.body()
      #box(width: 1fr, inset: (x: 6pt), repeat(gap: 4pt, justify: true)[#text(fill: rule)[.]])
      #text(size: 10.5pt, fill: muted, number-type: "old-style")[#it.page()]
    ],
  )

  // Subsections (level 3) and deeper real headings stay out of the contents.
  show outline.entry.where(level: 3): none
  show outline.entry.where(level: 4): none

  // Part & appendix dividers (hidden level-5 markers) — a tracked accent label.
  show outline.entry.where(level: 5): it => link(
    it.element.location(),
    block(above: 26pt, below: 4pt, width: 100%)[
      #text(font: LABEL, size: 10pt, weight: 600, fill: accent, tracking: 0.16em)[#upper(it.body())]
      #box(width: 1fr)
      #text(font: BODY, size: 11pt, fill: muted, number-type: "old-style")[#it.page()]
    ],
  )

  // Front/back-matter pages (notation, references — hidden level-6 markers) —
  // styled like chapters so they sit at the top level of the contents.
  show outline.entry.where(level: 6): it => link(
    it.element.location(),
    block(above: 18pt, below: 0pt, width: 100%)[
      #text(font: DISPLAY, size: 14pt, fill: ink, weight: 500)[#it.body()]
      #box(width: 1fr)
      #text(font: BODY, size: 11pt, fill: muted, number-type: "old-style")[#it.page()]
    ],
  )

  outline(title: none, depth: 6)
}

// Full-page part divider grouping chapters. Does not touch chapter numbering.
//   #part[Foundations]
#let part(title) = {
  part-no.step()
  context page(fill: paper, margin: 0pt, header: none, footer: none)[
    // Hidden marker so the part shows up in the TOC (see `book`, level-5 headings).
    #heading(level: 5, outlined: true, bookmarked: true)[Part #numbering("I", part-no.get().first()) — #title]
    #align(center + horizon)[
      #eyebrow[Part #numbering("I", part-no.get().first())]
      #v(18pt)
      #text(font: DISPLAY, size: 44pt, fill: ink, weight: 500)[#title]
      #v(1pt)
      #box(width: 22%, line(length: 100%, stroke: 1.2pt + accent))
    ]
  ]
}

// Switch to appendix mode: subsequent chapters number as letters ("Appendix A")
// and their theorems/exercises as "A.1". Call once, after the main chapters.
#let appendix(title: [Appendix]) = {
  appendix-state.update(true)
  chapter-no.update(0)
  // Settle onto the first appendix page, then drop a hidden divider marker so
  // the appendix shows up in the TOC (see `book`, level-5 headings). The weak
  // break collapses into the following chapter's own opener break.
  pagebreak(weak: true)
  heading(level: 5, outlined: true, bookmarked: true)[#title]
}

// Full-page title page. All arguments optional; `kind` and `date` have sensible
// defaults.
#let cover(
  title: [Title],
  subtitle: none,
  term: none,
  instructor: none,
  author: none,
  institution: none,
  kind: [Lecture Notes],
  date: datetime.today(),
) = page(
  fill: paper,
  margin: 0pt,
  header: none,
  footer: none,
)[
  #pad(1.5cm)[
    #block(width: 100%, height: 100%, stroke: 0.6pt + rule, inset: (x: 1.7cm, y: 1.6cm))[
      #grid(
        rows: (auto, 1fr, auto),
        row-gutter: 0pt,

        // — top band —
        [
          #grid(
            columns: (1fr, auto),
            column-gutter: 1cm,
            eyebrow(if institution != none { institution } else { "" }, color: muted), eyebrow(kind, color: muted),
          )
          #v(9pt)
          #line(length: 100%, stroke: 0.6pt + rule)
        ],

        // — title block, optically centred —
        align(left + horizon)[
          #if term != none [ #eyebrow(term) #v(16pt) ]
          #text(font: DISPLAY, size: 47pt, fill: ink, weight: 500)[#title]
          #if subtitle != none [
            #v(14pt)
            #text(font: BODY, size: 15pt, fill: muted, style: "italic")[#subtitle]
          ]
          #if instructor != none [
            #v(22pt)
            #text(font: BODY, size: 11.5pt, fill: ink.lighten(12%), style: "italic")[
              Taught by #instructor
            ]
          ]
        ],

        // — bottom meta —
        [
          #grid(
            columns: (1fr, auto),
            align: (left, right),
            text(font: LABEL, size: 9pt, fill: ink, tracking: 0.14em)[
              #upper(if author != none { author } else { "" })
            ],
            text(font: BODY, size: 10.5pt, fill: muted, number-type: "old-style")[
              #date.display("[month repr:long] [year]")
            ],
          )
        ],
      )
    ]
  ]
]
