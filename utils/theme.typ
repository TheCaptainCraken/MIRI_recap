// Palette, fonts, and the shared chapter/appendix numbering machinery.

// ---- Palette ---------------------------------------------------------
#let paper = rgb("#FBF7EE")  // warm ivory
#let ink = rgb("#221F1A")  // espresso near-black
#let accent = rgb("#B14A2C")  // sienna
#let gold = rgb("#B5852F")  // warm ochre (secondary)
#let muted = rgb("#9A8B76")  // taupe — captions, folios
#let rule = rgb("#E3D9C7")  // warm hairline
#let warn = rgb("#A33A26")  // deep rust — warnings
#let success = rgb("#5C6E3C")  // muted olive — tips

// ---- Fonts -----------------------------------------------------------
#let DISPLAY = "Playfair Display"
#let BODY = "EB Garamond"
#let LABEL = "Inter"
#let CODE = "JetBrains Mono"

// ---- Counters & state ------------------------------------------------
// Chapters bump `chapter-no`; parts bump `part-no`. Theorem-like blocks and
// exercises number themselves off their own figure counters (kinds "thmenv" /
// "exenv"), reset each chapter by the `book` template, printed <chapter>.<n>.
#let chapter-no = counter("chapter")
#let part-no = counter("part")

// Flipped to `true` by `#appendix()` — switches chapter/theorem numbering
// from arabic (1, 1.2) to letters (A, A.2).
#let appendix-state = state("appendix", false)

// Render "<chapter>.<n>" — or "<A>.<n>" in the appendix. Call inside a context
// (it reads the chapter counter and the appendix state).
#let env-number(n) = {
  let c = chapter-no.get().first()
  let head = if appendix-state.get() { numbering("A", c) } else { str(c) }
  [#head.#n]
}
