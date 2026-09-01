#import "@local/zsf:0.1.0": *
#import "tools.typ": zweck

#newcol()
= Inventar <kat:inventar>

Was es gibt, in welchem Modul es lebt und welcher Art es ist. Die Liste wird
beim Bauen aus `lib.typ` und `src/config.typ` gelesen — sie kann deshalb nicht
veralten. Im Vorgänger wurde sie von Hand nachgeführt.

// Der Katalog liest die Quellen, statt sie abzuschreiben. Genau dafür ist die
// öffentliche API eine einzige Datei mit `#import`-Zeilen.
#let art = (
  structure: "Struktur",
  blocks: "Baustein",
  tables: "Baustein",
  media: "Bild",
  markup: "Marker",
  maths: "Formel",
  index: "Register",
  palette: "Farbe",
  config: "intern",
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
      if name == "" { continue }
      out.push((name: name, modul: modul))
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

== Öffentliche Namen <kat:namen>

#tabular(
  title: [H-01 · #exporte.len() Namen aus `lib.typ`],
  cols: (1.3, 1.0, 0.9),
  font: "dense",
  rows: "tight",
  [Name], [Modul], [Art],
  ..exporte
    .map(e => (raw(e.name), raw(e.modul), art.at(e.modul, default: "—")))
    .flatten(),
)
#zweck[Alles, was ein Kapitel aufrufen kann. Wer hier streicht, streicht in
`lib.typ` — der Katalog bildet nur ab.]

== Stellschrauben <kat:schrauben>

#tabular(
  title: [H-02 · #schrauben.len() Argumente von `zsf(...)`],
  cols: (1, 1),
  font: "dense",
  rows: "tight",
  colsep: "tight",
  [Name], [Name],
  ..schrauben.map(k => raw(k)),
  ..if calc.odd(schrauben.len()) { ([],) } else { () },
)
#zweck[Was pro ZSF einmal entschieden wird. Jede wird von `make check` auf
messbare Wirkung geprüft.]

== Was die Zahlen sagen <kat:bilanz>

#panel(tone: "neutral")[H-03 · Bilanz][
  #exporte.len() öffentliche Namen und #schrauben.len() Stellschrauben. Der
  LaTeX-Vorgänger führte an derselben Stelle 104 Namen und brauchte dafür 5560
  Zeilen; hier sind es #context {
    let zeilen = read("/lib.typ").split("\n").len()
    for m in ("config", "palette", "structure", "blocks", "tables", "media", "markup", "maths", "index") {
      zeilen += read("/src/" + m + ".typ").split("\n").len()
    }
    [#zeilen]
  }.
]
#zweck[Die Zahl, an der sich die Reduktion messen lässt — beim Bauen gezählt,
nicht behauptet.]
