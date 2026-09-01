// =============================================================
// structure.typ — Gliederung: Balken, Kapitelfarbe, Spaltenumbruch
// =============================================================
//
// Kapitel und Abschnitte sind normale Typst-Überschriften (`=`, `==`, `===`).
// Es gibt kein Strukturmakro mehr: Die Balken entstehen über Show-Regeln, und
// dadurch bringen Kapitel Gliederung, PDF-Lesezeichen und die Nummern für das
// Register von selbst mit.
//
// Die Kapitelfarbe ist kein Zustand, sondern eine Ableitung aus dem
// Überschriften-Zähler. Damit kann sie an keiner Stelle veralten.
//
// Die drei Ebenen sind bewusst verschieden LAUT: Kapitel gesättigt, Abschnitt
// aufgehellt, Unterabschnitt nur getönt. Drei gleich kräftige Flächen machen
// die Gliederung flacher, nicht tiefer.

#import "config.typ": conf
#import "palette.typ": tone-of, ink-faint, ink-on-accent-soft

// ── Kapitelfarbe ─────────────────────────────────────────────
// Slot 0 gehört dem Front-Matter; nummerierte Kapitel rotieren über den Rest.
#let accent-for(n, palette) = {
  if n <= 0 { palette.first() } else {
    palette.at(calc.rem(n - 1, palette.len() - 1) + 1)
  }
}

/// Die Akzentfarbe des laufenden Kapitels. Nur innerhalb von `context`.
///
/// Ein unnummeriertes Kapitel (Front-Matter) trägt Slot 0. Erkannt wird das
/// am nächstvorhergehenden Kapitel, nicht an einem Zustand: Ein Zustand
/// müsste von jedem Kapitel gepflegt werden und wäre irgendwann veraltet.
#let current-accent() = {
  let c = conf()
  let previous = query(selector(heading.where(level: 1)).before(here()))
  if previous.len() > 0 and previous.last().numbering == none {
    c.palette.first()
  } else {
    accent-for(counter(heading).get().first(), c.palette)
  }
}

/// Der Ton des laufenden Kapitels. Nur innerhalb von `context`.
#let chapter-tone() = tone-of(current-accent())

// ── Der aktive Ton ───────────────────────────────────────────
// Ein Baustein, der in einer Box steht, muss deren Ton kennen: Der Trenner in
// einer Warn-Box gehört in Warn-Rot, nicht in die Kapitelfarbe. Vorher las
// jeder verschachtelte Baustein direkt `chapter-tone()` — und `steps(tone:
// "warn")` behielt kapitelfarbene Glieder, obwohl die Box rot war.
//
// Ein Stapel statt eines einzelnen Werts, weil Boxen ineinander stehen. Die
// Klammer setzt `panel`; alles dazwischen liest nur.
#let tone-stack = state("zsf-tone", ())

/// Der Ton, in dem gerade gesetzt wird — die umgebende Box oder das Kapitel.
#let active-tone() = {
  let s = tone-stack.get()
  if s.len() > 0 { s.last() } else { chapter-tone() }
}

// ── Balken ───────────────────────────────────────────────────
// Ein Balken klebt an seinem Inhalt (`sticky`). Damit entfällt die gesamte
// Reserve- und Penalty-Mechanik des Vorgängers: Es gibt keinen Zustand
// "Balken wartet auf den ersten Block" und keinen Schwellwert, ab dem eine
// Spalte vorzeitig umbricht.
// Volle Textkanten: Typsts Vorbelegung begrenzt eine Zeile auf Versalhöhe bis
// Grundlinie. Für Fliesstext ist das richtig (enge Zeilen), für eine Fläche
// nicht — Unterlängen ragten sonst in die untere Polsterung, und ein direkt
// folgender Block sässe auf der Grundlinie des vorigen.
#let full-edges(body) = {
  set text(top-edge: "ascender", bottom-edge: "descender")
  body
}

#let _bar(fill: none, size: 1em, color: black, radius: 0pt, pad: 0pt, body) = block(
  sticky: true,
  width: 100%,
  fill: fill,
  radius: radius,
  inset: pad,
  full-edges(text(size: size, weight: "bold", fill: color, body)),
)

// Die Nummer trägt einen Punkt und etwas Luft: »1.« und »1.1.«, nicht »1«.
#let _num(it) = if it.numbering != none {
  counter(heading).display(it.numbering) + h(0.5em)
}

#let chapter-bar(it) = context {
  let c = conf()
  let accent = if it.numbering == none { c.palette.first() } else { current-accent() }
  block(
    above: c.bar.above-chapter,
    below: c.bar.below,
    _bar(
      fill: accent,
      color: white,
      radius: c.radius,
      size: c.font-size.chapter,
      pad: (x: c.bar.pad-x, y: c.bar.pad-y),
      // Die Fläche setzt eine eigene Textfarbe und besitzt damit die Tinte
      // (siehe palette.typ → Ink-Vertrag). Ein Verweis im Titel bleibt lesbar.
      [#_num(it)#it.body],
    ),
  )
}

#let section-bar(it) = context {
  let c = conf()
  let t = chapter-tone()
  block(
    above: c.bar.above-section,
    below: c.bar.below,
    _bar(
      fill: t.bar,
      color: t.bar-text,
      radius: c.radius,
      size: c.font-size.section,
      pad: (x: c.bar.pad-x, y: c.bar.pad-y),
      [#_num(it)#it.body],
    ),
  )
}

#let subsection-bar(it) = context {
  let c = conf()
  let t = chapter-tone()
  block(
    above: c.bar.above-subsection,
    below: c.bar.below-subsection,
    _bar(
      fill: t.bar-light,
      color: t.bar-light-text,
      radius: c.radius,
      size: c.font-size.subsection,
      pad: (x: c.bar.pad-x, y: c.bar.pad-y * 0.8),
      [#_num(it)#it.body],
    ),
  )
}

/// Ein unnummeriertes Kapitel (Front-Matter, Register). Trägt Slot 0.
///
/// Ein Front-Kapitel hat keine Abschnittsnummer, auf die ein Registereintrag
/// zeigen könnte. `short` vergibt den Kurz-Wegweiser, der im Register an ihrer
/// Stelle erscheint — ohne ihn nimmt das Register den vollen Titel.
///
/// `anchor` nimmt das Verweisziel entgegen: `#front("Zeichen", anchor: <ze>)`.
/// Ein Label DANEBEN zu setzen genügt nicht — es hinge an der Marke vor der
/// Überschrift, und `xref` läse dort die Nummer des vorigen Kapitels ab.
#let front(title, short: auto, anchor: none) = {
  // Die Marke steht VOR der Überschrift, damit ein Verweis, der auf die
  // Überschrift selbst zeigt, sie noch findet.
  [#metadata(if short == auto { title } else { short })#label("zsf-front-label")]
  let h = heading(numbering: none, level: 1, title)
  if anchor == none { h } else { [#h#anchor] }
}

// ── Wohin ein Verweis zeigt ──────────────────────────────────
/// Beschreibt das Ziel an `loc`: Abschnittsnummer und Kapitelfarbe — oder,
/// wenn das Ziel in einem Front-Kapitel liegt, dessen Kurzlabel.
///
/// Die beiden Fälle stehen zusammen, weil sonst nur einer gepflegt wird: Das
/// Register kannte das Front-Kapitel, `xref` nicht. Ein Verweis dorthin nannte
/// still die Nummer des VORHERGEHENDEN Kapitels — falsch, ohne Meldung.
#let ref-target(loc) = {
  let c = conf()
  let heads = query(selector(heading.where(level: 1)).before(loc))
  if heads.len() > 0 and heads.last().numbering == none {
    let labels = query(selector(<zsf-front-label>).before(loc))
    return (
      body: if labels.len() > 0 { labels.last().value } else { heads.last().body },
      accent: c.palette.first(),
    )
  }
  let nums = counter(heading).at(loc)
  (body: nums.map(str).join("."), accent: accent-for(nums.first(), c.palette))
}

/// Bewusster Spaltenumbruch. Der einzige im System.
#let newcol() = colbreak(weak: false)

// ── Dokumentkopf ─────────────────────────────────────────────
// Steht IM Spaltenfluss und ist deshalb eine Spalte breit — nicht über die
// ganze Seite. Er ist der erste Block der ersten Spalte, kein Seitenkopf.
#let doc-header(title, author) = context {
  let c = conf()
  block(
    above: 0pt,
    below: c.space.m,
    sticky: true,
    width: 100%,
    fill: c.palette.first(),
    radius: c.radius,
    inset: (x: c.bar.pad-x, y: c.pad.y),
    {
      set align(center)
      set par(justify: false)
      block(above: 0pt, below: 0pt, full-edges(text(
        size: c.font-size.doc-title,
        weight: "bold",
        fill: white,
        title,
      )))
      if author != "" {
        block(above: c.space.xs, below: 0pt, text(
          size: c.font-size.note,
          style: "italic",
          fill: ink-on-accent-soft,
        )[von #author])
      }
    },
  )
}

// ── Seitenfuss ───────────────────────────────────────────────
// Kennung mittig, Seitenzahl rechts — beide gedämpft, damit sie im
// Prüfungsstress nicht mit Inhalt verwechselt werden.
#let page-footer(release) = context {
  let c = conf()
  set text(size: c.font-size.footer, fill: ink-faint)
  grid(
    columns: (1fr, auto, 1fr),
    align: (left, center, right),
    [],
    release,
    counter(page).display(),
  )
}
