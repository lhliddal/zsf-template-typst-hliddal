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
#import "blocks.typ": panel, resolve-tone

/// Tabelle, wahlweise als eigener Baustein mit Titel.
///
/// - `cols`: Gewichte der Spalten, `(1, 2.4, 1)` — oder feste Längen
/// - `header`: erste `cols.len()` Zellen sind die Kopfzeile
/// - `zebra`, `grid`: `"both"` · `"horizontal"` · `"none"`
/// - `rows`: `"normal"` · `"roomy"` (Brüche, Wurzeln) · `"tight"` (Kurzregister)
/// - `colsep`: `"normal"` · `"tight"` (vielspaltige Register)
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
  let c = conf()
  let t = resolve-tone(tone)
  let n = cols.len()

  let columns = cols.map(w => if type(w) in (int, float) { w * 1fr } else { w })
  let pad-x = if colsep == "tight" { c.cell.y } else { c.cell.x }
  let pad-y = if rows == "roomy" { c.cell.y-roomy } else if rows == "tight" { c.cell.y-tight } else { c.cell.y }

  // Die Kopfzeile sind die ersten Zellen — gezählt in SPALTEN, nicht in
  // Argumenten: Ein `table.cell(colspan: 2)` in der Kopfzeile ist eine Zelle,
  // aber zwei Spalten. Wer das nicht mitzählt, verschiebt die ganze Tabelle
  // um eine Zelle, und zwar ohne Fehlermeldung.
  let all = cells.pos()
  let split-at = 0
  if header {
    let used = 0
    while used < n and split-at < all.len() {
      let cell = all.at(split-at)
      let span = if type(cell) == content and cell.func() == table.cell {
        cell.fields().at("colspan", default: 1)
      } else { 1 }
      used += span
      split-at += 1
    }
  }
  let head-cells = all.slice(0, split-at)
  let body-cells = all.slice(split-at)

  let table-content = table(
    columns: columns,
    inset: (x: pad-x, y: pad-y),
    align: align + horizon,
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
    ..if header and head-cells.len() > 0 {
      (
        table.header(
          ..head-cells.map(h => if type(h) == content and h.func() == table.cell {
            h
          } else {
            text(fill: t.head-text, weight: "bold", h)
          }),
        ),
      )
    } else { () },
    ..body-cells,
  )

  let sized = {
    set text(size: if font == "dense" { c.font-size.dense } else { c.font-size.body })
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
