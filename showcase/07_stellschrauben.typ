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
  [`prose-scale`], [1.0], [wie laut die Prosa neben den Bausteinen steht],
  [`leading`], [1.0], [Zeilenhöhe; enthält die Schrift, klein schrittweise],
  [`density`], [1.0], [alles Vertikale, das reiner Leerraum ist],
  [`density-blocks`], [1.0], [nur die Innen- und Aussenabstände der Boxen],
  [`density-text`], [1.0], [nur der Absatzabstand im Fliesstext],
  [`density-tables`], [1.0], [nur Zell- und Zeilenabstand],
)

#tabular(
  title: [Seite, Schrift, Farbe], cols: (1, 0.5, 1.5), font: "dense",
  [Name], [Vorbelegung], [Wirkung],
  [`columns`], [4], [Spaltenzahl],
  [`margin`], [4mm], [Rand des Satzspiegels],
  [`gutter`], [3.5mm], [Steg zwischen den Spalten],
  [`font`], [Carlito], [Dokumentschrift],
  [`math-font`], [NewCM Sans Math], [Formelschrift],
  [`justify`], [false], [Blocksatz statt Flattersatz],
  [`palette`], [18 Slots], [die Kapitelfarben],
  [`quantities`], [–], [Grössenfarben des Fachs],
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

#warn[
  `leading` enthält die Schrift selbst und verträgt keine grossen Schritte.
  Nach jeder Änderung das PDF auf kollidierende Formelzeilen prüfen.
]
