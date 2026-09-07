// =============================================================
// config.typ — die globalen Stellschrauben, an genau einer Stelle
// =============================================================
//
// Alles, was pro ZSF EINMAL entschieden wird, ist ein benanntes Argument von
// `zsf()` in lib.typ. Diese Datei hält die Vorbelegungen und rechnet daraus die
// abgeleiteten Masse aus.
//
// Regel wie im Vorgänger: Ein abgeleitetes Mass wird nicht von Hand gesetzt.
// Wer enger will, dreht `density`; wer grösser will, dreht `size`. Fehlt ein
// Bereich, kommt ein weiterer Faktor dazu — kein Mass wird überschrieben.

#import "palette.typ": seeds

#let defaults = (
  // ── Identität ──────────────────────────────────────────────
  title: "Zusammenfassung",
  author: "",
  subject: "",
  release: "DEV",
  build: "",

  // ── Grösse ─────────────────────────────────────────────────
  // `size` nimmt den ganzen Satz mit; die Rollen behalten ihr Verhältnis.
  size: 8pt,
  // Wie laut die verbindende Prosa neben dem Bausteininhalt steht. In einer
  // box-lastigen ZSF trägt die Box den Prüfungsstoff und die Prosa verbindet
  // ihn — dann darf sie eine Stufe leiser stehen.
  prose-scale: 1.0,
  // Das Gegenstück: wie laut der Bausteininhalt neben den Balken steht.
  // Der Regler, wenn der Inhalt an eine BREITE stösst — ob eine Formel in
  // einer zweispaltigen Tabellenzelle einzeilig bleibt, entscheidet die
  // Inhaltsgrösse allein; über `size` gelöst schrumpfen die Balken mit.
  content-scale: 1.0,
  // Zeilenhöhe. Enthält die Schrift selbst, deshalb ein eigener Regler und
  // nicht Teil der Dichte: Abstände vertragen jede Skalierung, Zeilen nicht.
  leading: 1.0,

  // ── Dichte ─────────────────────────────────────────────────
  // Ein Faktor auf alles Vertikale, das reiner Leerraum ist.
  density: 1.0,
  // Bereichsfaktoren multiplizieren den globalen Faktor für IHREN Bereich —
  // für ZSF, die ungleich verteilt sind.
  density-blocks: 1.0,
  density-text: 1.0,
  density-tables: 1.0,
  // Die Gliederung hat einen eigenen Faktor, weil ihre Masse sonst am
  // Block-Register hingen: Wer die Boxen enger stellt, rückte damit auch die
  // Balken an ihre Überschriften — zwei Entscheidungen an einem Regler.
  density-structure: 1.0,

  // ── Seite ──────────────────────────────────────────────────
  columns: 4,
  margin: 4mm,
  gutter: 3.5mm,
  // Der Steg folgt der Dichte bewusst NICHT: Beim Verdichten sollen die
  // Spalten nicht zusammenrücken, sonst laufen benachbarte Zeilen ineinander.

  // ── Schrift ────────────────────────────────────────────────
  font: "Carlito",
  math-font: "New Computer Modern Sans Math",
  mono-font: "DejaVu Sans Mono",
  lang: "de",
  region: "CH",
  // Flattersatz: in ~50 mm schmalen Spalten muss der Blocksatz entweder
  // trennen oder Wortzwischenräume aufblähen. Beides kostet mehr, als der
  // gerade rechte Rand einbringt.
  justify: false,
  // Hält Zahl und Einheit zusammen (»10 m/s«), damit die Zeile nicht dazwischen
  // bricht. Siehe `readability.typ`.
  bind-units: true,
  // Prüft abgesetzte Formeln auf Spaltenüberlauf. Bei `true` bricht der Build
  // ab, wenn eine Gleichung breiter als der verfügbare Satzspiegel ist.
  check-overflow: false,

  // ── Farbe ──────────────────────────────────────────────────
  palette: seeds,
  // Grössenfarben des Fachs: ("Kraft": 0, "Moment": 4)
  quantities: (:),
  // Nimmt für den S/W-Druck alle Grössenfarben zurück, ohne die Vergabe
  // oben anzutasten.
  quantity-colors: true,

  // ── Bausteine ──────────────────────────────────────────────
  // Zeigt das Register zusätzlich die Druckseite, nicht nur den Abschnitt?
  index-pages: true,
  // Die Höhe, die ein Bild-Container reserviert — Inhalt, kein Abstand, folgt
  // der Dichte nicht. FESTE Höhe, keine Obergrenze: Genau dadurch ist eine
  // Bildspalte von selbst einheitlich hoch. Ein flaches Bild steht deshalb in
  // einer leeren Bande; wo das stört, sticht `image(…, height: …)` pro Stelle.
  image-height: 1.1cm, // in einer Tabellenzeile
  figure-height: 2.6cm, // als eigener Block
)

// ── Abgeleitete Masse ────────────────────────────────────────
// Eine Rechenstelle für alles, was aus den Reglern folgt.
#let derive(c) = {
  let d = c.density
  let unit = c.size / 8pt // Basismasse sind auf 8pt geeicht
  // »Eine Stufe kleiner« — dieselbe Stufe für den `dense`-Regler und für Code.
  let step = 0.88
  // Und die leisere Stufe darunter: Anmerkung, Bildunterschrift, Kopfzeile.
  let quiet-step = 0.86

  let blocks = d * c.density-blocks
  let tables = d * c.density-tables
  let texts = d * c.density-text
  let struct = d * c.density-structure

  c + (
    // Die Abstandsskala zwischen Blöcken.
    space: (
      xs: 1pt * blocks * unit,
      s: 4pt * blocks * unit,
      m: 7pt * blocks * unit,
      l: 10pt * blocks * unit,
    ),
    // Innenabstände der Bausteine.
    pad: (
      x: 4pt * blocks * unit,
      y: 3.2pt * blocks * unit,
      x-tight: 2.4pt * blocks * unit,
      y-tight: 1.8pt * blocks * unit,
      // Der Akzentbalken der leisen Fassung und der Platz, den er freihält.
      bar: 2.2pt * unit,
      bar-gap: 4.4pt * blocks * unit,
    ),
    // Tabellen: Zellpolsterung und Zeilenluft.
    cell: (
      x: 3.2pt * tables * unit,
      // `colsep: "tight"` lieh sich bisher das SENKRECHTE Register `y`. Es war
      // zufällig kleiner und sah deshalb richtig aus — aber wer je die
      // Zeilenluft ändert, verstellte damit still die Spaltenpolsterung.
      x-tight: 2.2pt * tables * unit,
      y: 2.2pt * tables * unit,
      y-tight: 1.2pt * tables * unit,
      y-roomy: 4.2pt * tables * unit,
    ),
    // Gliederung: was ein Titelbalken an Raum nimmt und freihält. Eigenes
    // Register, damit »Balken enger an den Text« und »Boxen enger« zwei
    // Entscheidungen bleiben.
    bar: (
      pad-x: 4pt * struct * unit,
      pad-y: 1.8pt * struct * unit,
      above-chapter: 10pt * struct * unit,
      above-section: 7pt * struct * unit,
      above-subsection: 4pt * struct * unit,
      below: 4pt * struct * unit,
      below-subsection: 1pt * struct * unit,
    ),
    // Absatzabstand im Fliesstext.
    par-space: 4.4pt * texts * unit,
    // Form.
    radius: 2.2pt * unit,
    rule: 0.5pt,
    // Code steht RELATIV zu seiner Umgebung und nicht auf einer absoluten
    // Grösse: An `dense` gebunden war Inline-Code im Fliesstext bei
    // `prose-scale: 0.75` GRÖSSER als der Text darum herum — dieselbe
    // verkehrte Rangfolge, die `note` hatte. Als `em` folgt er jeder
    // Umgebung, in der er steht: Prosa, Boxinhalt, dichte Box, Tabellenzelle.
    mono-scale: step,
    // Dieselbe leise Stufe als VERHÄLTNIS — für Stellen, die schon in einer
    // gesetzten Umgebung stehen und ihr folgen sollen (Register-Seitenzahl).
    quiet-scale: quiet-step,
    // Schriftrollen, alle als Vielfaches der Grundgrösse.
    // Drei Rollen, drei Fragen. `body` ist der Bausteininhalt, `prose` der
    // Text dazwischen, und alles Übrige hängt direkt an der Grundgrösse —
    // Balken und Titel bleiben deshalb stehen, wenn einer der beiden
    // Rollen-Faktoren gedreht wird.
    font-size: (
      body: c.size * c.content-scale,
      prose: c.size * c.prose-scale,
      doc-title: c.size * 1.55, // Dokumentkopf
      chapter: c.size * 1.30,
      section: c.size * 1.06,
      subsection: c.size * 1.0,
      title: c.size * 1.0, // Box-Titel
      dense: c.size * c.content-scale * step, // der `dense`-Regler
      // Anmerkung, Bildunterschrift und Diagramm-Beschriftung stehen IN einem
      // Baustein und folgen deshalb `content-scale` wie sein übriger Inhalt.
      // Ohne ihn kippte die Rangfolge: Bei `content-scale: 0.75` stand die
      // Anmerkung unter einer Formel grösser da als die Formel selbst.
      note: c.size * c.content-scale * quiet-step, // Anmerkung, Bildunterschrift
      label: c.size * c.content-scale * 0.80, // Diagramm-Beschriftung
      // Das Meta-Tag und die Autorenzeile des Dokumentkopfs gehören zu den
      // BALKEN, nicht zum Bausteininhalt: Sie stehen auf einer Titelfläche und
      // müssen mit ihr zusammenbleiben, wenn ein Rollen-Faktor gedreht wird.
      tag: c.size * 0.82, // Meta-Tag im Titel
      header-note: c.size * quiet-step, // Autorenzeile im Dokumentkopf
      footer: 6pt, // Seitenmöbel: feste physische Grösse
    ),
  )
}

#let cfg = state("zsf-config", derive(defaults))
#let config-stack = state("zsf-config-stack", ())

/// Liest die Konfiguration. Nur innerhalb von `context` verwendbar.
#let conf() = {
  let s = config-stack.get()
  if s.len() > 0 { s.last() } else { cfg.get() }
}

/// Bereichsweise Anpassung von Dichte und Umbruchverhalten (z. B. für den Anhang).
///
/// Kann als Block `#density-scope(0.85)[ ... ]` oder als Show-Regel
/// `#show: density-scope.with(0.85, breakable: true)` verwendet werden.
///
/// - `density`: Faktor auf die laufende Dichte (z. B. `0.85` für 15 % dichter)
/// - `breakable`: `auto` (behält Vorbelegung), `true` (alle Boxen brechbar), `false`
#let density-scope(..args) = {
  let named = args.named()
  let pos = args.pos()
  if pos.len() == 0 {
    panic("density-scope: erwartet [Inhalt] als letztes Argument")
  }
  let body = pos.last()
  let factor = if pos.len() > 1 { pos.first() } else { named.at("density", default: 1.0) }
  let breakable = named.at("breakable", default: auto)
  if type(factor) not in (int, float) or factor <= 0 {
    panic("density-scope: »density« muss eine Zahl grösser null sein — nicht " + repr(factor))
  }
  if breakable not in (auto, true, false) {
    panic("density-scope: »breakable« erwartet auto, true oder false — nicht " + repr(breakable))
  }
  context {
    let c = conf()
    let new-c = derive(c + (
      density: c.density * factor,
      breakable: if breakable == auto { c.at("breakable", default: false) } else { breakable },
    ))
    config-stack.update(s => s + (new-c,))
    body
    config-stack.update(s => s.slice(0, -1))
  }
}
