// =============================================================
// index.typ — Stichwortverzeichnis
// =============================================================
//
// Ziel: in wenigen Sekunden von einem Wort, das einem in der Prüfung einfällt,
// an die Stelle, wo das Nutzbare steht. Deshalb zeigt ein Eintrag auf die
// ABSCHNITTSNUMMER in der Farbe des Zielkapitels — die Seitenzahl allein sagt
// nicht, wohin man auf der Seite schauen muss.
//
// Kein Fremdpaket und kein externer Indexer: Der Eintrag ist ein Metadatum,
// das Register eine Abfrage darüber. Umlaute sortieren nach DIN 5007-1.

#import "config.typ": conf
#import "structure.typ": ref-target
#import "palette.typ": ink-muted, ink-faint, ink-ghost

#let _mark = <zsf-index-entry>

// ── Sortierschlüssel ─────────────────────────────────────────
// DIN 5007-1: ä wie a, ö wie o, ü wie u, ß wie ss. Zeichen ausserhalb von
// Buchstaben und Ziffern fallen weg, damit »C¹-Funktion« bei C einsortiert.
#let sort-key(s) = {
  let out = lower(s)
  for (from, to) in (("ä", "a"), ("ö", "o"), ("ü", "u"), ("ß", "ss"), ("é", "e"), ("è", "e"), ("à", "a")) {
    out = out.replace(from, to)
  }
  out.replace(regex("[^a-z0-9 ]"), "")
}

/// Unsichtbarer Registereintrag.
/// - `sort`: abweichender Sortierschlüssel (flektierte Form auf das Lemma bringen)
#let idx(term, sort: none) = [
  #metadata((
    term: term,
    key: sort-key(if sort == none { term } else { sort }),
    see: none,
  ))#_mark
]

/// Verweis-Eintrag: »Synonym, siehe Ziel«. Am kanonischen Ort des Ziels setzen.
#let idx-see(term, target, sort: none) = [
  #metadata((
    term: term,
    key: sort-key(if sort == none { term } else { sort }),
    see: target,
  ))#_mark
]

// ── Das Register ─────────────────────────────────────────────
// Der Locator ist derselbe, den `xref` benutzt — Abschnittsnummer, oder das
// Kurzlabel eines Front-Kapitels. Er steht in `structure.typ`, damit Register
// und Verweis nicht auseinanderlaufen können.
#let _locator(loc) = {
  let d = ref-target(loc)
  text(fill: d.accent, weight: "bold", d.body)
}

/// Setzt das Register. Gehört ans Dokumentende, unter ein `front`-Kapitel.
#let make-index() = context {
  let c = conf()
  let raw-entries = query(_mark)

  // Nach Begriff bündeln: ein Wort, eine Zeile, mehrere Fundstellen.
  let grouped = (:)
  for e in raw-entries {
    let v = e.value
    let k = v.key
    if k == "" { continue }
    let bucket = grouped.at(k, default: (term: v.term, see: v.see, locs: ()))
    if v.see != none { bucket.see = v.see }
    bucket.locs.push(e.location())
    grouped.insert(k, bucket)
  }

  let keys = grouped.keys().sorted()
  let current-letter = ""

  // Ein Registereintrag ist eine Zeile, die gegen die nächste stösst. Volle
  // Textkanten sind deshalb Pflicht: Typsts Vorbelegung endet auf der
  // Grundlinie, und die Unterlängen ragten in die Folgezeile.
  set par(justify: false, leading: 0.5em, spacing: c.space.xs)
  set text(size: c.font-size.prose, top-edge: "ascender", bottom-edge: "descender")

  for k in keys {
    let entry = grouped.at(k)
    let letter = upper(k.first())
    if letter != current-letter {
      current-letter = letter
      block(
        above: c.space.m,
        below: c.space.xs,
        sticky: true,
        text(weight: "bold", fill: ink-faint, size: c.font-size.body, letter),
      )
    }

    block(breakable: false, above: c.space.xs, below: c.space.xs, {
      entry.term
      h(0.35em)
      box(width: 1fr, repeat(gap: 0.22em, text(fill: ink-ghost)[.]))
      h(0.35em)
      if entry.see != none {
        // Ein »siehe«-Eintrag trägt keine eigene Nummer — er schickt weiter.
        text(style: "italic", fill: ink-faint)[siehe ]
        entry.see
      } else {
        let locs = entry.locs
        locs.map(_locator).join([, ])
        // Die Druckseite nur bei genau einer Fundstelle: bei mehreren ist der
        // Abschnitt der schnellere Weg, und zwei Zahlenpaare lesen sich schlecht.
        if c.index-pages and locs.len() == 1 {
          text(fill: ink-faint, size: c.font-size.note)[ · S.#locs.first().page()]
        }
      }
    })
  }
}
