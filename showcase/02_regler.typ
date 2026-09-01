#import "@local/zsf:0.1.0": *

= Regler <ch:regler>

Jeder Regler ist ein benanntes Argument und gilt auf jeder Box, sofern sie die
Eigenschaft hat. Die Reihenfolge ist bedeutungslos — sie stehen fest, bevor der
Rumpf läuft. Kein Regler verwirft einen anderen.

== Ton: eine Farbe, die ganze Familie <sec:ton>

#panel[Kapitelton (Vorbelegung)][Die Box folgt der Farbe ihres Kapitels.]
#panel(tone: "neutral")[tone: "neutral"][
  Für den Hinweis, der bewusst nicht zum Kapitelthema gehört — Konvention,
  Legende, Meta-Anmerkung.
]
#panel(tone: "warn")[tone: "warn"][Der Warn-Ton, ohne die `warn`-Vorbelegung.]
#panel(tone: rgb("#8C6239"))[Ein eigener Ton][
  #hl[Ein Ton ist eine Farbe.] Aus ihr werden Titelfläche, laute und ruhige
  Fläche, betonte Fläche und drei Rahmenstärken in OKLCH abgeleitet — deshalb
  ist ein neuer Ton hier ein Argument und keine Deklaration mit neun Rollen.
]

#panel(tone: "warn", frame: "strong")[Regler greifen unabhängig][
  `tone` wählt die Farbwelt, `frame` die Rahmenstärke. Beide zusammen, in
  beliebiger Reihenfolge.
  #sep(label: [und nach innen])
  Der Trenner über dieser Zeile trägt den Ton der Box, nicht den des Kapitels.
  Dasselbe gilt für die Glieder einer Kette — `tone` an der Box genügt.
]

== Fläche, Rahmen, Polsterung <sec:flaeche>

#panel(surface: "plain")[surface: "plain"][Ungetönt — die Basis für Zebra und Gitterlinien.]
#panel(surface: "emphasis")[surface: "emphasis"][Betont geflächt, wie die Formelbox.]
#panel(frame: "none", surface: "quiet")[frame: "none"][Ohne Umrandung.]
#panel(frame: "hard")[frame: "hard"][Harte Kante — schliesst ein Tabellengitter ab.]
#panel(pad: "tight")[pad: "tight"][Knappste Höhe und Breite.]
#panel(pad: "none", surface: "plain", frame: "hard")[pad: "none"][
  #tabular(cols: (1, 1), [Grösse], [Einheit], [Kraft], [N])
]
#after[Der eigentliche Fall: Der Inhalt polstert selbst, sonst endete das
Zebra sichtbar vor dem Rahmen. `tabular(title: …)` setzt das von sich aus.]
#panel(align: center)[align: center][Zentrierter Inhalt.]
#panel(font: "dense")[font: "dense"][
  Eine Stufe kleiner — für lange Register und Vergleichsmatrizen mit knappem
  Zellinhalt.
]

== Umbruch <sec:umbruch>

#panel(breakable: true)[breakable: true][
  Boxen sind atomar, damit keine über eine Spaltengrenze zerreisst. Für ein
  Anhang-Kapitel, dessen Register absichtlich durchläuft, gibt es diesen
  Regler — pro Box statt als Moduswechsel für ein ganzes Kapitel.
]

#panel[Spaltenumbruch][
  #lbl[newcol()] ist der einzige Spaltenumbruch im System und steht immer
  sichtbar im Aufruf. Kein Strukturmakro bricht von selbst um; ein Titelbalken
  klebt ohnehin an seinem Inhalt.
]
