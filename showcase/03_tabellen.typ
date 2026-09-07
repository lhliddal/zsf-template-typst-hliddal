#import "@local/zsf:0.1.0": *

= Tabellen <ch:tabellen>

Tabelle und Tabellenbox sind ein Baustein. Die Kopfzeile sind die ersten
Zellen — sie »halb« zu setzen ist strukturell nicht mehr möglich.

== Die Regler der Tabelle <sec:tabregler>

#tabular(
  title: [Vergleich], cols: (0.8, 1.4, 1),
  [Fall], [Bedingung], [Wert],
  [A], [$x > 0$], [$+1$],
  [B], [$x < 0$], [$-1$],
  [C], [$x = 0$], [$0$],
)

#tabular(
  title: [Ohne Kopf, ohne Zebra], cols: (1, 1.6),
  header: false, zebra: false, grid: "horizontal",
  [Symbol], [Bedeutung],
  [$nabla f$], [Gradient],
  [$Delta f$], [Laplace-Operator],
)

#tabular(
  title: [Dicht: font, colsep, rows], cols: (1, 1, 1, 1, 1),
  font: "dense", colsep: "tight", rows: "tight",
  [$n$], [$n^2$], [$n^3$], [$sqrt(n)$], [$1\/n$],
  [1], [1], [1], [1.00], [1.000],
  [2], [4], [8], [1.41], [0.500],
  [3], [9], [27], [1.73], [0.333],
  [4], [16], [64], [2.00], [0.250],
)

#tabular(
  title: [Hohe Zellen: rows: "roomy"], cols: (1, 1.5),
  rows: "roomy",
  [Regel], [Ausdruck],
  [Quotient], [$(u/v)' = (u'v - u v')/v^2$],
  [Wurzel], [$dif/(dif x) sqrt(x) = 1/(2 sqrt(x))$],
)

#tabular(
  title: [Zellverbund], cols: (1, 1, 1),
  [Gruppe], table.cell(colspan: 2, align: center)[Messwerte],
  [I], [3.4], [3.6],
  [II], [7.1], [7.0],
  table.cell(colspan: 3, align: center)[#lbl[table.cell] ist Typsts eigener Verbund — kein eigener Name nötig.],
)

#tabular(title: [Gitter weg], cols: (1, 1), grid: "none",
  [Links], [Rechts],
  [ohne], [Linien],
)

== Container vs. Inhalt: tablebox & inset <sec:tablebox>

#tablebox[Zwei Inhaltsarten in einer Box][
  #inset[Ein erklärender Satz oben mit sauberem Innenabstand, die Tabelle darunter bis an die Kante:]
  #tabular(cols: (1, 1), [Grösse], [Einheit], [Kraft], [N], [Weg], [m])
]
