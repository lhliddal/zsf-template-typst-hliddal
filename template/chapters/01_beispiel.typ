// Ein Kapitel ist reiner Inhalt. Gestaltung entsteht durch die Wahl des
// Bausteins, nicht durch Layout-Befehle.
//
// Die vollständige Vorführung aller Bausteine und Regler steht im Katalog des
// Templates (`make catalog` dort). Hier nur das Nötigste zum Anfangen.

#import "@local/zsf:0.1.0": *

= Erstes Kapitel <ch:erstes>

Fliesstext braucht keinen Baustein — ein Absatz ist ein Absatz. Zentrale
#kw[Fachbegriffe] werden markiert und landen damit automatisch im Register.

== Erster Abschnitt <sec:erster>

#panel[Definition][
  Der allgemeine Inhaltsbaustein: Definition, Satz, gewichtige Aussage.
  #hl[Die prüfungskritischste Zeile wird hervorgehoben.]
]

#panel(weight: "quiet")[Kompakte Aussage][
  Dieselbe Box, leiser — für Eigenschaften und Nebenbemerkungen.
]

#formula(weight: "caption")[Eine benannte Formel][
  $ integral_a^b f'(x) dif x = f(b) - f(a) $
  #note[Hauptsatz der Differential- und Integralrechnung.]
]

#warn[
  Der eigenständige Block für eine Stolperfalle, die Raum braucht.
  #danger[Nur für stetige $f$.]
]

#facts[Merkpunkte][
  - #item[Marke][Der Eintrag mit benanntem Kopf.]
  - Eine blosse Aussage ohne Marke.
]

#tabular(
  title: [Übersicht], cols: (1, 1.4),
  [Fall], [Bedingung],
  [A], [$x > 0$],
  [B], [$x <= 0$],
)
