#import "@local/zsf:0.1.0": *
#import "tools.typ": kurz, zweck, eintrag

#newcol()
= Bilder und Formeln <kat:formeln>

== Abbildungen <kat:bilder>

#fig(image("../showcase/graphics/beispiel.svg"), cap: [Mustertext zum Formvergleich])
#zweck("G-01", ("fig", "caption"))[G-01 · `fig` — die eigenständige Abbildung mit Bildunterschrift.]

#fig-side(image("../showcase/graphics/beispiel.svg"))[#kurz]
#zweck("G-02", "fig-side")[G-02 · `fig-side` — Bild links, Text rechts.]

#tabular(title: [G-03 · image in der Zelle], cols: (0.7, 1.3),
  [Bauform], [Bezeichnung],
  image("../showcase/graphics/beispiel.svg"), [Mustertext ohne Höhenangabe],
  image("../showcase/graphics/beispiel-b.svg"), [Zweite Zeile, gleich hoch],
)
#zweck("G-03", none)[Das nackte `image`; die Höhe stellt der Container.]

== Formelsatz <kat:mathe>

#eintrag[G-04][ergänzte Operatoren][
  $sgn(x), rang(A), Spur(M), Ker(f), Bild(f), eig(A)$ \
  $grad f, divg vc(F), rot vc(F), diag(a, b), spann(v), proj(u)$ \
  $Arsinh(x), Arcosh(x), Artanh(x), vc(v)$
]
#zweck("G-04", ("sgn", "rang", "Spur", "Ker", "Bild", "eig", "grad", "divg", "rot", "diag", "spann", "proj", "Adj", "Arsinh", "Arcosh", "Artanh", "vc"))[Alles, was Typst nicht selbst mitbringt — mehr gibt es nicht.]

#eintrag[G-05][markA – markD][
  $ markA(u) dot markB(v) + markD(z) = markC(w) $
]
#zweck("G-05", ("markA", "markB", "markC", "markD"))[Positional innerhalb EINER Herleitung: Quelle, Gegenstück, dritter Strang, Ziel.]

#eintrag[G-06][quantity][
  $ #quantity("Kraft", $F$) = m dot a, quad W = #quantity("Kraft", $F$) dot #quantity("Weg", $s$) $
]
#zweck("G-06", "quantity")[Eine Farbe gehört im ganzen Dokument EINER Grösse.]

#eintrag[G-08][palette · tone-of][
  #grid(columns: 6, gutter: 2pt, ..palette.slice(0, 6).map(a => {
    let t = tone-of(a)
    stack(
      block(width: 100%, height: 6pt, fill: t.accent),
      block(width: 100%, height: 5pt, fill: t.bar),
      block(width: 100%, height: 5pt, fill: t.title-back),
      block(width: 100%, height: 5pt, fill: t.zebra),
    )
  }))
]
#zweck("G-08", ("palette", "tone-of"))[Die Kapitelfarben und die daraus
abgeleiteten Rollen. Vollständig in der Referenz unter »Palette«.]

#eintrag[G-09][tone][
  #context {
    let t = tone()
    grid(columns: 3, gutter: 3pt,
      circle(radius: 7pt, stroke: 1pt + t.accent),
      circle(radius: 7pt, stroke: 1pt + t.frame-hard),
      circle(radius: 7pt, fill: t.zebra, stroke: 1pt + t.frame-soft))
  }
]
#zweck("G-09", "tone")[Der Ton, in dem gerade gesetzt wird. Damit eine selbst
gezeichnete Skizze Farbe hat, ohne den direkten Griff — in einer Warn-Box
faellt sie rot aus, ohne dass im Kapitel etwas steht.]

#steps[G-07 · given · step · target][
  #given[Voraussetzung] #sym.arrow.r #step[Schritt] #sym.arrow.r #target[Ziel]
]
#zweck("G-07", ("given", "step", "target"))[Die Glieder einer Kette einzeln, wenn `case` zu starr ist.]

#formula[G-10 · formula-line][
  #formula-line($E = m c^2$, [im Vakuum])
  #sep()
  #formula-line($nabla times bold(E) = - (dif bold(B)) / (dif t)$, [Induktion])
]
#zweck("G-10", "formula-line")[Zentrierte Formel mit dynamisch kollisionsfreier Notiz.]
