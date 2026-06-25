// Theorem-like blocks, callouts, proofs, and exercises.
#import "theme.typ": *
#import "components.typ": *

// Every numbered environment shares this shape: a `figure` (so it can be
// cross-referenced via a trailing `<label>`) whose numbering closure captures
// the <chapter>.<n> at creation time, wrapping a styled `envblock`. The
// theorem family and `example` use kind "thmenv" (one shared counter);
// `exercise` uses "exenv" so it numbers independently.
#let numbered-env(name, color, body, title: none, kind: "thmenv", sticky: false, tint: 92%) = figure(
  kind: kind,
  supplement: name,
  numbering: (..n) => env-number(n.pos().last()),
  caption: none,
  // `context` only reads the figure's own number for display; the `figure`
  // stays the top-level element so a trailing `<label>` attaches to it.
  context envblock(
    [#name #env-number(counter(figure.where(kind: kind)).get().last())]
      + (if title != none { [ · #title] } else { [] }),
    color,
    body,
    sticky: sticky,
    tint: tint,
  ),
)

// Theorem family — numbered <chapter>.<n>, sharing the "thmenv" counter.
//   #theorem(title: "Chernoff")[ .. ] <thm-chernoff>   ... by @thm-chernoff
#let definition(body, title: none) = numbered-env("Definition", accent, body, title: title)
#let theorem(body, title: none) = numbered-env("Theorem", ink, body, title: title, sticky: true)
#let proposition(body, title: none) = numbered-env("Proposition", ink, body, title: title, sticky: true)
#let lemma(body, title: none) = numbered-env("Lemma", ink, body, title: title, sticky: true)
#let corollary(body, title: none) = numbered-env("Corollary", gold, body, title: title, sticky: true)
#let claim(body, title: none) = numbered-env("Claim", gold, body, title: title, sticky: true)
#let example(body, title: none) = numbered-env("Example", gold, body, title: title)

// Exercises — own counter ("exenv"), so they number and reference independently.
#let exercise(body, title: none) = numbered-env("Exercise", muted, body, title: title, kind: "exenv", tint: 86%)

// Unnumbered callouts.
#let remark(body) = envblock("Remark", accent, body)
#let note(body) = envblock("Note", ink, body)
#let warning(body) = envblock("Warning", warn, body)
#let tip(body) = envblock("Tip", success, body)
#let important(body) = envblock("Important", accent, body, tint: 88%)

// Proof — hangs off the statement above via a tight gap + continuing left rule.
// `of:` accepts free content or a label: `#proof(of: <thm-x>)` renders
// "Proof of Theorem 1.2." with a live cross-reference.
#let proof(body, of: none, color: ink) = block(
  width: 100%,
  above: 0.7em,
  below: 1.7em,
  inset: (left: 15pt),
  stroke: (left: 1.5pt + color.lighten(20%)),
)[
  #set par(first-line-indent: 0pt)
  #emph[Proof#(if of != none [ of #(if type(of) == label { ref(of) } else { of })]).]#h(0.5em)#body#h(1fr)#text(fill: accent, style: "italic")[ggez]#h(
    0.3em,
  )#emoji.crocodile
]
