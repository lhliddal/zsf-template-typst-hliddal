// =============================================================
// tables.typ — Tabelle als EIN Baustein
// =============================================================
//
// Im Vorgänger waren Tabelle und Tabellenbox zwei Bausteine, die man
// ineinander stecken musste, plus zwei Makros für die Kopfzeile, von denen
// eines allein die Kopfzeile unsichtbar machte (weiss auf weiss, ohne Fehler).
//
// Hier ist es eine Funktion. Die Kopfzeile sind einfach die ersten Zellen;
// dass man sie »halb« setzt, ist strukturell nicht mehr möglich.

#import "config.typ": conf
#import "knobs.typ": pick, reject-unknown
#import "blocks.typ": panel, resolve-tone

/// Tabelle, wahlweise als eigener Baustein mit Titel.
///
/// - `cols`: Gewichte der Spalten, `(1, 2.4, 1)` — oder feste Längen
/// - `header`: erste `cols.len()` Zellen sind die Kopfzeile
/// - `zebra`, `grid`: `"both"` · `"horizontal"` · `"none"`
/// - `rows`: `"normal"` · `"roomy"` (Brüche, Wurzeln) · `"tight"` (Kurzregister)
/// - `colsep`: `"normal"` · `"tight"` (vielspaltige Register)
/// - `align`: eine Ausrichtung für alle Spalten — oder eine je Spalte,
///   `align: (left, right)` für die Zahlenspalte rechtsbündig
#let tabular(
  ..cells,
  title: none,
  cols: (1,),
  header: true,
  zebra: true,
  grid: "both",
  rows: "normal",
  colsep: "normal",
  font: "normal",
  tone: auto,
  align: left,
  breakable: false,
) = context {
  // Alles Benannte ist oben deklariert und damit gebunden — was im Sink
  // landet, ist ein Tippfehler. Ohne diese Zeile hiess `tabular(colss: …)`
  // still »eine Spalte«: die Tabelle stand falsch, ohne dass etwas brach.
  reject-unknown(
    "dieser Tabelle",
    cells.named(),
    ("title", "cols", "header", "zebra", "grid", "rows", "colsep", "font", "tone", "align", "breakable"),
  )
  let c = conf()
  let t = resolve-tone(tone)
  let n = cols.len()

  // Eine Spaltenliste, die nicht aufgeht, zerstört die Tabelle lautlos: Bei
  // `cols: ()` fällt alles in eine Spalte, bei einem Gewicht 0 drucken zwei
  // Zellen übereinander (»Wpfrt«). Beides kompiliert ohne ein Wort.
  if cols.len() == 0 {
    panic("Regler »cols«: eine Tabelle braucht mindestens eine Spalte.")
  }
  for w in cols {
    let bad = if type(w) in (int, float) { w <= 0 } else if type(w) == length { w <= 0pt } else { false }
    if bad {
      panic("Regler »cols«: jede Spalte braucht ein Gewicht grösser null — erhalten: " + repr(cols))
    }
  }

  // Eine Ausrichtung für alle Spalten — oder eine je Spalte. Ohne die zweite
  // Form gäbe es für die rechtsbündige Zahlenspalte nur `table.cell(align:)`
  // an JEDER Zelle, und ein `align: (left, right)` scheiterte mit einer rohen
  // Compiler-Meldung (»cannot add array and alignment«) statt mit einer, die
  // den Regler nennt.
  let check-align(a) = {
    if type(a) != alignment {
      panic("Regler »align«: erwartet eine Ausrichtung (left, center, right) — nicht " + repr(a))
    }
    a + horizon
  }
  let cell-align = if type(align) == array {
    if align.len() != cols.len() {
      panic(
        "Regler »align«: " + str(align.len()) + " Ausrichtungen für "
          + str(cols.len()) + " Spalten. Eine je Spalte — oder eine für alle.",
      )
    }
    align.map(check-align)
  } else { check-align(align) }

  let columns = cols.map(w => if type(w) in (int, float) { w * 1fr } else { w })
  let pad-x = pick("colsep", colsep, ("normal": c.cell.x, "tight": c.cell.x-tight))
  let pad-y = pick("rows", rows, (
    "normal": c.cell.y,
    "roomy": c.cell.y-roomy,
    "tight": c.cell.y-tight,
  ))
  // Nur geprüft, gebraucht wird der Wert unten zweimal einzeln.
  let _ = pick("grid", grid, ("both": 0, "horizontal": 1, "none": 2))
  let cell-size = pick("font", font, ("normal": c.font-size.body, "dense": c.font-size.dense))

  // Die Kopfzeile sind die ersten Zellen — gezählt in SPALTEN, nicht in
  // Argumenten: Ein `table.cell(colspan: 2)` in der Kopfzeile ist eine Zelle,
  // aber zwei Spalten. Wer das nicht mitzählt, verschiebt die ganze Tabelle
  // um eine Zelle, und zwar ohne Fehlermeldung.
  let all = cells.pos()
  let field-of(cell, name) = if type(cell) == content and cell.func() == table.cell {
    cell.fields().at(name, default: 1)
  } else { 1 }
  // Linien sind Anweisungen, keine Zellen — sie zählen bei der Aufteilung nicht mit.
  let is-line(cell) = type(cell) == content and cell.func() in (table.hline, table.vline)

  let split-at = 0
  if header {
    let used = 0
    while used < n and split-at < all.len() {
      if not is-line(all.at(split-at)) { used += field-of(all.at(split-at), "colspan") }
      split-at += 1
    }
    // Eine Kopfzeile, die nicht über alle Spalten reicht, ist immer ein
    // Versehen — und eines, das man im Satz nicht sieht: Die Tabelle steht
    // dann einfach mit einer halben Kopfzeile da.
    if used < n {
      panic(
        "Kopfzeile deckt " + str(used) + " von " + str(n) + " Spalten ab. "
          + "Die ersten Zellen SIND die Kopfzeile — eine je Spalte.",
      )
    }
  }

  // Und die Gegenprobe über die ganze Tabelle: Fehlt irgendwo eine Zelle,
  // rutscht ab dort jede Zeile um eins, und zwar ohne ein Wort. In einer ZSF,
  // die in der Prüfung gelesen wird, ist das kein Schönheitsfehler.
  // Bei einem `rowspan` stimmt die einfache Rechnung nicht mehr — dann wird
  // nicht geprüft, statt falsch zu melden.
  let payload = all.filter(c => not is-line(c))
  let placed(c) = type(c) == content and c.func() == table.cell and (
    "x" in c.fields() or "y" in c.fields()
  )
  let unzaehlbar = payload.any(c => field-of(c, "rowspan") > 1 or placed(c))
  if not unzaehlbar {
    let covered = payload.fold(0, (acc, c) => acc + field-of(c, "colspan"))
    if calc.rem(covered, n) != 0 {
      panic(
        "Die Zellen füllen " + str(covered) + " Felder, die Tabelle hat " + str(n)
          + " Spalten — die letzte Zeile bleibt unvollständig und alles ab der "
          + "fehlenden Zelle verrutscht.",
      )
    }
  }
  let head-cells = all.slice(0, split-at)
  let body-cells = all.slice(split-at)

  let table-content = table(
    columns: columns,
    inset: (x: pad-x, y: pad-y),
    align: cell-align,
    // Die Aussenkante zeichnet der Rahmen der Box — eine Tabellenlinie ist
    // gerade und endete an den runden Ecken im Nichts.
    stroke: (x, y) => (
      left: if x > 0 and grid == "both" { c.rule + t.frame-soft },
      top: if y > 0 and grid != "none" { c.rule + t.frame-soft },
    ),
    fill: (x, y) => {
      let i = y - (if header { 1 } else { 0 })
      // Die Kopfzeile ist gesättigt (`head-back`), nicht die helle Titelfläche
      // der Box — sonst verschmelzen Boxtitel und Kopfzeile zu einem Block.
      if header and y == 0 { t.head-back } else if zebra and calc.odd(i) { t.zebra }
    },
    ..if header and head-cells.len() > 0 { (table.header(..head-cells),) } else { () },
    ..body-cells,
  )

  let sized = {
    // Die Kopfschrift kommt aus einer SET-Regel, nicht aus einem `text()` um
    // jede Zelle. Der Grund ist der Zellverbund: Eine Kopfzelle, die für einen
    // `colspan` selbst ein `table.cell` ist, musste beim Umwickeln übersprungen
    // werden (sonst läge sie in einem `text()` und wäre keine Zelle mehr) — und
    // blieb dadurch schwarz auf der gesättigten Kopfzeile. Die Regel trifft
    // beide Fälle und ist dazu kürzer.
    show table.cell.where(y: 0): set text(fill: t.head-text, weight: "bold") if header
    set text(size: cell-size)
    // Ein Bild muss in die Zeile passen; das Budget gehört dem Container.
    set image(height: c.image-height, fit: "contain")
    table-content
  }

  if title == none {
    sized
  } else {
    // Der Inhalt polstert sich selbst — sonst endete das Zebra vor dem Rahmen.
    panel(title, sized, pad: "none", frame: "hard", tone: tone, breakable: breakable)
  }
}
