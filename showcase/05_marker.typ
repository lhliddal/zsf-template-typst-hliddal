#import "@local/zsf:0.1.0": *

= Marker und Verweise <ch:marker>

Inline-Betonung trägt keine Farbe: Ein eingefärbtes Wort stört den Absatz und
sagt nichts, was die Seite nicht ohnehin zeigt. Farbe ist reserviert für
Kapitel-Identität auf Flächen, den Wegweiser zum Ziel eines Verweises und die
Zuordnung in Formeln.

== Die Marker <sec:markerliste>

#facts[Was wofür][
  - #item[kw][Fachbegriff und primärer Scan-Anker. Landet automatisch im
    Register — #kw[Konvergenzradius] ist so ein Fall. `kw(index: false)` ist
    der Begriff, der ausnahmsweise nicht hinein soll.]
  - #item[lbl][Neutrale Beschriftung ohne Fachbegriff-Semantik. Kein
    Registereintrag: #lbl[Eingabe], #lbl[Ausgabe].]
  - #item[danger][#danger[Nur für $x eq.not 0$] — die Inline-Pille für die
    kurze Warnung innerhalb einer Box.]
  - #item[concl][#concl[Daraus folgt die Behauptung.]]
  - #item[hl][#hl[Die eine Aussage, die in der Prüfung zählt.] Sparsam,
    sonst flacht das Signal ab.]
]

== Verweise <sec:verweise>

#panel(weight: "quiet")[Drei Formen][
  #lbl[xref] springt mit Pfeil und trägt die Farbe des Zielkapitels:
  #xref(<ch:tabellen>) und #xref(<sec:markieren>).

  #lbl[secref] ist die kompakte Zielnummer für lokale Übersichten:
  Tabellen #secref(<ch:tabellen>), Formeln #secref(<ch:formeln>),
  Bilder #secref(<ch:bilder>).

  #lbl[script-ref] verweist auf das Skript: #script-ref(42)
]

#panel(tone: "neutral")[Der Ink-Vertrag][
  Ein Marker auf gefärbter Fläche erbt deren Kontrastfarbe automatisch — auch
  hier im Titel eines Balkens. Das ist keine gepflegte Liste von Flächen,
  sondern eine Ableitung: Wer die Textfarbe setzt, besitzt die Tinte.
  Deshalb bleibt #kw(index: false)[dieser Begriff] und #xref(<ch:regler>) auf jeder Fläche
  lesbar.
]

== Register <sec:register>

#panel[Was hineingehört][
  Ein Wort kommt hinein, wenn es ein Name ist, den jemand gezielt ansteuert.
  #kw[Stetigkeit], #kw[Eigenwert], #kw[Konvergenz] — an dem einen Ort, wo das
  Nutzbare steht.
  #idx-see("EW", "Eigenwert")
  #idx-see("Grenzwert", "Konvergenz")
  #idx("Lemma von Zorn")
  #lbl[idx] setzt einen unsichtbaren Eintrag, #lbl[idx-see] einen Verweis auf
  einen anderen Begriff.
]
