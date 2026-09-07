---
name: 40_tabellen
scope: chapters
purpose: Tabellen
---

Tabelle und Tabellenbox sind **ein** Baustein:

```typ
#tabular(
  title: [Vergleich],          // weggelassen → Tabelle ohne Box
  cols: (0.8, 1.4, 1),         // Gewichte; feste Längen sind erlaubt
  [Fall], [Bedingung], [Wert], // die ersten Zellen sind die Kopfzeile
  [A], [$x > 0$], [$+1$],
)
```

Die Kopfzeile **sind** die ersten Zellen. Sie »halb« zu setzen ist strukturell
nicht möglich; im Vorgänger führte genau das zu weisser Schrift auf weissem
Grund, ohne Fehlermeldung. Ein Zellverbund in der Kopfzeile wird in Spalten
gezählt, nicht in Argumenten.

Die Spaltengewichte sind Anteile und müssen zu nichts aufgehen; ein Gewicht
von null oder weniger bricht ab, weil zwei Zellen sonst übereinander drucken.

**Die Zellzahl muss aufgehen.** Fehlt eine Zelle, verrutscht ab dort jede Zeile
um eins — im Satz sieht das aus wie Absicht. Deshalb bricht der Build, wenn die
Zellen kein volles Vielfaches der Spaltenzahl füllen oder die Kopfzeile nicht
über alle Spalten reicht. Verbünde zählen mit ihrer `colspan`; bei `rowspan`
oder ausdrücklich platzierten Zellen wird nicht gerechnet statt falsch gemeldet.

## Regler

| Regler | Werte (Vorbelegung zuerst) | Wirkung |
|---|---|---|
| `header` | `true`, `false` | farbige Kopfzeile |
| `zebra` | `true`, `false` | Zebra-Streifen |
| `grid` | `"both"`, `"horizontal"`, `"none"` | Linien **zwischen** Zeilen und Spalten |
| `rows` | `"normal"`, `"roomy"`, `"tight"` | Zeilenhöhe |
| `colsep` | `"normal"`, `"tight"` | Zellpolsterung |
| `font` | `"normal"`, `"dense"` | Schriftgrösse |
| `align` | `left`, `center`, `right` | eine für alle — oder `(left, right)`, eine je Spalte |

Dazu gelten die Box-Regler (`tone`, `frame`, `breakable`, …), sobald `title`
gesetzt ist.

**Drei Regler, drei Fragen — bewusst nicht einer:** Eine Formeltabelle will
normale Schrift *und* mehr Zeilenhöhe; ein siebenspaltiges Register kleine
Schrift *und* knappe Polsterung *und* normale Zeilenhöhe.

Passt eine Tabelle knapp nicht, erst prüfen **woran** es liegt: zu breit →
`colsep: "tight"`, notfalls `font: "dense"`. Zeilen stossen aneinander →
`rows: "roomy"`.

## Linien

Beide Richtungen sind vorbelegt; Wegnehmen ist die Wahl. **Die Aussenkante ist
der Boxrahmen, nicht das Gitter** — nur er läuft an den runden Ecken mit.
Deshalb steht eine Tabellenbox auf `frame: "hard"`, und abgeschaltet wird die
Aussenkante an der **Box** (`frame: "none"`), nicht an der Tabelle.

## Zellverbund und Bilder

`table.cell(colspan: 3, align: center)[…]` ist Typsts eigener Verbund — dafür
gibt es keinen eigenen Namen. In einer Zelle steht das nackte
`image("graphics/x.svg")`; die Tabelle setzt die Höhe, damit eine Bildspalte
von selbst einheitlich hoch ist.
