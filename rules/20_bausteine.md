---
name: 20_bausteine
scope: chapters
purpose: Der Baustein-Katalog und seine Regler
---

## Aufruf-Konvention — für alle gleich

```typ
#baustein[Titel][Rumpf]        // mit Kopfzeile
#baustein[Rumpf]               // ohne
#baustein(regler: wert)[…][…]  // Regler sind benannte Argumente
```

Die Reihenfolge der Regler ist bedeutungslos, ein unbekannter Name bricht den
Build.

## Katalog

| Was wird ausgedrückt? | Baustein |
|---|---|
| Definition, Satz, gewichtige Aussage | `panel[Titel][…]` |
| Eigenschaft, kompakte Aussage | `panel(weight: "quiet")[Titel][…]` |
| Warnung, Stolperfalle | `warn[…]` (Titel vorbelegt mit »Achtung«) |
| Formel(n), evtl. mit Kontext | `formula[…]` |
| Benannte Formel | `formula(weight: "caption")[Name][…]` |
| Tabelle | `tabular(title: […], cols: (…))[…]` (`40_tabellen`) |
| Abbildung aus Dateien | `fig(image("…"), cap: […])` |
| Selbstgezeichnetes Diagramm | `picture[Titel][…]` + `caption` |
| Bild neben Text | `fig-side(image("…"))[…]` |
| Aufzählung von Fakten | `facts[Titel][- …]` |
| Schritt-für-Schritt-Verfahren | `facts[Titel][+ …]` |
| Herleitung, Fallunterscheidung | `steps[Titel][…]` mit `case` |
| Code-Schnipsel | ``code[```python …``` ]`` — die Sprache steht am Codeblock |
| Zwei Blöcke nebeneinander | `split(links, rechts, ratio: 0.4)` |
| Reiner Fliesstext | ein Absatz — kein Baustein nötig |

`warn`, `formula`, `picture`, `steps` und `code` sind **Vorbelegungen von
`panel`**. Ein Name kommt nur dazu, wenn er eine eigene Absicht trägt *und*
eine Vorbelegung, die man sonst komponieren müsste.

## Die Regler

Alle gelten auf jeder Box, sofern sie die Eigenschaft hat.

| Regler | Werte (Vorbelegung zuerst) | Wirkung |
|---|---|---|
| `tone` | `auto`, `"neutral"`, `"warn"`, eine Farbe | die Farbwelt |
| `weight` | `"loud"`, `"quiet"`, `"caption"` | wohin der Titel geht |
| `pad` | `"normal"`, `"tight"`, `"none"`, `"bar"` | Innenabstand |
| `frame` | `"soft"`, `"strong"`, `"hard"`, `"none"` | Rahmenstärke |
| `surface` | `auto`, `"plain"`, `"quiet"`, `"emphasis"` | Flächen-Rolle |
| `align` | `left`, `center` | Justierung des Inhalts |
| `font` | `"normal"`, `"dense"` | Schriftgrösse des Inhalts |
| `tag` | Inhalt | Meta-Tag rechts im Titel |
| `breakable` | `false`, `true` | darf über die Spaltengrenze brechen |

**Ein Ton ist eine Farbe.** `tone: rgb("#8C6239")` genügt: Titelfläche, Flächen,
Rahmenstärken, Balken und Tabellenkopf werden daraus in OKLCH abgeleitet. Es
gibt keine Ton-Deklaration mit Pflichtrollen mehr.

**Wie laut was ist, liegt fest:** Der Titelbalken einer Box ist *hell mit
dunkler Schrift*, ihr Rumpf fast weiss. Gesättigt sind nur Kapitel- und
Abschnittsbalken, Tabellenkopf und der Warn-Ton — die vier Stellen, die von
weitem gefunden werden müssen.

`tone: "neutral"` heisst »gehört nicht zum Kapitelthema« (Konvention, Legende).
`weight: "quiet"` heisst »kompakt und dezent«. Beides sind Antworten auf eine
Inhaltsfrage, nicht auf »welche Box nehme ich«.

## Nutzungsregeln

- **Blockwechsel:** `sep()` trennt zwei Blöcke **innerhalb** einer Box,
  `sep(label: [Fall B])` benennt den folgenden. Wer stattdessen eine zweite Box
  danebenstellt, hat den Trenner nicht gefunden.
- **Der Ton gilt nach innen.** Was in einer Box steht, kennt ihren Ton: Der
  Trenner einer Warn-Box ist rot, die Glieder einer `steps(tone: "warn")` sind
  es auch. Es gibt dafür nichts zu setzen — `tone` an der Box genügt, und ein
  Baustein darin braucht ihn nicht ein zweites Mal.
- **Anmerkungen:** `note[…]` als dezente Zeile unter einer Formel.
- **Text an eine Box binden:** `before[…]` gehört zur folgenden Box,
  `after[…]` zur vorhergehenden.
- **Listen:** Einträge sind native Listenpunkte (`-` bzw. `+`); `item[Marke][Text]`
  setzt nur die Marke. Die Marke ist optional — eine zu erfinden, nur damit die
  Form aufgeht, wäre eine Inhaltsänderung.
- **Ketten:** `case[Bedingung][Ausdruck][Resultat]` für den einzeiligen Fall;
  für mehrgliedrige Ketten `given` / `step` / `target` direkt.
- **Bilder:** Der Pfad steht immer im Kapitel (`image("graphics/x.svg")`), nie
  im Baustein-Aufruf. Die **Höhe stellt der Container**: in einer Tabellenzeile
  passt das Bild in die Zeile, in `fig` füllt es einen Block. `height` gehört
  nur an eine Stelle, die bewusst aus der Reihe fallen soll.
- **Beschriftung in Zeichnungen:** `diagram-label[…]` — nie ein lokales
  `#text(size: …)`. Für eine ganze `cetz`-Zeichnung einmal als deren
  `font`-Option setzen. Für echte Diagramme und Plots ist `cetz` zuständig und
  nicht dieses Template.
- **Nebeneinander:** `split` ist ein eigener Baustein und kein Box-Regler —
  zwei Dinge nebeneinander ist eine Layout-Frage. Dadurch komponiert es in
  jeder Box.
- **Code:** Zeilen kurz halten. Eine Zeile, die in der schmalen Spalte
  umbricht, verliert dabei ihre Einrückung — das lässt sich nicht im Baustein
  reparieren, nur im Code selbst.
- **Umbruch:** Boxen sind atomar. `breakable: true` pro Box, wenn ein langes
  Register absichtlich durchlaufen soll. Titelbalken kleben von selbst an ihrem
  Inhalt; es gibt keine Reserven und keinen Pack-Modus mehr.
