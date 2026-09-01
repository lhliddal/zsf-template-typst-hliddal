// =============================================================
// palette.typ — Farbe: Kapitel-Slots, Ton-Ableitung, Ink-Vertrag
// =============================================================
//
// Ein Ton ist EINE Akzentfarbe. Alle Rollen werden daraus abgeleitet.
//
// Die Ableitung ist nicht erfunden, sondern die Regel HINTER der kuratierten
// Palette des Vorgängers: Dessen 18 handgewählte Aufhellungen liegen alle bei
// L ≈ 88.5 % und tragen ein Fünftel der Buntheit ihres Akzents (gemessen über
// alle Slots, Streuung L 86–90, C-Faktor 0.16–0.29). Alles Weitere sind
// Mischungen daraus, wortgleich zu den `!`-Anteilen des Vorgängers.
//
// Wichtig für das Satzbild: Der Titelbalken einer Box ist HELL mit dunkler
// Schrift, nicht gesättigt mit weisser. Gesättigt sind nur Kapitel- und
// Abschnittsbalken, die Tabellenkopfzeile und der Warn-Ton.

// ── Die 18 Kapitel-Slots ─────────────────────────────────────
// Kuratiert für Unterscheidbarkeit bei Abstand 1 UND 2; alle dunkel genug,
// dass weisse Schrift darauf trägt und die Farbe als Verweis auf Weiss lesbar
// bleibt. Slot 0 gehört dem Front-Matter (ETH-Blau).
#let seeds = (
  rgb("#215CAF"), // 0  ETH Blue      — reserviert für Front-Matter
  rgb("#6E3B6E"), // 1  ETH Purple
  rgb("#5A7F2B"), // 2  ETH Green
  rgb("#8C6239"), // 3  ETH Bronze
  rgb("#007894"), // 4  ETH Petrol
  rgb("#B7352D"), // 5  ETH Red
  rgb("#23523B"), // 6  Dark Spruce
  rgb("#8F2459"), // 7  Raspberry
  rgb("#17205E"), // 8  Midnight Blue
  rgb("#2D8659"), // 9  Emerald
  rgb("#523523"), // 10 Walnut
  rgb("#8F2481"), // 11 Orchid
  rgb("#1D581D"), // 12 Deep Green
  rgb("#5E1720"), // 13 Oxblood
  rgb("#4C248F"), // 14 Violet
  rgb("#233552"), // 15 Slate Navy
  rgb("#207E73"), // 16 Sea Teal
  rgb("#58581D"), // 17 Olive Brown
)

// ── Semantische Farben ───────────────────────────────────────
#let body-fill = black // die Grundfarbe des Satzes — Anker des Ink-Vertrags
#let title-ink = rgb("#0A0A1E") // Schrift auf einer hellen Titelfläche
#let link-color = rgb("#215CAF")
#let danger-color = rgb("#CC0000") // ETH-Rot

// Gedämpfte Tinte — DREI Stufen, benannt nach ihrer Rolle. Vorher waren es
// sieben Grauwerte, über fünf Dateien verstreut und alle direkt hingeschrieben:
// 30, 35, 40, 45, 50, 55, 60 %. Der Unterschied zwischen 40 und 45 % ist keine
// Bedeutung, sondern nur ein anderer Grauton — und solange jede Fundstelle
// ihren eigenen mitbrachte, konnte niemand sie gemeinsam heller stellen.
#let ink-muted = luma(35%) // Anmerkung, Bildunterschrift, Zwischenschritt
#let ink-faint = luma(52%) // Seitenmöbel, Register-Locator, Skript-Verweis
#let ink-ghost = luma(75%) // Punktführung im Register — sichtbar, nie gelesen
#let ink-on-accent-soft = white.darken(12%) // zweite Zeile auf gefärbter Fläche

// ── Ton-Ableitung ────────────────────────────────────────────
// Die Aufhellung: gleiche Helligkeit für jeden Akzent, damit Slot 8 (sehr
// dunkles Blau) und Slot 3 (helle Bronze) gleich hell getönte Flächen
// ergeben. Ein `lighten()` auf den Akzent täte das nicht.
#let shade(accent, lightness, chroma-factor) = {
  let c = oklch(accent).components()
  oklch(lightness * 1%, c.at(1) * chroma-factor, c.at(2))
}

// Die Aufhellung eines Akzents — die Titelfläche einer Box.
#let light-of(accent) = shade(accent, 88.5, 0.20)

/// Leitet aus einer Akzentfarbe die vollständige Rollenfamilie ab.
///
/// `emphatic` kehrt die Titelfläche um: gesättigt mit weisser Schrift statt
/// hell mit dunkler. Für den Warn-Ton — eine Stolperfalle soll rufen.
#let tone-of(accent, emphatic: false) = {
  // Jede Fläche ist eine Ziel-Helligkeit plus ein Anteil der Buntheit. Nicht
  // ein Prozentsatz auf den Akzent: Sonst wäre die getönte Fläche eines
  // dunklen Slots sichtbar dunkler als die eines hellen, und dieselbe Box sähe
  // je nach Kapitel unterschiedlich kräftig aus.
  //
  // Die Werte sind an der kuratierten Palette des Vorgängers gemessen; die
  // emphatische Spalte gilt für den Warn-Ton, dessen Flächen kräftiger sein
  // dürfen, weil sein Titel ohnehin ruft.
  //                        L    Buntheit      L (emph)  Buntheit (emph)
  let roles = (
    loud: (98.5, 0.06, 94.0, 0.30), // Fläche einer Box mit Titel
    emphasis: (95.5, 0.12, 91.0, 0.40), // betonte Fläche (Formel)
    zebra: (92.0, 0.17, 89.0, 0.45), // Zebra — die kräftigste Fläche
    frame-soft: (90.0, 0.20, 82.0, 0.55), // Linie, keine Fläche
    rule: (78.0, 0.35, 70.0, 0.60), // Trenner INNERHALB einer Box
    bar-light: (92.0, 0.16, 88.0, 0.40), // Unterabschnittsbalken
    bar: (62.0, 0.75, 55.0, 0.90), // Abschnittsbalken, weisse Schrift
  )
  let pick(role) = {
    let r = roles.at(role)
    if emphatic { shade(accent, r.at(2), r.at(3)) } else { shade(accent, r.at(0), r.at(1)) }
  }

  (
    accent: accent,
    light: light-of(accent),
    // Titelfläche: hell mit dunkler Schrift — gesättigt nur, wenn sie rufen soll.
    title-back: if emphatic { accent } else { light-of(accent) },
    title-text: if emphatic { white } else { title-ink },
    // Flächen, von blass nach kräftig
    quiet: white,
    loud: pick("loud"),
    emphasis: pick("emphasis"),
    zebra: pick("zebra"),
    // Rahmen, von leicht nach hart
    frame-soft: pick("frame-soft"),
    rule: pick("rule"),
    frame-strong: if emphatic { accent } else { light-of(accent) },
    frame-hard: if emphatic { accent } else { black },
    // Balken
    bar: pick("bar"),
    bar-text: white,
    bar-light: pick("bar-light"),
    bar-light-text: shade(accent, 32, 0.55),
    // Tabellenkopf
    head-back: accent,
    head-text: white,
  )
}

// ── Die mitgelieferten Töne ──────────────────────────────────
// `chapter` ist kein fester Wert, sondern die Farbe des laufenden Kapitels;
// er wird in `structure.typ` aufgelöst.
#let neutral-tone = tone-of(rgb("#475569")) // Schiefer, für Meta-Hinweise
#let warn-tone = tone-of(danger-color, emphatic: true)

// Formel-Marker: positional innerhalb EINER Herleitung.
#let math-marks = (
  a: rgb("#00796B"), // Quelle / gegeben / erster Strang
  b: rgb("#C2410C"), // Gegenstück / abgeleitet / zweiter Strang
  c: rgb("#1D4ED8"), // Ziel / Endform / Resultat
  d: rgb("#A50D68"), // dritter paralleler Strang (sparsam)
)

// Grössenfarben: Farbe als Identität EINER Grösse über das ganze Dokument.
#let quantity-colors = (
  rgb("#B3261E"), rgb("#1D4ED8"), rgb("#0F766E"), rgb("#B45309"),
  rgb("#6D28D9"), rgb("#15803D"), rgb("#BE185D"), rgb("#334155"),
)

// ── Der Ink-Vertrag ──────────────────────────────────────────
// Frage: Was passiert mit Inline-Farbe, die auf einer bereits gefärbten Fläche
// landet? Antwort: Die Fläche, die eine eigene Textfarbe setzt, besitzt die
// Tinte — der Marker erbt sie und bleibt lesbar.
//
// Das ist hier keine gepflegte Liste von Flächen, sondern eine Ableitung: Steht
// die laufende Textfarbe nicht mehr auf der Grundfarbe, hat jemand die Fläche
// eingefärbt. Wer eine neue gefärbte Fläche baut, muss dafür nichts tun.
#let ink(color, body) = context {
  if text.fill == body-fill { text(fill: color, body) } else { body }
}
