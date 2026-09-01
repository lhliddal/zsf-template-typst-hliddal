#import "@local/zsf:0.1.0": *
#import "tools.typ": zweck

#newcol()
= Tabellen <kat:tabellen>

Ein Baustein, sechs Regler. Alle Einträge zeigen dieselben Zellen.

#tabular(title: [E-01 · Vorbelegung], cols: (1, 1.2),
  [Kopf], [Kopf],
  [Muster], [zum Vergleich],
  [Muster], [zum Vergleich],
)
#zweck[Kopfzeile, Zebra und Gitter in beide Richtungen.]

#tabular(title: [E-02 · header: false], cols: (1, 1.2), header: false,
  [Muster], [zum Vergleich],
  [Muster], [zum Vergleich],
)
#zweck[Ohne Kopfzeile; das Zebra beginnt bei Zeile 1.]

#tabular(title: [E-03 · zebra: false], cols: (1, 1.2), zebra: false,
  [Kopf], [Kopf],
  [Muster], [zum Vergleich],
  [Muster], [zum Vergleich],
)
#zweck[Für sehr kurze Datenlisten.]

#tabular(title: [E-04 · grid: horizontal], cols: (1, 1.2), grid: "horizontal",
  [Kopf], [Kopf],
  [Muster], [zum Vergleich],
  [Muster], [zum Vergleich],
)
#zweck[Nur waagrechte Linien.]

#tabular(title: [E-05 · grid: none], cols: (1, 1.2), grid: "none",
  [Kopf], [Kopf],
  [Muster], [zum Vergleich],
  [Muster], [zum Vergleich],
)
#zweck[Nur das Zebra trennt.]

#tabular(title: [E-06 · rows: roomy], cols: (1, 1.2), rows: "roomy",
  [Kopf], [Kopf],
  [Muster], [$(u/v)' = (u'v - u v')/v^2$],
)
#zweck[Mehr Luft für Zellen mit Brüchen und Wurzeln.]

#tabular(title: [E-07 · rows: tight, font: dense], cols: (1, 1.2),
  rows: "tight", font: "dense", colsep: "tight",
  [Kopf], [Kopf],
  [Muster], [zum Vergleich],
  [Muster], [zum Vergleich],
)
#zweck[Register mit knappem Zellinhalt.]

#tabular(title: [E-08 · table.cell], cols: (1, 1, 1),
  [Kopf], table.cell(colspan: 2, align: center)[Verbund],
  [Muster], [zum], [Vergleich],
)
#zweck[Typsts eigener Zellverbund — kein eigener Name nötig.]

#tabular(cols: (1, 1.2),
  [Kopf], [Kopf],
  [Muster], [zum Vergleich],
)
#zweck[E-09 · ohne `title` — die Tabelle ohne eigene Box.]
