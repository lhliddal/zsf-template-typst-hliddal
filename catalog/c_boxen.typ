#import "@local/zsf:0.1.0": *
#import "tools.typ": muster, kurz, zweck, eintrag

#newcol()
= Bausteine <kat:boxen>

Eine Box und fünf Vorbelegungen. Jeder Eintrag zeigt denselben Mustertext.

== Die Box in drei Gewichten <kat:gewichte>

#panel[C-01 · panel][#muster]
#zweck("C-01", "panel")[Die allgemeine Inhaltsbox: Definition, Satz, gewichtige Aussage.]

#panel[#muster]
#zweck("C-02", none)[C-02 · panel ohne Titel — der ruhige Fall, weisse Fläche.]

#panel(weight: "quiet")[C-03 · weight: quiet][#muster]
#zweck("C-03", none)[Kompakte Aussage: Akzentkante statt Kopfzeile.]

#panel(weight: "caption")[C-04 · weight: caption][#kurz]
#zweck("C-04", none)[Beschriftung statt Überschrift — der häufigste Fall einer Formel.]

== Die Vorbelegungen <kat:presets>

#warn[C-05 · warn][#muster]
#zweck("C-05", "warn")[Stolperfalle mit vorbelegtem Titel und rufender Fläche.]

#formula[C-06 · formula][$ integral_a^b f'(x) dif x = f(b) - f(a) $]
#zweck("C-06", "formula")[Formelblock: betont geflächt, zentriert, harte Kontur.]

#picture[C-07 · picture][
  #image("../showcase/graphics/beispiel.svg", height: 1.1cm)
]
#zweck("C-07", "picture")[Container für eine selbstgezeichnete Abbildung.]

#steps[C-08 · steps][#case[Bedingung][Ausdruck][Resultat]]
#zweck("C-08", ("steps", "case"))[Herleitung und Fallunterscheidung als Kette.]

#code[C-09 · code][```python
def f(x):
    return x**2
```]
#zweck("C-09", "code")[Code-Schnipsel; Sprache am Codeblock, Färbung von Typst.]

#facts[C-10 · facts][
  - Erster Eintrag zum Formvergleich.
  - Zweiter Eintrag zum Formvergleich.
]
#zweck("C-10", ("facts", "item"))[Faktenliste; mit `+` statt `-` wird sie zum Verfahren.]

#tabular(title: [C-11 · tabular], cols: (1, 1.4),
  [Spalte], [Spalte],
  [Muster], [zum Formvergleich],
)
#zweck("C-11", "tabular")[Tabelle und Tabellenbox in einem Baustein.]

== Fügen und Trennen <kat:fuegen>

#panel[C-12 · split][#split[#kurz][#kurz]]
#zweck("C-12", "split")[Zwei Blöcke nebeneinander; komponiert in jeder Box.]

#panel[C-13 · sep][
  #kurz
  #sep(label: [Fall B])
  #kurz
]
#zweck("C-13", "sep")[Blockwechsel innerhalb einer Box, wahlweise beschriftet.]

#panel[C-14 · note][
  #kurz
  #note[Anmerkung zum Formvergleich.]
]
#zweck("C-14", "note")[Dezente Zeile unter einer Formel oder Aussage.]

#before[C-15 · before — dieser Satz gehört zur folgenden Box.]
#panel[#kurz]
#after[C-15 · after — dieser Satz gehört zur vorhergehenden Box.]
#zweck("C-15", ("before", "after"))[Text an eine Box binden, nach unten oder
nach oben. Ein Eintrag für beide: Sie sind dieselbe Bindung in zwei Richtungen.]
