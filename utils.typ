// Public entry point for the template. Everything lives in `utils/`, split by
// concern; this barrel re-exports it all so consumers keep one import:
//
//     #import "utils.typ": *
//
//   utils/theme.typ         palette, fonts, counters, numbering
//   utils/components.typ    eyebrow, lettrine, page-title, envblock
//   utils/environments.typ  theorems, callouts, proof, exercise
//   utils/pages.typ         cover, toc, notation, references, part, appendix, ntable
//   utils/plots.typ         funcplot, vecplot, barplot (+ raw cetz / plot / chart)
//   utils/template.typ      the `book` interior template
#import "utils/theme.typ": *
#import "utils/components.typ": *
#import "utils/environments.typ": *
#import "utils/pages.typ": *
#import "utils/plots.typ": *
#import "utils/template.typ": *

// `references` lives here, not in `utils/`, on purpose: `bibliography()`
// resolves its path relative to the file that calls it, so keeping it at the
// project root makes the user's `"references.bib"` relative to *their* main.typ.
//   #references("references.bib")
//   #references("refs.bib", style: "association-for-computing-machinery")
// `header: none` keeps this back-matter page from inheriting the running
// header (otherwise it shows the last chapter's name, since `page-title` is not
// a real heading). `full: true` lists every entry in the `.bib`, not only the
// ones cited in the text — drop it if you want a cited-works-only bibliography.
#let references(path, title: [References], style: "ieee") = {
  page(header: none)[
    // Hidden marker so the page shows up in the TOC (see `book`, level-6 headings).
    #heading(level: 6, outlined: true, bookmarked: true)[#title]
    #page-title(title)
    #v(36pt)
    #bibliography(path, title: none, style: style, full: true)
  ]
}
