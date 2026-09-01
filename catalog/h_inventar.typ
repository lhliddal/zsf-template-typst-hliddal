#import "@local/zsf:0.1.0": *
#import "tools.typ": zweck

#newcol()
= Inventar <kat:inventar>

Der visuelle Teil (B–G) zeigt, *wie* etwas aussieht. Diese Sektion zeigt, *was*
es ist, *wo* es lebt und *was Streichen kostet* — die Fragen, die unmittelbar
auf die Entscheidung folgen.

Alles hier wird beim Bauen gelesen: die Namen aus `lib.typ`, die Stellschrauben
aus `src/config.typ`, die IDs aus den Einträgen selbst. Die Liste kann deshalb
nicht veralten — im Vorgänger war sie von Hand nachgeführt.

== Drei Arten von Eingriff <kat:arten>

#facts[Was ein »weg damit« kostet][
  - #item[Baustein][Eigener Name, erzeugt einen Block. Streichen heisst: Name
    weg, vorhandene Aufrufe auf einen anderen Baustein umstellen.]
  - #item[Marker][Inline-Auszeichnung. Streichen heisst: Aufrufe ersetzen, der
    Satz bleibt stehen.]
  - #item[Reglerwert][Ein Zweig in `panel`. Streichen heisst: der Wert
    entfällt, die Vorbelegung bleibt — kein Aufruf verliert seine Box.]
]
#zweck("H-00", none)[Die Unterscheidung entscheidet, was ein Streichen überhaupt kostet.]

// ── Die Quellen ──────────────────────────────────────────────
#let art = (
  structure: "Struktur",
  blocks: "Baustein",
  tables: "Baustein",
  media: "Bild",
  markup: "Marker",
  maths: "Formel",
  index: "Register",
  palette: "Farbe",
)

#let exporte = {
  let out = ()
  for line in read("/lib.typ").split("\n") {
    let m = line.match(regex(`^#import "src/([a-z]+)\.typ": (.+)$`.text))
    if m == none { continue }
    let modul = m.captures.at(0)
    let namen = m.captures.at(1)
    if namen.contains(" as _") { continue }

    // Ein Stern-Import nennt keine Namen — dann werden sie aus dem Modul
    // selbst gelesen. Sonst fehlten die Mathe-Operatoren in dieser Liste,
    // und genau das wäre die Art Lücke, gegen die der Katalog gebaut ist.
    if namen.trim() == "*" {
      for quelle in read("/src/" + modul + ".typ").split("\n") {
        let d = quelle.match(regex(`^#let ([A-Za-z][A-Za-z0-9-]*)`.text))
        if d != none { out.push((name: d.captures.at(0), modul: modul)) }
      }
      continue
    }
    for n in namen.split(",") {
      let name = n.split(" as ").last().trim()
      if name != "" { out.push((name: name, modul: modul)) }
    }
  }
  out.sorted(key: e => lower(e.name))
}

#let schrauben = {
  let out = ()
  let inside = false
  for line in read("/src/config.typ").split("\n") {
    if line.starts-with("#let defaults = (") { inside = true; continue }
    if inside and line.starts-with(")") { break }
    if not inside { continue }
    let m = line.match(regex(`^  ([a-z-]+):`.text))
    if m != none { out.push(m.captures.at(0)) }
  }
  out
}

== Namen und ihre Einträge <kat:namen>

#context {
  let angemeldet = query(<kat-eintrag>).map(e => e.value)
  let id-fuer = (:)
  for e in angemeldet {
    if e.deckt == none { continue }
    for n in if type(e.deckt) == str { (e.deckt,) } else { e.deckt } {
      id-fuer.insert(n, e.id)
    }
  }

  // Nach Modul gruppieren: Wer etwas entfernt, arbeitet in EINER Datei.
  let nach-modul = (:)
  for e in exporte {
    nach-modul.insert(e.modul, nach-modul.at(e.modul, default: ()) + (e,))
  }
  let module = nach-modul.pairs().sorted(key: p => -p.at(1).len())
  let ohne = exporte.filter(e => e.name not in id-fuer)

  panel(weight: "quiet")[Wo das meiste liegt][
    #hl[#module.first().at(1).len() der #exporte.len() Namen stehen in
    #raw("src/" + module.first().at(0) + ".typ").] Wer dort etwas entfernt,
    arbeitet an dem Modul, das die meisten Bausteine gemeinsam trägt.
  ]
  zweck("H-01", none)[Die grösste Datei ist die, in der ein Eingriff am
  meisten bewegt.]

  for (modul, eintraege) in module {
    tabular(
      title: [#raw("src/" + modul + ".typ") · #eintraege.len()],
      cols: (1.5, 0.55),
      font: "dense",
      rows: "tight",
      colsep: "tight",
      [Name], [ID],
      ..eintraege
        .map(e => (raw(e.name), id-fuer.at(e.name, default: "—")))
        .flatten(),
    )
  }

  zweck("H-02", none)[Ein Strich statt einer ID heisst: hat keine eigene
  Darstellung und steht deshalb nicht im visuellen Teil.]

  // Der Vollständigkeitsanspruch — gerechnet, nicht behauptet.
  panel(tone: "neutral")[Vollständigkeit][
    #angemeldet.len() Einträge in A–H, #exporte.len() Namen in dieser Liste.
    #if ohne.len() == 0 [
      Jeder hat einen eigenen Eintrag.
    ] else [
      #(exporte.len() - ohne.len()) davon haben einen eigenen Eintrag;
      #if ohne.len() == 1 [der übrige trägt] else [die übrigen #ohne.len() tragen]
      einen Strich: #ohne.map(e => raw(e.name)).join(", ").
    ]
  ]
  zweck("H-03", none)[Nichts aus der öffentlichen API fehlt; was man nicht
  zeigen kann, ist als solches gekennzeichnet.]
}

== Stellschrauben <kat:schrauben>

#tabular(
  title: [H-04 · #schrauben.len() Argumente von `zsf(...)`],
  cols: (1, 1),
  font: "dense",
  rows: "tight",
  colsep: "tight",
  [Name], [Name],
  ..schrauben.map(k => raw(k)),
  ..if calc.odd(schrauben.len()) { ([],) } else { () },
)
#zweck("H-04", none)[Was pro ZSF einmal entschieden wird. Jede wird von
`make check` auf messbare Wirkung geprüft — eine wirkungslose bricht den Build.]

== Bilanz <kat:bilanz>

#context {
  let zeilen = read("/lib.typ").split("\n").len()
  for m in ("config", "knobs", "palette", "structure", "blocks", "tables", "media", "markup", "maths", "index") {
    zeilen += read("/src/" + m + ".typ").split("\n").len()
  }
  panel[H-05 · Was die Zahlen sagen][
    #exporte.len() öffentliche Namen, #schrauben.len() Stellschrauben,
    #zeilen Zeilen in `lib.typ` und `src/`. Der LaTeX-Vorgänger führte an
    derselben Stelle 104 Namen und brauchte dafür 5560 Zeilen.
  ]
}
#zweck("H-05", none)[Die Zahl, an der sich die Reduktion messen lässt — beim
Bauen gezählt, nicht behauptet.]

// Das Register steht am Dokumentende und ist der Beleg für sich selbst.
#front("Register", short: "Reg")
#zweck("H-06", "make-index")[Der Katalog hat selbst eines — ein Dokument, in
dem man nachschlägt, muss auffindbar sein.]
#make-index()
