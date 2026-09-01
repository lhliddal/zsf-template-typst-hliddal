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

  // ── Farbe ──────────────────────────────────────────────────
  palette: seeds,
  // Grössenfarben des Fachs: ("Kraft": 0, "Moment": 4)
  quantities: (:),

  // ── Bausteine ──────────────────────────────────────────────
  // Zeigt das Register zusätzlich die Druckseite, nicht nur den Abschnitt?
  index-pages: true,
  // Maximalhöhen für Bilder — Inhalt, kein Abstand, folgt der Dichte nicht.
  image-height: 1.1cm, // in einer Tabellenzeile
  figure-height: 2.6cm, // als eigener Block
)

// ── Abgeleitete Masse ────────────────────────────────────────
// Eine Rechenstelle für alles, was aus den Reglern folgt.
#let derive(c) = {
  let d = c.density
  let unit = c.size / 8pt // Basismasse sind auf 8pt geeicht

  let blocks = d * c.density-blocks
  let tables = d * c.density-tables
  let texts = d * c.density-text

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
      y: 2.2pt * tables * unit,
      y-tight: 1.2pt * tables * unit,
      y-roomy: 4.2pt * tables * unit,
    ),
    // Absatzabstand im Fliesstext.
    par-space: 4.4pt * texts * unit,
    // Form.
    radius: 2.2pt * unit,
    rule: 0.5pt,
    // Schriftrollen, alle als Vielfaches der Grundgrösse.
    font-size: (
      body: c.size,
      prose: c.size * c.prose-scale,
      doc-title: c.size * 1.55, // Dokumentkopf
      chapter: c.size * 1.30,
      section: c.size * 1.06,
      subsection: c.size * 1.0,
      title: c.size * 1.0, // Box-Titel
      dense: c.size * 0.88, // der `dense`-Regler
      note: c.size * 0.86, // Anmerkung, Bildunterschrift
      tag: c.size * 0.82, // Meta-Tag im Titel
      label: c.size * 0.80, // Diagramm-Beschriftung
      footer: 6pt, // Seitenmöbel: feste physische Grösse
    ),
  )
}

#let cfg = state("zsf-config", derive(defaults))

/// Liest die Konfiguration. Nur innerhalb von `context` verwendbar.
#let conf() = cfg.get()
