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
#import "src/structure.typ": front, newcol, active-tone as tone
#import "src/blocks.typ": panel, warn, formula, picture, code, steps, facts, item, split, sep, note, before, after, given, step, target, case, gap, tablebox, inset, formula-line
#import "src/config.typ": density-scope
#import "src/tables.typ": tabular
#import "src/media.typ": fig, fig-side, caption
#import "src/markup.typ": kw, lbl, danger, concl, hl, diagram-label, xref, sec-ref, markA, markB, markC, markD, quantity, script-ref
#import "src/maths.typ": *
#import "src/index.typ": idx, idx-see, make-index

#import "src/config.typ" as _c
#import "src/structure.typ" as _s
#import "src/palette.typ" as _p
#import "src/readability.typ" as _r

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
  // Die Palette rotiert über alles ausser Slot 0 (der gehört dem Front-Matter).
  // Mit weniger als zwei Farben bliebe dafür nichts übrig, und die Rotation
  // teilte durch null — ein roher Compiler-Fehler mitten in `structure.typ`
  // statt einer Meldung, die sagt, welche Stellschraube gemeint ist.
  if type(c.palette) != array or c.palette.len() < 2 {
    panic(
      "Stellschraube »palette«: mindestens zwei Farben nötig — Slot 0 gehört dem "
        + "Front-Matter, die Kapitel rotieren über den Rest. Erhalten: "
        + repr(c.palette),
    )
  }
  // Eine Grössenfarbe sagt nur etwas, solange sie GENAU einer Grösse gehört.
  // Ohne diese Prüfung teilten sich zwei Namen still denselben Slot, und ein
  // Slot ausserhalb der Liste rutschte durch `calc.rem` lautlos auf einen
  // fremden: `("Kraft": 0, "Moment": 0, "Weg": 8)` setzte alle drei in
  // dasselbe Rot. Der LaTeX-Vorgänger brach dafür ab, dieser hier nicht.
  let slots = ()
  for (name, slot) in c.quantities {
    if type(slot) != int or slot < 0 or slot >= _p.quantity-colors.len() {
      panic(
        "Grösse »" + name + "«: Slot muss eine ganze Zahl von 0 bis "
          + str(_p.quantity-colors.len() - 1) + " sein — nicht " + repr(slot),
      )
    }
    if slot in slots {
      panic(
        "Grösse »" + name + "«: Slot " + str(slot) + " ist schon vergeben. "
          + "Eine Farbe, die zwei Grössen bedeutet, sagt nichts mehr aus.",
      )
    }
    slots.push(slot)
  }

  if type(c.check-overflow) != bool {
    panic(
      "Stellschraube »check-overflow«: erwartet bool — nicht "
        + repr(c.check-overflow),
    )
  }

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
  show math.equation.where(block: true): it => if c.check-overflow {
    layout(size => context {
      let m = measure(it)
      if m.width > size.width + 0.5pt {
        panic(
          "Gleichung ragt über die Spaltenbreite hinaus ("
            + repr(m.width) + " > " + repr(size.width)
            + "). Bitte mit \\ umbrechen oder als mehrzeiligen Block setzen:\n"
            + repr(it.body),
        )
      }
      it
    })
  } else {
    it
  }
  set raw(lang: none)
  show raw: set text(font: c.mono-font, size: c.mono-scale * 1em)

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
  if c.bind-units { _r.bind-units(body) } else { body }
}
