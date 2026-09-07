// =============================================================
// tests/unit.typ — Zusicherungen über die reinen Funktionen
// =============================================================
//
// Kompiliert = bestanden. Was Typst schon selbst prüft (unbekannte Argumente,
// falsche Typen, fehlende Verweisziele), steht hier bewusst NICHT: Der
// Vorgänger brauchte dafür einen 1064-zeiligen Verifier, weil LaTeX beides
// stillschweigend annahm.

#import "../src/palette.typ": seeds, tone-of, light-of, neutral-tone, warn-tone, ink-muted, ink-faint, ink-ghost
#import "../src/structure.typ": accent-for
#import "../src/index.typ": sort-key, symbol-prefix
#import "../src/config.typ": defaults, derive
#import "../src/readability.typ": unit-pattern

// ── Sortierung nach DIN 5007-1 ───────────────────────────────
#assert.eq(sort-key("Übung"), "ubung")
#assert.eq(sort-key("Öffnung"), "offnung")
#assert.eq(sort-key("Ähnlichkeit"), "ahnlichkeit")
#assert.eq(sort-key("Straße"), "strasse")
#assert.eq(sort-key("Céline"), "celine")
// Zeichen ausserhalb von Buchstaben und Ziffern fallen weg, damit
// »C¹-Funktion« bei C einsortiert und nicht bei einem Sonderzeichen.
#assert.eq(sort-key("C¹-Funktion"), "cfunktion")
#assert.eq(sort-key("L²-Norm"), "lnorm")
// Umlaute sortieren zwischen ihren Nachbarn, nicht ans Ende.
#assert(sort-key("Ähnlich") < sort-key("Algebra"))
#assert(sort-key("Zähler") > sort-key("Wurzel"))

// Ein Begriff, der NUR aus Zeichen besteht, behielte nach dem Abräumen einen
// leeren Schlüssel — und fiel damit stillschweigend aus dem Register. Gerade
// Einheiten und Symbole sind aber die wertvollsten Einträge (`30_struktur`).
#for s in ("Ω", "∇", "∂", "→", "∑") {
  assert(sort-key(s).trim() != "", message: "Symbol verliert seinen Schlüssel: " + s)
  assert(sort-key(s).starts-with(symbol-prefix), message: "Symbol nicht als solches erkannt: " + s)
  // Und sie stehen als Gruppe vor dem Alphabet, nicht verstreut dahinter.
  assert(sort-key(s) < sort-key("Ableitung"))
}
// Ein Begriff mit Buchstaben bleibt ein normaler Eintrag, auch mit Zeichen darin.
#assert(not sort-key("C¹-Funktion").starts-with(symbol-prefix))

// ── Kapitelfarben ────────────────────────────────────────────
// Slot 0 gehört dem Front-Matter und wird von keinem Kapitel belegt.
#assert.eq(accent-for(0, seeds), seeds.at(0))
#assert.eq(accent-for(1, seeds), seeds.at(1))
#assert.eq(accent-for(17, seeds), seeds.at(17))
// Nach dem letzten Slot rotiert es — aber nie zurück auf Slot 0.
#assert.eq(accent-for(18, seeds), seeds.at(1))
#for n in range(1, 60) {
  assert(accent-for(n, seeds) != seeds.at(0), message: "Slot 0 ist reserviert")
}
// Benachbarte Kapitel müssen unterscheidbar bleiben (Abstand 1 und 2).
#for n in range(1, 40) {
  assert(accent-for(n, seeds) != accent-for(n + 1, seeds))
  assert(accent-for(n, seeds) != accent-for(n + 2, seeds))
}

// ── Ton-Ableitung ────────────────────────────────────────────
// Jede Rolle ist in jedem Ton besetzt. Im Vorgänger war das eine Zusage über
// 21 handgepflegte Farbtokens pro Ton; hier folgt es aus der Ableitung.
#let roles = (
  "accent",
  "light",
  "title-back",
  "title-text",
  "quiet",
  "loud",
  "emphasis",
  "zebra",
  "frame-soft",
  "rule",
  "frame-strong",
  "frame-hard",
  "bar",
  "bar-text",
  "bar-light",
  "bar-light-text",
  "head-back",
  "head-text",
)

#let L = c => oklch(c).components().at(0) / 1%
// Kontrast als Helligkeitsabstand in OKLCH. Kein WCAG-Ersatz, aber es fängt
// genau den Fehler, der hier auftreten kann: Schrift auf einer Fläche, die
// ihr zu nahe liegt.
#let contrast(fg, bg) = calc.abs(L(fg) - L(bg))

#for accent in seeds + (neutral-tone.accent,) {
  for t in (tone-of(accent), tone-of(accent, emphatic: true)) {
    for r in roles {
      assert(r in t, message: "Rolle " + r + " fehlt im Ton " + repr(accent))
    }

    // Jede Schrift muss auf ihrer Fläche tragen.
    assert(
      contrast(t.title-text, t.title-back) > 40,
      message: "Box-Titel zu kontrastarm: " + repr(accent),
    )
    // Der Abschnittsbalken ist bewusst die leisere Stufe; sein Kontrast liegt
    // darum unter dem des Kapitelbalkens, aber für jeden Slot gleich hoch.
    assert(
      contrast(t.bar-text, t.bar) > 34,
      message: "Abschnittsbalken zu kontrastarm: " + repr(accent),
    )
    assert(
      contrast(t.bar-light-text, t.bar-light) > 40,
      message: "Unterabschnitt zu kontrastarm: " + repr(accent),
    )
    assert(
      contrast(t.head-text, t.head-back) > 42,
      message: "Tabellenkopf zu kontrastarm: " + repr(accent),
    )
    assert(
      contrast(white, t.accent) > 42,
      message: "Kapitelbalken zu kontrastarm: " + repr(accent),
    )

    // Jede Inhaltsfläche muss schwarzen Fliesstext tragen.
    for surface in (t.quiet, t.loud, t.emphasis, t.zebra) {
      assert(L(surface) > 87, message: "Fläche zu dunkel für Fliesstext: " + repr(accent))
    }

    // Die Flächen sind gestuft: die laute Fläche ist die blasseste, das Zebra
    // die kräftigste — sonst verschwindet der Streifen in der Zeile.
    assert(L(t.loud) > L(t.emphasis), message: "loud muss blasser sein als emphasis")
    assert(L(t.emphasis) > L(t.zebra), message: "emphasis muss blasser sein als zebra")

    // Der Rahmen wird von leicht nach hart dunkler. Im emphatischen Ton fallen
    // strong und hard bewusst zusammen — dort ist der Akzent selbst die Kante.
    assert(L(t.frame-soft) > L(t.frame-strong), message: "soft muss heller sein als strong")
    assert(L(t.frame-strong) >= L(t.frame-hard), message: "strong darf nicht dunkler sein als hard")
  }
}

// Und alle Abschnittsbalken tragen denselben Kontrast, egal welcher Slot.
#for accent in seeds {
  assert(calc.abs(L(tone-of(accent).bar) - 62) < 0.6)
}
// Dasselbe für jede getönte Fläche: gleiche Helligkeit über alle Slots.
#for (role, want) in (loud: 98.5, emphasis: 95.5, zebra: 92.0, bar-light: 92.0) {
  for accent in seeds {
    assert(
      calc.abs(L(tone-of(accent).at(role)) - want) < 0.6,
      message: "Fläche »" + role + "« weicht ab bei " + repr(accent),
    )
  }
}

// Die Aufhellung hält für JEDEN Akzent dieselbe Helligkeit — das ist der Grund,
// warum ein dunkler und ein heller Slot gleich stark getönte Flächen ergeben.
#for accent in seeds {
  assert(calc.abs(L(light-of(accent)) - 88.5) < 0.6)
}

// ── Abgeleitete Masse ────────────────────────────────────────
#let base = derive(defaults)
// Die Skala ist geordnet, nicht bloss vorhanden.
#assert(base.space.xs < base.space.s)
#assert(base.space.s < base.space.m)
#assert(base.space.m < base.space.l)
#assert(base.pad.y-tight < base.pad.y)
#assert(base.pad.x-tight < base.pad.x)
#assert(base.cell.y-tight < base.cell.y)
#assert(base.cell.y < base.cell.y-roomy)
#assert(base.font-size.dense < base.font-size.body)
#assert(base.font-size.body < base.font-size.chapter)
#assert(base.font-size.note < base.font-size.body)

// Die Dichte greift auf alles Vertikale — und nur darauf.
#let dense = derive(defaults + (density: 0.5))
#assert(dense.space.m < base.space.m, message: "density muss die Abstände treffen")
#assert(dense.pad.y < base.pad.y)
#assert(dense.cell.y < base.cell.y)
#assert.eq(dense.font-size.body, base.font-size.body)
#assert.eq(dense.gutter, base.gutter)

// Die Grundgrösse nimmt Schrift UND Masse mit, die Verhältnisse bleiben.
#let big = derive(defaults + (size: 12pt))
#assert(big.font-size.body > base.font-size.body)
#assert(big.space.m > base.space.m)
#assert.eq(
  big.font-size.chapter / big.font-size.body,
  base.font-size.chapter / base.font-size.body,
)

// Ein Bereichsfaktor trifft seinen Bereich und sonst nichts.
#let boxy = derive(defaults + (density-blocks: 0.5))
#assert(boxy.pad.x < base.pad.x)
#assert.eq(boxy.cell.y, base.cell.y)
#assert.eq(boxy.par-space, base.par-space)

// Ein Bereichsfaktor trifft seinen Bereich und sonst nichts — auch der neue:
// Vorher hingen die Balken am Block-Register, und »Boxen enger« rückte
// stillschweigend auch die Überschriften an ihren Text.
#let structy = derive(defaults + (density-structure: 0.5))
#assert(structy.bar.pad-y < base.bar.pad-y)
#assert(structy.bar.above-section < base.bar.above-section)
#assert.eq(structy.pad.x, base.pad.x)
#assert.eq(structy.cell.y, base.cell.y)
#assert.eq(boxy.bar.pad-y, base.bar.pad-y)

// Die zwei Rollen-Faktoren sind Gegenstücke und dürfen einander nicht
// mitziehen — und keiner von beiden die Balken.
#let inhalt = derive(defaults + (content-scale: 0.8))
#let prosa = derive(defaults + (prose-scale: 0.8))
#assert(inhalt.font-size.body < base.font-size.body)
#assert(inhalt.font-size.dense < base.font-size.dense)
#assert.eq(inhalt.font-size.prose, base.font-size.prose)
#assert(prosa.font-size.prose < base.font-size.prose)
#assert.eq(prosa.font-size.body, base.font-size.body)
#for f in (inhalt, prosa) {
  assert.eq(f.font-size.chapter, base.font-size.chapter)
  assert.eq(f.font-size.section, base.font-size.section)
  assert.eq(f.font-size.title, base.font-size.title)
  assert.eq(f.font-size.tag, base.font-size.tag)
}
// Anmerkung und Diagramm-Beschriftung stehen IN einem Baustein: Sie folgen
// `content-scale` und bleiben dabei kleiner als der Inhalt, neben dem sie
// stehen. Vorher hingen sie an der blossen Grundgrösse — bei
// `content-scale: 0.75` war die Anmerkung unter einer Formel die grösste
// Schrift der Box.
#for f in (base, inhalt, derive(defaults + (content-scale: 1.4))) {
  assert(f.font-size.note < f.font-size.body, message: "note muss unter body bleiben")
  assert(f.font-size.label < f.font-size.note, message: "label muss unter note bleiben")
}
#assert(inhalt.font-size.note < base.font-size.note)
#assert(inhalt.font-size.label < base.font-size.label)

// Code ist ein Verhältnis, keine Grösse: Als absolutes Mass an `dense` gebunden
// war Inline-Code im Fliesstext bei kleiner Prosa grösser als sie. Als Faktor
// gilt er in jeder Umgebung und ändert sich mit keinem Rollen-Faktor.
#assert(base.mono-scale < 1.0)
// Die Autorenzeile des Dokumentkopfs steht auf einer Titelfläche und gehört
// damit zu den Balken: Sie darf sich von keinem Rollen-Faktor mitziehen lassen.
#for f in (inhalt, prosa) {
  assert.eq(f.font-size.header-note, base.font-size.header-note)
}
#assert(base.font-size.header-note < base.font-size.doc-title)
#for f in (inhalt, prosa, derive(defaults + (size: 6pt))) {
  assert.eq(f.mono-scale, base.mono-scale, message: "mono-scale ist ein Verhältnis")
}

// Gedämpfte Tinte: drei Stufen, unterscheidbar und in dieser Reihenfolge.
// Vorher waren es sieben Grauwerte über fünf Dateien — 40 und 45 % lagen so
// nah beieinander, dass der Unterschied keine Bedeutung mehr trug.
#assert(L(ink-muted) < L(ink-faint))
#assert(L(ink-faint) < L(ink-ghost))
#assert(L(ink-faint) - L(ink-muted) > 10)
#assert(L(ink-ghost) - L(ink-faint) > 10)

// ── Zahl-Einheit-Bindung ─────────────────────────────────────
// Die Wortgrenze ist der ganze Trick der Regel; ohne sie band sie auch
// »1 Fliesstext« zu »1 Fli«. Beide Richtungen werden hier festgehalten.
#let binds(s) = s.match(regex(unit-pattern)) != none

// Was gebunden gehört: SI-Symbole, Prozent, Grad, Bruch-Einheiten, Dezimal-
// zahlen mit Punkt wie mit Komma.
#for s in (
  "10 m", "10 m/s", "95 %", "20 °C", "1.5 kg", "2,5 kN", "50 mm",
  "2 MPa", "7 Hz", "3 N/mm", "0,3 s",
) {
  assert(binds(s), message: "sollte binden: " + s)
}

// Was NICHT gebunden gehört: Zahl vor einem gewöhnlichen Wort. Drei Buchstaben
// passen auf jeden Wortanfang — erst die Wortgrenze trennt »kg« von »Fäl«.
#for s in ("1 Fliesstext", "3 Fälle", "12 Beispiele", "5 Zeilen", "2 Spalten") {
  assert(not binds(s), message: "sollte nicht binden: " + s)
}

// Kein Leerzeichen, keine Bindung — und ein Punkt ist kein Dezimaltrenner,
// wenn keine Ziffer folgt (»am 3. Mai«).
#assert(not binds("7pt"))
#assert(not binds("3. Mai"))

// Bildhöhen sind Inhalt und folgen der Dichte nicht.
#assert.eq(dense.image-height, base.image-height)
#assert(base.image-height < base.figure-height)

// ── Abstandsskala ───────────────────────────────────────────
// Die vier Stufen sind echt gestaffelt: xs < s < m < l
#assert(base.space.xs < base.space.s)
#assert(base.space.s < base.space.m)
#assert(base.space.m < base.space.l)

Alle Zusicherungen erfüllt.
