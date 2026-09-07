// =============================================================
// markup.typ — Inline-Marker und Verweise
// =============================================================
//
// Inline-Betonung trägt keine Farbe: Ein eingefärbtes Wort stört den Absatz
// und sagt nichts, was die Seite nicht ohnehin zeigt. Farbe ist für drei
// andere Dinge reserviert — Kapitel-Identität auf Flächen, den Wegweiser zum
// Ziel eines Verweises, und die Zuordnung in Formeln.
//
// Alles Farbtragende geht durch `ink` und verliert die Farbe automatisch,
// sobald es auf einer Fläche steht, die ihre eigene Textfarbe setzt.

#import "config.typ": conf
#import "palette.typ": ink, danger-color, math-marks, quantity-colors, tone-of, ink-faint
#import "structure.typ": accent-for, ref-target
#import "index.typ": idx

// Der Registereintrag braucht den Begriff als Text; Auszeichnung bleibt im
// Satz, nicht im Register. Gelesen wird der ganze Baum, nicht nur die oberste
// Ebene: `kw[Satz von *Taylor*]` ist keine Textzelle, sondern eine Sequenz aus
// Text, Leerraum und `strong` — die frühere Fassung fand dort nichts und liess
// den Eintrag ersatzlos weg. Ohne Meldung, in genau dem Baustein, an dem das
// Register hängt.
#let _space = [ ].func()
#let _wrappers = (strong, emph, underline, overline, super, sub, highlight, link)

#let _plain(c) = {
  if type(c) == str { return c }
  if type(c) != content { return none }
  let f = c.func()
  if f == text { return c.text }
  if f in (_space, linebreak) { return " " }
  if c.has("children") {
    let parts = c.children.map(_plain)
    // Ein einziges unlesbares Kind macht die ganze Lesung falsch: Aus
    // `kw[$C^1$-Funktion]` würde sonst der Eintrag »-Funktion«, und ein
    // falscher Eintrag ist schlechter als eine Fehlermeldung.
    if parts.any(p => p == none) { return none }
    return parts.join("")
  }
  if f in _wrappers and c.has("body") { return _plain(c.body) }
  none
}

/// Fachbegriff — der primäre Scan-Anker. Landet automatisch im Register.
///
/// - `index: false` für den Begriff, der nicht ins Register soll
/// - `term`: die Registerform, wenn der Satz sie nicht hergibt
///   (`kw(term: "C¹-Funktion")[$C^1$-Funktion]`)
/// - `sort`: abweichender Sortierschlüssel
#let kw(body, index: true, term: none, sort: none) = {
  if index {
    let plain = if term != none { term } else { _plain(body) }
    if plain == none {
      panic(
        "kw: dieser Begriff lässt sich nicht als Text für das Register lesen "
          + "(Formel, Bild oder Ähnliches im Begriff). Registerform angeben — "
          + "kw(term: \"…\")[…] — oder mit kw(index: false)[…] darauf verzichten.",
      )
    }
    idx(plain, sort: sort)
  }
  strong(body)
}

/// Neutrale Beschriftung ohne Fachbegriff-Semantik. Kein Registereintrag.
#let lbl(body) = strong(body)

/// Stolperfalle als Inline-Pille.
#let danger(body) = context {
  let c = conf()
  box(
    fill: tone-of(danger-color).emphasis,
    radius: c.radius * 0.7,
    inset: (x: 0.3em, y: 0.15em),
    outset: (y: 0.15em),
    text(fill: danger-color, weight: "bold", size: 0.95em, body),
  )
}

/// Leitet eine Folgerung ein.
#let concl(body) = [#sym.arrow.double.r #body]

/// Die prüfungskritischste Aussage einer Box. Sparsam — sonst flacht das Signal ab.
#let hl(body) = underline(offset: 0.15em, stroke: 0.06em, strong(body))

/// Beschriftung innerhalb einer Zeichnung — die kalibrierte Grösse, damit im
/// Kapitel kein lokales `#text(size: …)` entsteht. Für eine ganze cetz-Zeichnung
/// einmal als deren `font`-Option setzen.
#let diagram-label(body) = context text(size: conf().font-size.label, body)

// ── Verweise ─────────────────────────────────────────────────
// Ein Verweis ins Leere ist ein Fehler, kein rotes Fragezeichen im PDF —
// im Vorgänger brauchte es dafür einen eigenen Verifier.
#let _target(label-name) = {
  let hits = query(label-name)
  if hits.len() == 0 {
    panic("Verweisziel " + repr(label-name) + " gibt es nicht.")
  }
  // Ein Ziel im Front-Matter hat keine Nummer; `ref-target` liefert dann
  // dessen Kurzlabel. Beide Verweisformen teilen sich das mit dem Register —
  // getrennt gepflegt kannte nur das Register den Fall, und `xref` nannte
  // still die Nummer des vorhergehenden Kapitels.
  ref-target(hits.first().location())
}

/// Querverweis »(→ 6.6)« in der Farbe des Zielkapitels.
#let xref(target) = context {
  let d = _target(target)
  link(target, ink(d.accent, [(#sym.arrow.r #d.body)]))
}

/// Kompakte, klickbare Zielnummer ohne Pfeil — für lokale Inhaltsübersichten.
///
/// Kebab-Schreibweise wie `script-ref`: Typst empfiehlt sie für mehrteilige
/// Namen, und eine API, in der die eine Verweisform getrennt und die andere
/// zusammengeschrieben wird, muss man sich merken statt sie zu erraten.
/// `xref` bleibt als feststehender Begriff einteilig.
#let sec-ref(target) = context {
  let d = _target(target)
  link(target, ink(d.accent, d.body))
}

/// Verweis auf die Skript-Seite.
#let script-ref(page) = context text(
  size: conf().font-size.note,
  fill: ink-faint,
)[(S.#page)]

// ── Formel-Marker ────────────────────────────────────────────
// Positional innerhalb EINER Herleitung. Nur einsetzen, wenn die farbliche
// Verbindung fachlich eindeutig stimmt — nicht zur Dekoration.
//
// Namen in Grossbuchstaben statt `mark-a`, weil im Mathe-Modus ein Bindestrich
// ein Minuszeichen ist: `$mark-a(x)$` läse sich als `mark - a(x)`.
#let markA(body) = ink(math-marks.a, body) // Quelle / gegeben / erster Strang
#let markB(body) = ink(math-marks.b, body) // Gegenstück / abgeleitet / zweiter Strang
#let markC(body) = ink(math-marks.c, body) // Ziel / Endform / Resultat
#let markD(body) = ink(math-marks.d, body) // dritter paralleler Strang (sparsam)

/// Grössenfarbe: eine Farbe gehört im ganzen Dokument EINER Grösse.
/// Vergabe in `zsf(quantities: ("Kraft": 0, "Moment": 4))`.
#let quantity(name, body) = context {
  let c = conf()
  if name not in c.quantities {
    panic(
      "Unbekannte Grösse »" + name + "«. Vergeben in zsf(quantities: …): "
        + c.quantities.keys().join(", "),
    )
  }
  // `quantity-colors: false` nimmt für den S/W-Druck die Farbe zurück, ohne
  // die Vergabe anzutasten — der Satz bleibt sonst Zeichen für Zeichen gleich.
  if not c.quantity-colors { return body }
  // Kein `calc.rem` mehr: Es liess einen Slot ausserhalb der Liste lautlos auf
  // einen fremden rutschen. Bereich und Eindeutigkeit prüft `zsf()` einmal am
  // Dokumentkopf, wo die Vergabe steht.
  ink(quantity-colors.at(c.quantities.at(name)), body)
}
