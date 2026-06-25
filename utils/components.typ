// Low-level visual primitives shared by everything else.
#import "theme.typ": *
#import "@preview/droplet:0.3.1": dropcap

// Small, tracked, uppercase label text.
#let eyebrow(it, color: accent) = text(
  font: LABEL,
  size: 8.5pt,
  weight: 600,
  fill: color,
  tracking: 0.22em,
  number-type: "lining",
)[#upper(it)]

// True drop cap for chapter openings — text wraps around a 3-line initial.
#let lettrine(body) = dropcap(
  height: 3,
  gap: 8pt,
  font: DISPLAY,
  fill: accent,
  weight: 500,
)[#body]

// The centred Playfair title + accent underline that opens every styled page
// (toc, notation, references, and the chapter opener). `top` slots optional
// content (e.g. an "Appendix A" eyebrow) above the title, inside the centring.
#let page-title(title, size: 30pt, top: none) = block(spacing: 0pt, width: 100%)[
  #align(center)[
    #v(10pt)
    #top
    #text(font: DISPLAY, size: size, fill: ink, weight: 500)[#title]
    #v(1pt)
    #box(width: 30%, line(length: 100%, stroke: 1.2pt + accent))
  ]
]

// One look for every callout: subtle tint + left accent rule + label. No
// horizontal rules — boundaries read from the fill edge and whitespace.
#let envblock(label, color, body, tint: 92%, sticky: false) = block(
  width: 100%,
  breakable: false,
  above: 1.7em,
  below: 0.7em,
  sticky: sticky,
  fill: color.lighten(tint),
  inset: (x: 15pt, y: 13pt),
  radius: 4pt,
  stroke: (left: 2.5pt + color),
)[
  #align(center, eyebrow(label, color: color.darken(12%)))
  #v(6pt)
  #set align(left)                   // title centred above, body flush left
  #set par(first-line-indent: 0pt)   // no paragraph indent inside boxes
  #body
]
