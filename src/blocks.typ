// =============================================================
// blocks.typ — die Box und ihre Vorbelegungen
// =============================================================
//
// Es gibt EINE Box (`panel`). Alles andere hier sind Vorbelegungen davon:
// ein Name, der eine Absicht benennt, und sonst nichts.
//
// Die Reihenfolge der Regler ist bedeutungslos, weil es benannte Argumente
// sind — sie stehen fest, bevor der Rumpf läuft. Der Vorgänger brauchte dafür
// verzögerte Auflösung, einen Vor-Lauf und einen 1064-zeiligen Verifier.

#import "config.typ": conf
#import "palette.typ": tone-of, neutral-tone, warn-tone
#import "structure.typ": chapter-tone, full-edges

#let _align = align // vor der Verschattung durch den Parameter sichern

// ── Ton auflösen ─────────────────────────────────────────────
// `auto` = der Kapitelton. Ein eigener Ton ist eine Farbe, keine Deklaration:
// `tone: rgb("#8C6239")` genügt und bringt die ganze Rollenfamilie mit.
#let resolve-tone(tone) = {
  if tone == auto { chapter-tone() } else if tone == "neutral" { neutral-tone } else if tone == "warn" { warn-tone } else if type(tone) == color { tone-of(tone) } else {
    panic("tone: erwartet auto, \"neutral\", \"warn\" oder eine Farbe — nicht " + repr(tone))
  }
}

// Ein bis zwei positionale Argumente: (Rumpf) oder (Titel, Rumpf).
#let _title-body(args) = {
  let p = args.pos()
  if p.len() == 1 { (none, p.first()) } else if p.len() == 2 { (p.first(), p.last()) } else {
    panic("Baustein erwartet [Rumpf] oder [Titel][Rumpf] — erhalten: " + str(p.len()) + " Argumente")
  }
}

// Der Rumpf braucht einen Argument-Sink für Titel und Inhalt — und ein Sink
// schluckt auch jeden falsch geschriebenen Regler. Ohne diese Prüfung wäre
// `panel(weigth: "quiet")` wirkungslos und ohne Meldung, also genau der
// stille Fehler, gegen den das ganze System gebaut ist.
#let _knobs = (
  "tone",
  "weight",
  "pad",
  "frame",
  "surface",
  "align",
  "font",
  "tag",
  "breakable",
)
#let _reject-unknown(args) = {
  let unknown = args.named().keys().filter(k => k not in _knobs)
  if unknown.len() > 0 {
    panic(
      "Unbekannter Regler: " + unknown.join(", ") + ". Bekannt sind: " + _knobs.join(", "),
    )
  }
}

#let _pad-x(c, pad) = {
  if pad == "none" { 0pt } else if pad == "tight" { c.pad.x-tight } else if pad == "bar" { c.pad.bar-gap } else { c.pad.x }
}
#let _pad-y(c, pad) = {
  if pad == "none" { 0pt } else if pad == "tight" { c.pad.y-tight } else { c.pad.y }
}
#let _frame(t, c, frame) = {
  if frame == "none" { none } else if frame == "strong" { c.rule + t.frame-strong } else if frame == "hard" { c.rule + t.frame-hard } else { c.rule + t.frame-soft }
}

// ── Die Box ──────────────────────────────────────────────────
/// Der allgemeine Inhaltsbaustein.
///
/// - Aufruf: `#panel[Rumpf]` oder `#panel[Titel][Rumpf]`
/// - `tone`: `auto` (Kapitel) · `"neutral"` · `"warn"` · eine Farbe
/// - `weight`: `"loud"` (Titelbalken) · `"quiet"` (Akzentkante) · `"caption"` (Titel über der Box)
/// - `pad`: `"normal"` · `"tight"` · `"none"` · `"bar"` (hält die Akzentkante frei)
/// - `frame`: `"soft"` · `"strong"` · `"hard"` · `"none"`
/// - `surface`: `auto` (folgt dem Gewicht) · `"plain"` · `"quiet"` · `"emphasis"`
#let panel(
  ..args,
  tone: auto,
  weight: "loud",
  pad: "normal",
  frame: "soft",
  surface: auto,
  align: left,
  font: "normal",
  tag: none,
  breakable: false,
) = context {
  _reject-unknown(args)
  let c = conf()
  let t = resolve-tone(tone)
  let (title, body) = _title-body(args)

  let px = _pad-x(c, pad)
  let py = _pad-y(c, pad)
  let quiet = weight == "quiet"

  // Fläche: der Baustein wählt die Rolle, der Ton die Farbe.
  // `auto` heisst: eine Box mit Titel trägt die (sehr blasse) laute Fläche,
  // eine ohne Titel bleibt weiss. Kräftig ist am Ende nur die Titelzeile.
  let back = if surface == "plain" { white } else if surface == "quiet" { t.quiet } else if surface == "emphasis" { t.emphasis } else if quiet { t.quiet } else if title == none { t.quiet } else { t.loud }

  let titled = title != none
  let head = if titled {
    let label = {
      set text(size: c.font-size.title, weight: "bold")
      title
      if tag != none {
        h(1fr)
        text(size: c.font-size.tag, weight: "regular", style: "italic", tag)
      }
    }
    if weight == "loud" {
      // Die Titelfläche setzt eine eigene Textfarbe und besitzt damit die Tinte.
      block(
        width: 100%,
        above: 0pt,
        below: 0pt,
        fill: t.title-back,
        inset: (x: px, y: c.pad.y-tight),
        full-edges(text(fill: t.title-text, label)),
      )
    } else if quiet {
      // Leise Fassung: der Titel ist die erste Inhaltszeile, in der Tonfarbe.
      block(
        width: 100%,
        above: 0pt,
        below: c.space.s,
        full-edges(text(fill: t.accent, label)),
      )
    }
  }

  let inner = block(
    width: 100%,
    above: 0pt,
    below: 0pt,
    fill: back,
    inset: (x: px, y: py),
    {
      set text(size: c.font-size.dense) if font == "dense"
      set par(justify: false) if align == center
      if quiet { head }
      _align(align, body)
    },
  )

  let shell = block(
    breakable: breakable,
    width: 100%,
    above: c.space.s,
    below: c.space.s,
    clip: true,
    radius: if quiet { 0pt } else { c.radius },
    // Leise Fassung: keine Umrandung, nur die Akzentkante links.
    stroke: if quiet { (left: c.pad.bar + t.accent) } else { _frame(t, c, frame) },
    fill: if quiet { back } else { none },
    {
      if not quiet { head }
      inner
    },
  )

  // Dritte Fassung: der Titel als leichte Zeile ÜBER der Box.
  if weight == "caption" and titled {
    block(above: c.space.s, below: 0pt, {
      // Eine Beschriftung, keine Überschrift: schlicht, in der Grundfarbe.
      set text(size: c.font-size.body)
      title
      if tag != none {
        h(1fr)
        text(size: c.font-size.tag, style: "italic", tag)
      }
    })
    block(above: c.space.xs, shell)
  } else {
    shell
  }
}

// ── Vorbelegungen ────────────────────────────────────────────
// Jede ist eine Zeile. Ein Name kommt nur dazu, wenn er eine eigene Absicht
// trägt UND eine Vorbelegung mitbringt, die man sonst komponieren müsste.

// Eine Vorbelegung ist eine Zeile: Standardwerte, die der Aufrufer überschreibt.
// (Typst lässt nur EINEN Argument-Sink zu, deshalb wird er hier aufgeteilt.)
#let _preset(fn, args, defaults) = fn(..args.pos(), ..(defaults + args.named()))

/// Stolperfalle. Titel ist mit »Achtung« vorbelegt.
#let warn(..args) = {
  let p = args.pos()
  let a = if p.len() == 1 { ([Achtung], p.first()) } else { p }
  panel(..a, ..((tone: "warn") + args.named()))
}

/// Formel(n), betont geflächt, zentriert.
#let formula(..args) = _preset(
  panel,
  args,
  (surface: "emphasis", align: center, pad: "tight", frame: "hard"),
)

/// Abbildung: der Container für selbstgezeichnete Diagramme.
#let picture(..args) = _preset(panel, args, (surface: "plain", align: center))

/// Code-Schnipsel. Die Sprache steht am Codeblock selbst, die Syntaxfärbung
/// bringt Typst mit — es gibt hier weder einen `lang`-Regler noch ein
/// Opt-in-Modul:
///
///   #code[```python
///   def f(x): return x
///   ```]
#let code(..args) = _preset(panel, args, (surface: "plain", pad: "tight"))

// ── Trenner und Anmerkungen ──────────────────────────────────
/// Trennt zwei Blöcke INNERHALB einer Box, wahlweise mit Beschriftung.
#let sep(label: none) = context {
  let c = conf()
  let t = chapter-tone()
  block(above: c.space.s, below: c.space.s, width: 100%, {
    if label == none {
      line(length: 100%, stroke: c.rule + t.rule)
    } else {
      grid(
        columns: (auto, 1fr),
        gutter: c.pad.x-tight,
        align: horizon,
        text(size: c.font-size.note, weight: "bold", fill: t.bar-light-text, label),
        line(length: 100%, stroke: c.rule + t.rule),
      )
    }
  })
}

/// Dezente Anmerkung unter einer Formel.
#let note(body) = context {
  let c = conf()
  block(above: c.space.xs, below: 0pt, text(size: c.font-size.note, fill: luma(35%), body))
}

/// Satz, der an die FOLGENDE Box gehört.
#let before(body) = context block(above: conf().space.s, below: conf().space.xs, body)

/// Satz, der an die VORHERGEHENDE Box gehört.
#let after(body) = context block(above: conf().space.xs, below: conf().space.s, body)

// ── Zwei Blöcke nebeneinander ────────────────────────────────
// Eigener Baustein statt eines Box-Reglers: »zwei Dinge nebeneinander« ist
// eine Layout-Frage und keine Eigenschaft der Box. Dadurch komponiert es in
// jeder Box, statt dass jede Box den Regler mitschleppt.
#let split(left, right, ratio: 0.5, align: top) = context {
  let c = conf()
  grid(
    columns: (ratio * 1fr, (1.0 - ratio) * 1fr),
    gutter: c.pad.x,
    align: align,
    left, right,
  )
}

// ── Listen ───────────────────────────────────────────────────
/// Faktenliste oder Verfahren. Die Einträge sind native Listenpunkte
/// (`-` bzw. `+`); `item` setzt nur die Marke davor.
///
///   #facts[Merkpunkte][
///     - #item[Erstens][gilt immer.]
///     - Zweitens, ohne Marke.
///   ]
///
/// Die Marke ist optional: Eine erfundene Marke, nur damit die Form aufgeht,
/// wäre eine Inhaltsänderung.
#let item(..args) = {
  let p = args.pos()
  if p.len() == 2 { strong(p.first()) + h(0.4em) + p.last() } else if p.len() == 1 { p.first() } else {
    panic("item erwartet [Text] oder [Marke][Text]")
  }
}

#let facts(..args) = context {
  let c = conf()
  let named = args.named()
  let t = resolve-tone(named.at("tone", default: auto))
  let (title, body) = _title-body(args)

  let content = {
    set enum(indent: 0pt, body-indent: c.pad.x-tight, spacing: c.space.s)
    set list(
      indent: 0pt,
      body-indent: c.pad.x-tight,
      spacing: c.space.s,
      marker: text(fill: t.accent, sym.bullet),
    )
    body
  }
  if title == none { content } else { panel(title, content, ..named) }
}

// ── Zielkette ────────────────────────────────────────────────
// Bedingung → Schritt → Ziel. Der Container ist eine Box mit fester
// Vorbelegung; die Glieder sind Pillen, damit die Kette scanbar bleibt.
#let _pill(fill: none, stroke: none, color: black, body) = context {
  let c = conf()
  box(
    fill: fill,
    stroke: stroke,
    radius: c.radius,
    inset: (x: c.pad.x-tight, y: c.pad.y-tight),
    text(fill: color, body),
  )
}

#let given(body) = context _pill(fill: chapter-tone().quiet, stroke: conf().rule + chapter-tone().frame-soft, body)
#let step(body) = context _pill(color: luma(30%), body)
#let target(body) = context _pill(fill: chapter-tone().emphasis, stroke: conf().rule + chapter-tone().frame-strong, color: chapter-tone().frame-hard, strong(body))

/// Herleitung / Fallunterscheidung.
#let steps(..args) = _preset(panel, args, (align: center, pad: "tight", frame: "strong", surface: "plain"))

/// Ein einzeiliger Fall: Bedingung → Ausdruck → Resultat.
#let case(cond, expr, result) = context {
  let c = conf()
  block(above: c.space.xs, below: c.space.xs, {
    given(cond)
    h(0.4em)
    sym.arrow.r
    h(0.4em)
    step(expr)
    h(0.4em)
    sym.arrow.r
    h(0.4em)
    target(result)
  })
}
