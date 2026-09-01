#import "@local/zsf:0.1.0": *
#import "tools.typ": kurz, zweck, eintrag

#newcol()
= Bilder und Formeln <kat:formeln>

== Abbildungen <kat:bilder>

#fig(image("../showcase/graphics/beispiel.svg"), cap: [Mustertext zum Formvergleich])
#zweck[G-01 · `fig` — die eigenständige Abbildung mit Bildunterschrift.]

#fig-side(image("../showcase/graphics/beispiel.svg"))[#kurz]
#zweck[G-02 · `fig-side` — Bild links, Text rechts.]

#tabular(title: [G-03 · image in der Zelle], cols: (0.8, 1.2),
  [Bauform], [Bezeichnung],
  image("../showcase/graphics/beispiel.svg"), [Mustertext],
)
#zweck[Das nackte `image`; die Höhe stellt der Container.]

== Formelsatz <kat:mathe>

#eintrag[G-04][ergänzte Operatoren][
  $sgn(x), rang(A), Spur(M), Ker(f), Bild(f), eig(A)$ \
  $grad f, divg vc(F), rot vc(F), diag(a, b), spann(v), proj(u)$ \
  $Arsinh(x), Arcosh(x), Artanh(x), vc(v)$
]
#zweck[Alles, was Typst nicht selbst mitbringt — mehr gibt es nicht.]

#eintrag[G-05][markA – markD][
  $ markA(u) dot markB(v) + markD(z) = markC(w) $
]
#zweck[Positional innerhalb EINER Herleitung: Quelle, Gegenstück, dritter Strang, Ziel.]

#eintrag[G-06][quantity][
  $ #quantity("Kraft", $F$) = m dot a, quad W = #quantity("Kraft", $F$) dot #quantity("Weg", $s$) $
]
#zweck[Eine Farbe gehört im ganzen Dokument EINER Grösse.]

#steps[G-07 · given · step · target][
  #given[Voraussetzung] #sym.arrow.r #step[Schritt] #sym.arrow.r #target[Ziel]
]
#zweck[Die Glieder einer Kette einzeln, wenn `case` zu starr ist.]
