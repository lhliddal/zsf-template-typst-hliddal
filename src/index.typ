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
//
// Ein Begriff, der NUR aus solchen Zeichen besteht — »Ω«, »∇«, »∂« —, behielte
// dabei einen leeren Schlüssel und fiel vorher stillschweigend aus dem
// Register. Ausgerechnet Einheiten und Symbole nennt `30_struktur` als den
// grössten Hebel des Registers. Sie bekommen deshalb ihren Schlüssel aus dem
// Begriff selbst, mit führendem Leerzeichen: Es sortiert vor jedem Buchstaben
// und ist zugleich das Kennzeichen, an dem das Register sie zur Gruppe
// »Symbole« zusammenfasst.
#let symbol-prefix = " "

#let sort-key(s) = {
  let out = lower(s)
  for (from, to) in (("ä", "a"), ("ö", "o"), ("ü", "u"), ("ß", "ss"), ("é", "e"), ("è", "e"), ("à", "a")) {
    out = out.replace(from, to)
  }
  let plain = out.replace(regex("[^a-z0-9 ]"), "")
  if plain.trim() == "" { symbol-prefix + out } else { plain }
}

// Ein leerer Begriff kann nichts adressieren und wäre im Register unsichtbar —
// derselbe stille Fehlschlag wie oben, nur eine Stufe früher.
#let _check-term(term) = {
  if type(term) != str or term.trim() == "" {
    panic("Registereintrag ohne Begriff: " + repr(term))
  }
}

/// Unsichtbarer Registereintrag.
/// - `sort`: abweichender Sortierschlüssel (flektierte Form auf das Lemma bringen)
#let idx(term, sort: none) = {
  _check-term(term)
  [#metadata((
      term: term,
      key: sort-key(if sort == none { term } else { sort }),
      see: none,
    ))#_mark]
}

/// Verweis-Eintrag: »Synonym, siehe Ziel«. Am kanonischen Ort des Ziels setzen.
#let idx-see(term, target, sort: none) = {
  _check-term(term)
  _check-term(target)
  [#metadata((
      term: term,
      key: sort-key(if sort == none { term } else { sort }),
      see: target,
    ))#_mark]
}

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
    let bucket = grouped.at(k, default: (term: v.term, see: v.see, locs: ()))
    if v.see != none { bucket.see = v.see }
    bucket.locs.push(e.location())
    grouped.insert(k, bucket)
  }

  let keys = grouped.keys().sorted()
  let current-letter = ""

  // Zweimal derselbe Abschnitt ist keine zweite Fundstelle. Wer einen Begriff
  // in einem Abschnitt zweimal markiert, bekam vorher »5.3, 5.3« — Zeichen,
  // die Platz kosten und nichts sagen. Verglichen wird die ANGEZEIGTE Nummer,
  // denn genau die ist der Sprung, den jemand macht.
  let distinct-locs(locs) = {
    let seen = ()
    let out = ()
    for l in locs {
      let d = ref-target(l)
      let shown = repr(d.body)
      if shown in seen { continue }
      seen.push(shown)
      out.push(l)
    }
    out
  }

  // Ein Registereintrag ist eine Zeile, die gegen die nächste stösst. Volle
  // Textkanten sind deshalb Pflicht: Typsts Vorbelegung endet auf der
  // Grundlinie, und die Unterlängen ragten in die Folgezeile.
  set par(justify: false, leading: 0.5em, spacing: c.space.xs)
  set text(size: c.font-size.prose, top-edge: "ascender", bottom-edge: "descender")

  for k in keys {
    let entry = grouped.at(k)
    // Symbole tragen keinen Buchstaben, an dem man sie sucht — sie stehen
    // gemeinsam vor dem Alphabet (siehe `sort-key`).
    let letter = if k.starts-with(symbol-prefix) { "Symbole" } else { upper(k.first()) }
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
        // Ein »siehe«-Eintrag hat keine eigene Nummer — aber die des Ziels.
        // Ohne sie kostet jede Abkürzung zwei Nachschlagevorgänge statt einem,
        // und Abkürzungen sind der halbe Zweck des Registers.
        text(style: "italic", fill: ink-faint)[siehe ]
        entry.see
        let target-key = sort-key(entry.see)
        let target = grouped.at(target-key, default: none)
        if target != none and target.see == none {
          h(0.35em)
          distinct-locs(target.locs).map(_locator).join([, ])
        }
      } else {
        let locs = distinct-locs(entry.locs)
        locs.map(_locator).join([, ])
        // Die Druckseite nur bei genau einer Fundstelle: bei mehreren ist der
        // Abschnitt der schnellere Weg, und zwei Zahlenpaare lesen sich schlecht.
        if c.index-pages and locs.len() == 1 {
          text(fill: ink-faint, size: c.quiet-scale * 1em)[ · S.#locs.first().page()]
        }
      }
    })
  }
}
