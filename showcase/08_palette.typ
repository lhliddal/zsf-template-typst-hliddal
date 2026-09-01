#import "@local/zsf:0.1.0": *

#newcol()

= Palette <ch:palette>

Achtzehn Slots. Slot 0 gehört dem Front-Matter; nummerierte Kapitel rotieren
über die übrigen siebzehn. Die Aufstellung zeigt pro Slot alle drei
Balkenstufen und den Box-Akzent — so ist auf einen Blick prüfbar, dass
benachbarte Kapitel unterscheidbar bleiben und jede Stufe ihre Rolle behält.

// Jede Zeile ist EIN Slot, gesetzt mit denselben Funktionen wie ein Kapitel.
#let stufen(accent, nr) = {
  let t = tone-of(accent)
  block(breakable: false, above: 6pt, below: 6pt, {
    block(width: 100%, fill: t.accent, radius: 2pt, inset: (x: 4pt, y: 2pt),
      text(fill: white, weight: "bold")[Slot #nr])
    block(width: 100%, fill: t.bar, radius: 2pt, inset: (x: 4pt, y: 1.5pt), above: 2pt,
      text(fill: t.bar-text, weight: "bold", size: 0.94em)[Abschnittston])
    block(width: 100%, fill: t.bar-light, radius: 2pt, inset: (x: 4pt, y: 1.5pt), above: 2pt,
      text(fill: t.bar-light-text, weight: "bold", size: 0.88em)[Unterabschnitt])
    block(width: 100%, fill: t.title-back, radius: 2pt, inset: (x: 4pt, y: 1.5pt), above: 2pt,
      text(fill: t.title-text, weight: "bold", size: 0.88em)[Box-Titel])
    block(width: 100%, fill: t.loud, stroke: (left: 2.2pt + t.accent), inset: (x: 4pt, y: 2pt), above: 0pt,
      text(size: 0.88em)[Fläche, Akzentkante und Zebra: #box(width: 1.4em, height: 0.7em, fill: t.zebra, stroke: 0.3pt + t.frame-soft)])
  })
}

== Alle achtzehn Slots <sec:slots>

#for (i, c) in palette.enumerate() { stufen(c, i) }

#panel(tone: "neutral")[Was die Aufstellung prüft][
  Jede Stufe entsteht aus derselben Ableitung wie im Satz: Der Abschnittsbalken
  ist der aufgehellte Akzent, der Unterabschnitt dessen Aufhellung, der
  Box-Titel die Aufhellung selbst. Wo eine Zeile aus der Reihe fällt, ist der
  Slot schlecht gewählt — nicht die Regel.
]
