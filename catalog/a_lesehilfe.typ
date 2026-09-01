#import "@local/zsf:0.1.0": *
#import "tools.typ": muster, zweck

#front("Lesehilfe", short: "Kat")

Jeder sichtbare Baustein des Templates einmal, mit identischem Mustertext. Was
sich zwischen zwei Einträgen unterscheidet, ist deshalb der Baustein und nie
der Inhalt.

#panel[A-00 · Aufbau eines Eintrags][#muster]
#zweck[Der Titel trägt ID und Bausteinnamen, der Inhalt ist überall derselbe,
diese Zeile nennt den Zweck.]

#panel(weight: "quiet")[Die drei Teile][
  #lbl[ID:] adressierbar — »D-11 raus« genügt als Auftrag. \
  #lbl[Name:] der Baustein oder der Regler samt Wert. \
  #lbl[Zweckzeile:] wofür er gedacht war, in einem Satz.
]

#tabular(
  title: [Wo was steht], cols: (0.34, 1.0, 1.6),
  [ID], [Kap.], [Inhalt],
  [B], secref(<kat:struktur>), [Kapitel, Balken, Umbruch],
  [C], secref(<kat:boxen>), [die Bausteine],
  [D], secref(<kat:regler>), [jeder Regler, jeder Wert],
  [E], secref(<kat:tabellen>), [tabular],
  [F], secref(<kat:marker>), [Inline-Semantik, Verweise],
  [G], secref(<kat:formeln>), [Bilder und Formelsatz],
  [H], secref(<kat:inventar>), [Liste: Name, Modul, Art],
)
#zweck[B bis G zeigen, wie ein Baustein aussieht. H sagt, was er ist und in
welcher Datei er lebt — die beiden Fragen nach der Entscheidung.]

#panel(tone: "neutral", weight: "quiet")[Vollständigkeit][
  Die Liste in H wird beim Bauen aus `lib.typ` und `src/config.typ` gelesen,
  nicht gepflegt. Sie kann deshalb nicht veralten — anders als im Vorgänger,
  wo sie von Hand nachgeführt wurde.
]
#zweck[Was das System kann, steht im System; der Katalog liest es ab.]

#warn[Kein Prüfgegenstand][
  Dieses Dokument prüft nichts und wird von nichts geprüft. Die Vorführpflicht
  der öffentlichen API hängt an #lbl[showcase/]; ein hier gestrichener Eintrag
  verschwindet nicht aus dem System.
]
