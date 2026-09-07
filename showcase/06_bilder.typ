#import "@local/zsf:0.1.0": *

// Dieses Kapitel beginnt bewusst auf einer neuen Spalte.
#newcol()

= Bilder <ch:bilder>

Die Höhe gehört dem Container, nicht dem Aufruf: In einer Tabellenzeile passt
ein Bild in die Zeile, als eigener Block füllt es einen. Beides ist vorbelegt.

== Drei Rollen <sec:bildrollen>

#fig(image("graphics/beispiel.svg"), cap: [Kreis mit Radius und Kurve])

#fig-side(image("graphics/beispiel.svg"))[
  #lbl[fig-side] ist der fertige Fall »Bild links, Text rechts«. Der Regler
  `ratio` verschiebt die Teilung, `frame: "none"` nimmt den Rahmen weg.
]

#tabular(
  title: [Bild in der Zelle], cols: (0.9, 1, 1),
  [Bauform], [Bezeichnung], [Kennwert],
  image("graphics/beispiel.svg"), [Kreisprofil], [$A = pi r^2$],
  image("graphics/beispiel.svg"), [dasselbe Bild], [gleiche Höhe],
)
#after[In der Zelle steht das nackte #lbl[image] — die Tabelle setzt die Höhe.
Eine Bildspalte ist dadurch von selbst einheitlich hoch, und die Höhe pro
Zelle zu wiederholen ist der Fehler, den die Vorbelegung vermeidet.]

== Selbst gezeichnet <sec:zeichnen>

#picture[Eigene Zeichnung][
  // Eine Skizze braucht Farbe und hätte sonst nur den direkten Griff. `tone()`
  // gibt ihr die Farbwelt, in der sie steht — hier die des Kapitels, in einer
  // Warn-Box automatisch Rot. Nur innerhalb von `context`.
  #context {
    let t = tone()
    box(width: 100%, height: 2.0cm)[
      #place(center + horizon)[
        #let r = 24pt
        #box(width: 3.2cm, height: 2cm)[
          // Achsen
          #place(center + horizon, line(length: 3.0cm, stroke: 0.6pt + t.frame-soft))
          #place(center + horizon, line(angle: 90deg, length: 1.8cm, stroke: 0.6pt + t.frame-soft))
          // Kreis & Radiusvektor
          #place(center + horizon, circle(radius: r, stroke: 1pt + t.frame-hard))
          #place(center + horizon, line(start: (0pt, 0pt), end: (17pt, -17pt), stroke: 1.2pt + t.accent))
          #place(center + horizon, dx: 11pt, dy: -12pt, diagram-label[$r$])
          #place(center + horizon, dx: 1.4cm, dy: -6pt, diagram-label[$x$])
          #place(center + horizon, dx: 4pt, dy: -0.85cm, diagram-label[$y$])
        ]
      ]
    ]
  }
  #caption[Geometrische Skizze mit Typsts Formen — Farben dynamisch über `tone()`.]
]

#panel(tone: "neutral")[Zeichnen im Grossen][
  Für echte Diagramme, Plots und Achsensysteme ist #kw[cetz] die Antwort und
  nicht dieses Template: `#import "@preview/cetz:0.4.2"`. Das Rad steht schon
  da und wird gepflegt. Für die Beschriftung darin gibt es `diagram-label` —
  die kalibrierte Grösse, damit im Kapitel keine lokale Schriftgrösse entsteht.
]
