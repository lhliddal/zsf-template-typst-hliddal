#import "@local/zsf:0.1.0": *

= Bausteine <ch:bausteine>

Es gibt eine Box. Alles hier sind Vorbelegungen davon — ein Name, der eine
Absicht benennt, und sonst nichts. Wer eine Variante braucht, dreht einen
Regler #xref(<ch:regler>) statt einen Baustein zu suchen.

== Die Box und ihre drei Gewichte <sec:gewichte>

#panel[Eine Box ohne Titel. Der ruhige Fall für einen Gedanken, der keine
Überschrift braucht.]

#panel(tag: [panel])[Titel und Inhalt][
  #kw[panel] ist die allgemeine Inhaltsbox: Definition, Satz, gewichtige
  Aussage. #hl[Die prüfungskritischste Zeile einer Box wird hervorgehoben.]
]

#panel(weight: "quiet", tag: [weight])[Dieselbe Box, leiser][
  #lbl[weight: "quiet"] tauscht die Kopfzeile gegen eine Akzentkante — für
  kompakte Aussagen. Kein zweiter Baustein, ein Regler.
]

#formula(weight: "caption")[Kettenregel][
  $ dif / (dif x) f(g(x)) = f'(g(x)) dot g'(x) $
]
#after[
  #lbl[weight: "caption"] hebt den Titel als leichte Zeile aus der Box heraus.
  Für die benannte Formel — den häufigsten Fall einer Formelsammlung.
]

== Vorbelegungen mit eigener Absicht <sec:presets>

#warn[
  #kw[warn] ist der eigenständige Block für eine Stolperfalle, die Raum
  braucht. Ohne Titel lautet die Leiste »Achtung«.
  #danger[Nur für stetig differenzierbare $f$.]
]

#formula[Grenzwert][
  $ lim_(x -> 0) sin(x)/x = 1 $
  #note[Der Standardgrenzwert; folgt aus der Regel von l'Hôpital.]
]

#facts[Faktenliste][
  - #item[Marke][Der Eintrag mit benanntem Kopf.]
  - Eine blosse Aussage ohne Marke — die Liste mischt beides.
  - #item[Dritter][Eine Marke zu erfinden, nur damit die Form aufgeht, wäre
    eine Inhaltsänderung.]
]

#facts[Verfahren][
  + #item[Ableiten][$f'(x)$ bilden.]
  + #item[Nullsetzen][$f'(x) = 0$ lösen.]
  + #item[Prüfen][Vorzeichenwechsel von $f'$ untersuchen.]
]

#steps[Herleitung][
  #case[$f$ stetig auf $[a,b]$][$integral_a^b f$][existiert]
  #case[$f$ monoton][$f'$ vorzeichenkonstant][kein Wechsel]
]

#panel[Zielkette von Hand][
  #given[Voraussetzung] #sym.arrow.r #step[Zwischenschritt]
  #sym.arrow.r #step[weiterer Schritt] #sym.arrow.r #target[Ziel]
]

== Trennen, binden, nebeneinander <sec:komposition>

#panel[Zwei Blöcke in einer Box][
  Der erste Block steht für sich.
  #sep(label: [Fall B])
  Nach #lbl[sep] beginnt der zweite. Wer stattdessen eine zweite Box daneben
  stellt, hat den Trenner nicht gefunden.
]

#before[Dieser Satz gehört zur folgenden Box und rückt an sie heran.]
#panel(weight: "quiet")[Gebundener Text][
  #lbl[before] bindet nach unten, #lbl[after] nach oben.
]

#panel[Nebeneinander][
  #split(ratio: 0.42)[
    $ e^(i pi) + 1 = 0 $
  ][
    #lbl[split] ist ein eigener Baustein und kein Box-Regler: Zwei Dinge
    nebeneinander ist eine Layout-Frage. Dadurch komponiert es in jeder Box.
  ]
]

#code[```python
def newton(f, df, x0):
    x = x0
    while abs(f(x)) > 1e-9:   # Abbruch
        x -= f(x) / df(x)
    return x
```]
#after[#lbl[code] braucht kein Opt-in-Modul — die Sprache steht am Codeblock,
die Syntaxfärbung bringt Typst mit. Zeilen kurz halten: Eine zu lange Zeile
bricht um und verliert dabei ihre Einrückung.]
