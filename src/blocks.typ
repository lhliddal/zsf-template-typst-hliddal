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
#import "knobs.typ": pick, reject-unknown
#import "palette.typ": tone-of, neutral-tone, warn-tone, ink-muted
#import "structure.typ": chapter-tone, active-tone, tone-stack, full-edges

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

// Jeder Regler ist eine Tabelle: Nachschlagen IST die Prüfung. Als if-Kette
// fiel ein falscher WERT hinten heraus und bekam die Vorbelegung — `pad:
// "tigt"` polsterte normal, `weight: "quite"` liess die Kopfzeile ersatzlos
// verschwinden. Beides ohne Meldung.
#let _pad-x(c, pad) = pick("pad", pad, (
  "normal": c.pad.x,
  "tight": c.pad.x-tight,
  "bar": c.pad.bar-gap,
  "none": 0pt,
))
#let _pad-y(c, pad) = pick("pad", pad, (
  "normal": c.pad.y,
  "tight": c.pad.y-tight,
  // Die Akzentkante ist eine waagrechte Angelegenheit; oben und unten bleibt
  // die Polsterung normal.
  "bar": c.pad.y,
  "none": 0pt,
))
#let _frame(t, c, frame) = pick("frame", frame, (
  "soft": c.rule + t.frame-soft,
  "strong": c.rule + t.frame-strong,
  "hard": c.rule + t.frame-hard,
  "none": none,
))

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
  breakable: auto,
) = context {
  reject-unknown("dieser Box", args.named(), _knobs)
  let c = conf()
  let is-breakable = if breakable == auto { c.at("breakable", default: false) } else if type(breakable) == bool { breakable } else {
    panic("Regler »breakable«: erwartet true, false oder auto — nicht " + repr(breakable))
  }
  let t = resolve-tone(tone)
  let (title, body) = _title-body(args)

  let px = _pad-x(c, pad)
  let py = _pad-y(c, pad)
  // Prüft den Wert und liefert ihn zugleich aus.
  let quiet = pick("weight", weight, ("loud": false, "quiet": true, "caption": false))
  let body-size = pick("font", font, ("normal": c.font-size.body, "dense": c.font-size.dense))
  if align not in (left, center, right) {
    panic("Regler »align«: erwartet left, center oder right — nicht " + repr(align))
  }

  // Fläche: der Baustein wählt die Rolle, der Ton die Farbe.
  // `auto` heisst: eine Box mit Titel trägt die (sehr blasse) laute Fläche,
  // eine ohne Titel bleibt weiss. Kräftig ist am Ende nur die Titelzeile.
  let back = if surface == auto {
    if quiet or title == none { t.quiet } else { t.loud }
  } else {
    pick("surface", surface, ("plain": white, "quiet": t.quiet, "emphasis": t.emphasis))
  }

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
      // Auch wenn der Rumpf randlos ist (pad: "none", z. B. bei Tabellen),
      // behält die Kopfzeile ihren waagrechten Innenabstand.
      let title-px = if pad == "none" { c.pad.x } else { px }
      block(
        width: 100%,
        above: 0pt,
        below: 0pt,
        fill: t.title-back,
        inset: (x: title-px, y: c.pad.y-tight),
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
      // Der Bausteininhalt steht auf `body`, nicht auf der Dokumentgrösse.
      // Sonst zöge `prose-scale` den Boxinhalt mit — der Regler heisst aber
      // »nur der verbindende Fliesstext«, und die Tabelle tat es schon richtig.
      set text(size: body-size)
      set par(justify: false) if align == center
      // Klammer um den Inhalt: Was in dieser Box steht, kennt ihren Ton.
      tone-stack.update(s => s + (t,))
      if quiet { head }
      _align(align, body)
      tone-stack.update(s => s.slice(0, -1))
    },
  )

  let shell = block(
    breakable: is-breakable,
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
  // Der Ton der Box, in der dieser Trenner steht — nicht der des Kapitels.
  let t = active-tone()
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
  block(above: c.space.xs, below: 0pt, text(size: c.font-size.note, fill: ink-muted, body))
}

/// Satz, der an die FOLGENDE Box gehört.
#let before(body) = context block(above: conf().space.s, below: conf().space.xs, body)

/// Satz, der an die VORHERGEHENDE Box gehört.
#let after(body) = context block(above: conf().space.xs, below: conf().space.s, body)

/// Semantischer vertikaler Abstand zwischen Blöcken im Kapitel.
///
/// Kollabiert dank `weak: true` sauber mit den umgebenden Kastenabständen.
///
/// - `step`: `"xs"` · `"s"` · `"m"` (Vorbelegung) · `"l"` · `"section"` (Thementrenner)
#let gap(..args) = context {
  let named = args.named()
  reject-unknown("dieses Abstands", named, ("step",))
  let pos = args.pos()
  let step = if pos.len() > 0 { pos.first() } else { named.at("step", default: "m") }
  let c = conf()
  let d = pick("gap", step, (
    "xs": c.space.xs,
    "s": c.space.s,
    "m": c.space.m,
    "l": c.space.l,
    "section": c.space.l,
  ))
  v(d, weak: true)
}

// ── Zwei Blöcke nebeneinander ────────────────────────────────
// Eigener Baustein statt eines Box-Reglers: »zwei Dinge nebeneinander« ist
// eine Layout-Frage und keine Eigenschaft der Box. Dadurch komponiert es in
// jeder Box, statt dass jede Box den Regler mitschleppt.
#let split(left, right, ratio: 0.5, align: top) = context {
  // Ausserhalb von (0, 1) bekommt eine Hälfte eine negative oder gar keine
  // Breite — die Blöcke drucken dann übereinander oder laufen aus der Spalte,
  // beides ohne Meldung.
  if type(ratio) not in (int, float) or ratio <= 0 or ratio >= 1 {
    panic(
      "split: »ratio« ist der Anteil der linken Hälfte und liegt echt zwischen "
        + "0 und 1 — nicht " + repr(ratio),
    )
  }
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
  // Ohne Titel entsteht keine Box — dann gibt es keinen Träger für die
  // Box-Regler, und sie fielen vorher lautlos unter den Tisch. `tone` wirkt
  // trotzdem, weil die Liste ihr Aufzählungszeichen selbst färbt.
  let (title, body) = _title-body(args)
  reject-unknown("dieser Liste", named, if title == none { ("tone",) } else { _knobs })
  let t = resolve-tone(named.at("tone", default: auto))

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

// Auch die Glieder lesen den Ton ihrer Box: In `steps(tone: "warn")` waren
// sie vorher kapitelfarben, obwohl die Box rot war.
#let given(body) = context {
  let t = active-tone()
  _pill(fill: t.quiet, stroke: conf().rule + t.frame-soft, body)
}
#let step(body) = context _pill(color: ink-muted, body)
#let target(body) = context {
  let t = active-tone()
  _pill(fill: t.emphasis, stroke: conf().rule + t.frame-strong, color: t.frame-hard, strong(body))
}

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
