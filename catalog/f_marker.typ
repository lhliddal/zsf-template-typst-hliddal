#import "@local/zsf:0.1.0": *
#import "tools.typ": zweck, eintrag

#newcol()
= Marker und Verweise <kat:marker>

Inline-Semantik. Jeder Eintrag zeigt denselben Satz, damit der Unterschied die
Auszeichnung ist.

#eintrag[F-01][kw][
  Mustertext mit einem #kw[Fachbegriff] zum Formvergleich.
]
#zweck("F-01", "kw")[Fachbegriff und primärer Scan-Anker; landet automatisch im Register.]

#eintrag[F-02][kw(index: false)][
  Mustertext mit einem #kw(index: false)[Fachbegriff] zum Formvergleich.
]
#zweck("F-02", none)[Derselbe Marker, ohne Registereintrag.]

#eintrag[F-03][lbl][
  Mustertext mit einer #lbl[Beschriftung] zum Formvergleich.
]
#zweck("F-03", "lbl")[Neutrale Beschriftung ohne Fachbegriff-Semantik.]

#eintrag[F-04][danger][
  Mustertext mit #danger[Nur für stetige f] zum Formvergleich.
]
#zweck("F-04", "danger")[Inline-Pille für eine kurze Warnung innerhalb einer Box.]

#eintrag[F-05][concl][
  #concl[Mustertext zum Formvergleich.]
]
#zweck("F-05", "concl")[Leitet eine Folgerung ein.]

#eintrag[F-06][hl][
  Mustertext mit #hl[der einen Aussage] zum Formvergleich.
]
#zweck("F-06", "hl")[Die prüfungskritischste Zeile einer Box.]

#eintrag[F-07][xref][
  Mustertext mit einem Verweis #xref(<kat:boxen>) zum Formvergleich.
]
#zweck("F-07", "xref")[Sprung mit Pfeil, in der Farbe des Zielkapitels.]

#eintrag[F-08][secref][
  Mustertext mit der Zielnummer #secref(<kat:boxen>) zum Formvergleich.
]
#zweck("F-08", "secref")[Kompakte Nummer für lokale Übersichten.]

#eintrag[F-09][script-ref][
  Mustertext mit einem Skriptverweis #script-ref(42) zum Formvergleich.
]
#zweck("F-09", "script-ref")[Verweis auf die Seite im Vorlesungsskript.]

#eintrag[F-10][diagram-label][
  Mustertext mit #diagram-label[Achsenbeschriftung] zum Formvergleich.
]
#zweck("F-10", "diagram-label")[Die kalibrierte Grösse für Beschriftung in einer Zeichnung.]

#eintrag[F-11][idx · idx-see][
  Mustertext zum Formvergleich; beide Einträge sind unsichtbar.
  #idx("Katalogeintrag")
  #idx-see("Kat", "Katalogeintrag")
]
#zweck("F-11", ("idx", "idx-see"))[Registereintrag ohne Auszeichnung und Verweis auf einen anderen Begriff.]

#panel(tone: "neutral", weight: "quiet")[F-12 · Ink-Vertrag][
  Auf einer gefärbten Fläche erbt jeder Marker deren Kontrastfarbe:
  #kw(index: false)[Fachbegriff] und #xref(<kat:boxen>) bleiben lesbar.
]
#zweck("F-12", none)[Kein Regler, sondern eine Ableitung — wer die Textfarbe setzt, besitzt sie.]
