#import "@local/zsf:0.1.0": *

= Formeln <ch:formeln>

Typst bringt den grössten Teil selbst mit: #kw[Zahlmengen] $RR, CC, NN, ZZ, QQ$,
das aufrechte Differential $dif x$, gepaarte Begrenzer $abs(x)$ und $norm(v)$,
Klammern unter dem Term, Vektoren und Matrizen. Ergänzt wird nur, was fehlt.

== Ergänzte Operatoren <sec:operatoren>

#tabular(cols: (1, 1.3), title: [Operatoren],
  [Aufruf], [Satz],
  [`sgn`, `rang`, `Spur`], [$sgn(x), rang(A), Spur(M)$],
  [`Ker`, `Bild`, `eig`], [$Ker(f), Bild(f), eig(A)$],
  [`grad`, `divg`, `rot`], [$grad f, divg vc(F), rot vc(F)$],
  [`diag`, `spann`, `proj`], [$diag(a,b), spann(v_1), proj(u)$],
  [`Arsinh`, `Artanh`], [$Arsinh(x), Artanh(x)$],
  [`vc`], [$vc(v) dot vc(w)$],
)

== Formelblöcke <sec:formelbloecke>

#formula[Satz von Taylor][
  $ f(x) = sum_(k=0)^n (f^((k))(a))/(k!) (x-a)^k + R_n(x) $
  #note[$R_n$ ist das Restglied; für $n -> oo$ konvergiert die Reihe auf dem
  Konvergenzintervall.]
]

#formula[Zwei Blöcke, ein Trenner][
  $ integral u' v = u v - integral u v' $
  #sep(label: [Bestimmt])
  $ integral_a^b u' v = [u v]_a^b - integral_a^b u v' $
]

#formula[Kollisionsfreie Notiz][
  #formula-line($E = m c^2$, [im Vakuum])
  #sep()
  #formula-line($nabla times bold(E) = - (dif bold(B)) / (dif t)$, [Induktionsgesetz])
]

== Terme benennen und verfolgen <sec:markieren>

#formula[Der Name steht am Term][
  $ underbrace(a x^2 + b x, "quadratischer Teil") + underbrace(c, "Konstante") $
]

#formula[Farbe verfolgt die Grösse][
  $ markA(u) dot markB(v) + markD(z) = markC(w) $
  #note[#lbl[markA] Quelle, #lbl[markB] Gegenstück, #lbl[markC] Ziel,
  #lbl[markD] dritter Strang. Positional, innerhalb EINER Herleitung — nicht
  zur Dekoration.]
]

#panel(weight: "quiet")[Grössenfarben][
  Eine Farbe gehört im ganzen Dokument EINER Grösse — vergeben in
  `zsf(quantities: …)`, nie im Kapitel:
  $ #quantity("Kraft", $F$) = m dot a, quad W = #quantity("Kraft", $F$) dot #quantity("Weg", $s$), quad #quantity("Moment", $M$) = #quantity("Kraft", $F$) dot r $
]
