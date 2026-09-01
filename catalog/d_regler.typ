#import "@local/zsf:0.1.0": *
#import "tools.typ": muster, kurz, zweck, eintrag

#newcol()
= Regler <kat:regler>

Jeder Regler auf derselben Box, mit demselben Mustertext. Wo zwei Einträge
gleich aussehen, ist einer überflüssig.

== tone <kat:tone>

#panel[D-01 · tone: auto][#kurz]
#zweck("D-01", none)[Vorbelegung: die Farbe des laufenden Kapitels.]

#panel(tone: "neutral")[D-02 · tone: neutral][#kurz]
#zweck("D-02", none)[Der Hinweis, der bewusst nicht zum Kapitelthema gehört.]

#panel(tone: "warn")[D-03 · tone: warn][#kurz]
#zweck("D-03", none)[Der Warn-Ton ohne die `warn`-Vorbelegung.]

#panel(tone: rgb("#4C248F"))[D-04 · tone: \<Farbe\>][#kurz]
#zweck("D-04", none)[Ein eigener Ton ist eine Farbe — keine Deklaration mit Rollen.]

== weight, surface, frame, pad <kat:flaechen>

#panel(surface: "plain")[D-05 · surface: plain][#kurz]
#zweck("D-05", none)[Ungetönt — die Basis für Zebra und Gitterlinien.]

#panel(surface: "quiet")[D-06 · surface: quiet][#kurz]
#zweck("D-06", none)[Die ruhige Fläche, unabhängig vom Gewicht.]

#panel(surface: "emphasis")[D-07 · surface: emphasis][#kurz]
#zweck("D-07", none)[Betont geflächt, wie die Formelbox.]

#panel(frame: "soft")[D-08 · frame: soft][#kurz]
#zweck("D-08", none)[Vorbelegung: die leichte Kontur.]

#panel(frame: "strong")[D-09 · frame: strong][#kurz]
#zweck("D-09", none)[Kräftiger, für Zielketten.]

#panel(frame: "hard")[D-10 · frame: hard][#kurz]
#zweck("D-10", none)[Harte Kante — schliesst ein Tabellengitter ab.]

#panel(frame: "none")[D-11 · frame: none][#kurz]
#zweck("D-11", none)[Ohne Umrandung.]

#panel(pad: "normal")[D-12 · pad: normal][#kurz]
#zweck("D-12", none)[Vorbelegung.]

#panel(pad: "tight")[D-13 · pad: tight][#kurz]
#zweck("D-13", none)[Knappste Höhe und Breite.]

#panel(pad: "bar")[D-14 · pad: bar][#kurz]
#zweck("D-14", none)[Hält links die Akzentkante frei.]

#panel(pad: "none", frame: "hard")[D-15 · pad: none][
  #tabular(cols: (1, 1), [Grösse], [Einheit], [Kraft], [N])
]
#zweck("D-15", none)[Der Inhalt polstert selbst — sonst endete das Zebra vor dem Rahmen.]

== align, font, tag, breakable <kat:rest>

#panel(align: center)[D-16 · align: center][#kurz]
#zweck("D-16", none)[Zentrierter Inhalt.]

#panel(font: "dense")[D-17 · font: dense][#muster]
#zweck("D-17", none)[Eine Stufe kleiner, für lange Register.]

#panel(tag: [Meta])[D-18 · tag][#kurz]
#zweck("D-18", none)[Rechtsbündiges Meta-Tag im Titel.]

#panel(breakable: true)[D-19 · breakable: true][#kurz]
#zweck("D-19", none)[Darf über eine Spaltengrenze brechen; sonst sind Boxen atomar.]
