#import "@local/zsf:0.1.0": *

= Stellschrauben <ch:stellschrauben>

Alles, was pro ZSF EINMAL entschieden wird, ist ein benanntes Argument von
`zsf()`. Was dort nicht steht, wird pro Stelle über einen Regler entschieden —
oder gar nicht. Ein Tippfehler bricht den Build mit der Liste der bekannten
Namen; ein wirkungsloser Regler ist damit ausgeschlossen.

== Was gedreht werden darf <sec:schrauben>

#tabular(
  title: [Grösse und Dichte], cols: (1, 0.5, 1.5), font: "dense",
  [Name], [Vorbelegung], [Wirkung],
  [`size`], [8pt], [Grundgrösse; nimmt den ganzen Satz mit],
  [`content-scale`], [1.0], [wie laut der Bausteininhalt neben den Balken steht],
  [`prose-scale`], [1.0], [wie laut die Prosa neben den Bausteinen steht],
  [`leading`], [1.0], [Zeilenhöhe; enthält die Schrift, klein schrittweise],
  [`density`], [1.0], [alles Vertikale, das reiner Leerraum ist],
  [`density-blocks`], [1.0], [nur die Innen- und Aussenabstände der Boxen],
  [`density-text`], [1.0], [nur der Absatzabstand im Fliesstext],
  [`density-tables`], [1.0], [nur Zell- und Zeilenabstand],
  [`density-structure`], [1.0], [nur Balken und ihr Abstand zum Inhalt],
)

#after[
  Die beiden Rollen-Faktoren sind Gegenstücke: `content-scale` trifft alles
  *in* einem Baustein, `prose-scale` den Text, der zu *keinem* gehört.
  Balken und Titel bleiben bei beiden stehen. `content-scale` ist der Regler,
  wenn der Inhalt an eine #hl[Breite] stösst — ob eine Formel in einer
  zweispaltigen Zelle einzeilig bleibt, entscheidet er allein.
]

#tabular(
  title: [Seite, Schrift, Farbe], cols: (1, 0.5, 1.5), font: "dense",
  [Name], [Vorbelegung], [Wirkung],
  [`columns`], [4], [Spaltenzahl],
  [`margin`], [4mm], [Rand des Satzspiegels],
  [`gutter`], [3.5mm], [Steg zwischen den Spalten],
  [`font`], [Carlito], [Dokumentschrift],
  [`math-font`], [NewCM Sans Math], [Formelschrift],
  [`justify`], [false], [Blocksatz statt Flattersatz],
  [`bind-units`], [true], [hält Zahl und Einheit in einer Zeile],
  [`palette`], [18 Slots], [die Kapitelfarben],
  [`quantities`], [–], [Grössenfarben des Fachs],
  [`quantity-colors`], [true], [`false` für den S/W-Druck, ohne die Vergabe anzutasten],
  [`index-pages`], [true], [Register zeigt zusätzlich die Druckseite],
)

#panel(tone: "neutral")[Warum es keine Register-Befehle mehr gibt][
  Im Vorgänger stand neben jeder Stellschraube die Warnung, das darunter
  liegende Mass nicht direkt zu setzen — mit einem Verifier, der das prüfte.
  Hier gibt es die Masse gar nicht erst als öffentliche Namen: Sie werden aus
  den Reglern gerechnet und sind von aussen nicht erreichbar.
]

== Dichte im Vergleich <sec:dichte>

#panel(weight: "quiet")[Faustregeln][
  `density: 0.85` spart rund 5 % Gesamthöhe, `0.7` rund 10 %; der Löwenanteil
  kommt aus den Box-Polsterungen. Wer eine Seite einsparen muss, kombiniert
  Dichte mit `leading` und prüft danach das PDF.
]

#density-scope(0.85)[
  #panel[Bereichsweise Dichte][
    #kw[density-scope] verdichtet ein Kapitel oder einen Anhang punktuell.
  ]
]

#warn[
  `leading` enthält die Schrift selbst und verträgt keine grossen Schritte.
  Nach jeder Änderung das PDF auf kollidierende Formelzeilen prüfen.
]

== Zahl und Einheit <sec:bindung>

#panel(weight: "quiet")[Bindet ohne Zutun][
  In einer 50 mm schmalen Spalte bricht die Zeile gern zwischen Zahl und
  Einheit. Diese bleiben deshalb zusammen: 10 m/s, 95 %, 20 °C, 1.5 kg,
  50 mm, 7 Hz — im Kapitel steht dafür nichts.

  #hl[Nur Kürzel bis drei Buchstaben.] 3 Fälle, 12 Beispiele und 5 Zeilen
  brechen weiterhin normal; eine Zahl an ein langes Wort zu binden ergäbe hier
  überlange Zeilen.
]

#panel(tone: "neutral")[Warum `box` und kein geschütztes Leerzeichen][
  Gebunden wird über einen Kasten, nicht durch ein ersetztes Zeichen. Wer
  eine Angabe aus dem PDF kopiert, bekommt deshalb weiterhin ein normales
  Leerzeichen — kein U+00A0, das anderswo als Fehler auftaucht.
]
