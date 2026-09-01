#import "@local/zsf:0.1.0": *
#import "tools.typ": muster, kurz, zweck, eintrag

#newcol()
= Regler <kat:regler>

Jeder Regler auf derselben Box, mit demselben Mustertext. Wo zwei Einträge
gleich aussehen, ist einer überflüssig.

== tone <kat:tone>

#panel[D-01 · tone: auto][#kurz]
#zweck[Vorbelegung: die Farbe des laufenden Kapitels.]

#panel(tone: "neutral")[D-02 · tone: neutral][#kurz]
#zweck[Der Hinweis, der bewusst nicht zum Kapitelthema gehört.]

#panel(tone: "warn")[D-03 · tone: warn][#kurz]
#zweck[Der Warn-Ton ohne die `warn`-Vorbelegung.]

#panel(tone: rgb("#4C248F"))[D-04 · tone: \<Farbe\>][#kurz]
#zweck[Ein eigener Ton ist eine Farbe — keine Deklaration mit Rollen.]

== weight, surface, frame, pad <kat:flaechen>

#panel(surface: "plain")[D-05 · surface: plain][#kurz]
#zweck[Ungetönt — die Basis für Zebra und Gitterlinien.]

#panel(surface: "quiet")[D-06 · surface: quiet][#kurz]
#zweck[Die ruhige Fläche, unabhängig vom Gewicht.]

#panel(surface: "emphasis")[D-07 · surface: emphasis][#kurz]
#zweck[Betont geflächt, wie die Formelbox.]

#panel(frame: "soft")[D-08 · frame: soft][#kurz]
#zweck[Vorbelegung: die leichte Kontur.]

#panel(frame: "strong")[D-09 · frame: strong][#kurz]
#zweck[Kräftiger, für Zielketten.]

#panel(frame: "hard")[D-10 · frame: hard][#kurz]
#zweck[Harte Kante — schliesst ein Tabellengitter ab.]

#panel(frame: "none")[D-11 · frame: none][#kurz]
#zweck[Ohne Umrandung.]

#panel(pad: "normal")[D-12 · pad: normal][#kurz]
#zweck[Vorbelegung.]

#panel(pad: "tight")[D-13 · pad: tight][#kurz]
#zweck[Knappste Höhe und Breite.]

#panel(pad: "bar")[D-14 · pad: bar][#kurz]
#zweck[Hält links die Akzentkante frei.]

#panel(pad: "none", frame: "hard")[D-15 · pad: none][
  #tabular(cols: (1, 1), [Grösse], [Einheit], [Kraft], [N])
]
#zweck[Der Inhalt polstert selbst — sonst endete das Zebra vor dem Rahmen.]

== align, font, tag, breakable <kat:rest>

#panel(align: center)[D-16 · align: center][#kurz]
#zweck[Zentrierter Inhalt.]

#panel(font: "dense")[D-17 · font: dense][#muster]
#zweck[Eine Stufe kleiner, für lange Register.]

#panel(tag: [Meta])[D-18 · tag][#kurz]
#zweck[Rechtsbündiges Meta-Tag im Titel.]

#panel(breakable: true)[D-19 · breakable: true][#kurz]
#zweck[Darf über eine Spaltengrenze brechen; sonst sind Boxen atomar.]
