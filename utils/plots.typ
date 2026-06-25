// Math graphs — themed function plots, vector diagrams, and bar charts. Each
// helper returns a numbered, referenceable `figure` (kind: image), so it slots
// in beside `ntable` and plain `#figure(image(..))` and reads <chapter>.<n>.
//
// Built on CeTZ (drawing) + CeTZ-Plot (plots/charts). Both are `@preview`
// packages, downloaded on first compile like `droplet`. The raw `cetz`, `plot`,
// and `chart` modules are re-exported for full-control diagrams (the escape
// hatch): `#figure(cetz.canvas({ .. }), caption: [..])`.
#import "theme.typ": *
#import "components.typ": *
#import "@preview/cetz:0.5.2"
#import "@preview/cetz-plot:0.1.4": plot, chart

// Curve / vector / bar colours, cycled in order when a plot has several series.
#let _series = (accent, gold, ink)
#let _nth(i) = _series.at(calc.rem(i, _series.len()))

// Shared axis dressing: warm hairline axes, muted ticks, label-face tick text.
// Wrap a `cetz.canvas` body so every graph matches the page, not cetz defaults.
#let _framed(caption, body) = figure(
  kind: image,
  caption: caption,
  {
    set text(font: LABEL, size: 8pt, fill: muted, number-type: "lining")
    pad(top: 10pt, body)
  },
)

// Function graph. Pass one or more functions; they overlay, cycling the palette.
//   #funcplot(x => calc.exp(-x), domain: (0, 4), caption: [..]) <fig-x>
//   #funcplot(x => x, x => x*x, domain: (-2, 2))
#let funcplot(
  ..fns,
  domain: (-3, 3),
  caption: none,
  x-label: none,
  y-label: none,
  x-tick-step: 1,
  y-tick-step: 1,
  samples: 200,
  size: (9, 5.5),
) = _framed(
  caption,
  cetz.canvas({
    import cetz.draw: set-style
    set-style(axes: (
      stroke: 0.6pt + ink.lighten(20%),
      tick: (stroke: 0.6pt + muted),
      grid: (stroke: 0.4pt + rule),
    ))
    plot.plot(
      size: size,
      axis-style: "school-book",
      x-label: x-label,
      y-label: y-label,
      x-tick-step: x-tick-step,
      y-tick-step: y-tick-step,
      x-grid: true,
      y-grid: true,
      {
        for (i, fn) in fns.pos().enumerate() {
          plot.add(domain: domain, samples: samples, fn, style: (stroke: _nth(i) + 1.4pt))
        }
      },
    )
  }),
)

// One vector for `vecplot`, parsed into (start, end, label):
//   ((x, y),)                 arrow from the origin, no label
//   ((x, y), $v$)             arrow from the origin, labelled
//   ((x, y), (x2, y2))        arrow start→end, no label
//   ((x, y), (x2, y2), $v$)   arrow start→end, labelled
#let _parse-vec(v) = {
  if v.len() == 1 { ((0, 0), v.at(0), none) } else if v.len() == 3 {
    (v.at(0), v.at(1), v.at(2))
  } else if type(v.at(1)) == array {
    (v.at(0), v.at(1), none)
  } else {
    ((0, 0), v.at(0), v.at(1))
  }
}

// 2D vector / arrow diagram: light grid, axes through the origin, palette-cycled
// arrows. Range auto-fits the vectors (override with `xrange` / `yrange`).
//   #vecplot(((3, 1), $u$), ((1, 2), $v$), ((3, 1), (4, 3), $u+v$), caption: [..])
#let vecplot(
  ..vectors,
  caption: none,
  size: (6, 6),
  xrange: auto,
  yrange: auto,
  show-grid: true,
) = {
  let parsed = vectors.pos().map(_parse-vec)
  let xs = parsed.map(p => (p.at(0).at(0), p.at(1).at(0))).flatten() + (0,)
  let ys = parsed.map(p => (p.at(0).at(1), p.at(1).at(1))).flatten() + (0,)
  let xr = if xrange == auto { (calc.floor(calc.min(..xs)) - 1, calc.ceil(calc.max(..xs)) + 1) } else { xrange }
  let yr = if yrange == auto { (calc.floor(calc.min(..ys)) - 1, calc.ceil(calc.max(..ys)) + 1) } else { yrange }

  _framed(
    caption,
    cetz.canvas({
      import cetz.draw: *
      // background grid
      if show-grid {
        for x in range(xr.at(0), xr.at(1) + 1) {
          line((x, yr.at(0)), (x, yr.at(1)), stroke: 0.4pt + rule)
        }
        for y in range(yr.at(0), yr.at(1) + 1) {
          line((xr.at(0), y), (xr.at(1), y), stroke: 0.4pt + rule)
        }
      }
      // axes through the origin
      line((xr.at(0), 0), (xr.at(1), 0), mark: (end: ">"), stroke: 0.7pt + ink.lighten(15%))
      line((0, yr.at(0)), (0, yr.at(1)), mark: (end: ">"), stroke: 0.7pt + ink.lighten(15%))
      // vectors
      for (i, p) in parsed.enumerate() {
        let (start, end, label) = p
        line(start, end, mark: (end: ">", fill: _nth(i)), stroke: _nth(i) + 1.4pt)
        if label != none {
          content(
            end,
            anchor: "south-west",
            padding: 4pt,
            text(font: BODY, size: 10pt, fill: _nth(i))[#label],
          )
        }
      }
    }),
  )
}

// Discrete bar chart from `(label, value)` pairs — e.g. a distribution.
//   #barplot((([1], 0.5), ([2], 0.3), ([3], 0.2)), caption: [..], y-label: [Pr])
#let barplot(
  data,
  caption: none,
  size: (9, 5.5),
  x-label: none,
  y-label: none,
) = _framed(
  caption,
  cetz.canvas({
    import cetz.draw: set-style
    set-style(axes: (
      stroke: 0.6pt + ink.lighten(20%),
      tick: (stroke: 0.6pt + muted),
    ))
    chart.columnchart(
      data,
      size: size,
      x-label: x-label,
      y-label: y-label,
      bar-style: (fill: accent.lighten(8%), stroke: 0.6pt + accent.darken(12%)),
    )
  }),
)
