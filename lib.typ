// =============================================================
// zsf — vierspaltige Prüfungs-Zusammenfassung
// =============================================================
//
// Die öffentliche API. Ein Kapitel importiert nichts anderes als dies hier.
//
//   #import "@local/zsf:0.1.0": *
//   #show: zsf.with(title: "Analysis II", author: "…")
//
// Alle globalen Entscheidungen sind benannte Argumente von `zsf()`. Was dort
// nicht steht, wird nicht pro ZSF entschieden, sondern pro Stelle über einen
// Regler am Baustein — oder gar nicht.

#import "src/palette.typ": seeds as palette, tone-of
#import "src/structure.typ": front, newcol
#import "src/blocks.typ": panel, warn, formula, picture, code, steps, facts, item, split, sep, note, before, after, given, step, target, case
#import "src/tables.typ": tabular
#import "src/media.typ": fig, fig-side, caption
#import "src/markup.typ": kw, lbl, danger, concl, hl, diagram-label, xref, secref, markA, markB, markC, markD, quantity, script-ref
#import "src/maths.typ": *
#import "src/index.typ": idx, idx-see, make-index

#import "src/config.typ" as _c
#import "src/structure.typ" as _s
#import "src/palette.typ" as _p

/// Richtet das Dokument ein. Als Show-Regel verwenden:
/// `#show: zsf.with(title: "…", density: 0.9)`
#let zsf(body, ..opts) = {
  let given-opts = opts.named()

  // Ein Tippfehler in einer Stellschraube ist ein Fehler, kein stilles Nichts.
  let unknown = given-opts.keys().filter(k => k not in _c.defaults)
  if unknown.len() > 0 {
    panic(
      "Unbekannte Stellschraube: " + unknown.join(", ") + ". Bekannt sind: " + _c.defaults.keys().join(", "),
    )
  }

  let c = _c.derive(_c.defaults + given-opts)
  _c.cfg.update(c)

  // ── PDF-Identität ──────────────────────────────────────────
  set document(
    title: c.title,
    author: if c.author == "" { () } else { (c.author,) },
    keywords: (
      "release-id:" + c.release,
      "build-id:" + c.build,
      if c.subject != "" { "subject:" + c.subject },
    ).filter(k => k != none),
  )

  // ── Seite ──────────────────────────────────────────────────
  set page(
    paper: "a4",
    flipped: true,
    margin: c.margin,
    columns: c.columns,
    fill: white,
    footer: _s.page-footer(c.release),
    footer-descent: c.margin * 0.4,
  )
  // Der Steg der Seitenspalten haengt am `columns`-Element, nicht an `page`.
  set columns(gutter: c.gutter)

  // ── Satz ───────────────────────────────────────────────────
  set text(
    font: c.font,
    size: c.font-size.prose,
    fill: _p.body-fill,
    lang: c.lang,
    region: c.region,
    hyphenate: true,
  )
  set par(
    justify: c.justify,
    leading: 0.62em * c.leading,
    spacing: c.par-space,
  )
  show math.equation: set text(font: c.math-font)
  set raw(lang: none)
  show raw: set text(font: c.mono-font, size: c.font-size.dense)

  // Verweise tragen die Farbe ihres Ziels; nackte URLs bleiben dezent blau.
  show link: it => if type(it.dest) == str { text(fill: _p.link-color, it) } else { it }

  // ── Gliederung ─────────────────────────────────────────────
  set heading(numbering: "1.1.")
  show heading.where(level: 1): _s.chapter-bar
  show heading.where(level: 2): _s.section-bar
  show heading.where(level: 3): _s.subsection-bar

  // ── Kopf und Inhalt ────────────────────────────────────────
  // Der Dokumentkopf steht im Spaltenfluss: eine Spalte breit, kein Seitenkopf.
  _s.doc-header(c.title, c.author)
  body
}
