#import "@local/zsf:0.1.0": *
#import "tools.typ": muster, zweck

#front("Lesehilfe", short: "Kat")

Jeder sichtbare Baustein des Templates einmal, mit identischem Mustertext. Was
sich zwischen zwei Einträgen unterscheidet, ist deshalb der Baustein und nie
der Inhalt.

#panel[A-00 · Aufbau eines Eintrags][#muster]
#zweck("A-00", none)[Der Titel trägt ID und Bausteinnamen, der Inhalt ist überall derselbe,
diese Zeile nennt den Zweck.]

#panel(weight: "quiet")[A-01 · Die drei Teile][
  #lbl[ID:] adressierbar — »D-11 raus« genügt als Auftrag. \
  #lbl[Name:] der Baustein oder der Regler samt Wert. \
  #lbl[Zweckzeile:] wofür er gedacht war, in einem Satz.
]

#tabular(
  title: [A-02 · Wo was steht], cols: (0.34, 1.0, 1.6),
  [ID], [Kap.], [Inhalt],
  [B], secref(<kat:struktur>), [Kapitel, Balken, Umbruch],
  [C], secref(<kat:boxen>), [die Bausteine],
  [D], secref(<kat:regler>), [jeder Regler, jeder Wert],
  [E], secref(<kat:tabellen>), [tabular],
  [F], secref(<kat:marker>), [Inline-Semantik, Verweise],
  [G], secref(<kat:formeln>), [Bilder und Formelsatz],
  [H], secref(<kat:inventar>), [Liste: Name, Modul, Art],
)
#zweck("A-02", none)[B bis G zeigen, wie ein Baustein aussieht. H sagt, was er ist und in
welcher Datei er lebt — die beiden Fragen nach der Entscheidung.]

#panel(tone: "neutral", weight: "quiet")[A-03 · Vollständigkeit][
  Die Liste in H wird beim Bauen aus `lib.typ` und `src/config.typ` gelesen,
  nicht gepflegt. Sie kann deshalb nicht veralten — anders als im Vorgänger,
  wo sie von Hand nachgeführt wurde.
]
#zweck("A-03", none)[Was das System kann, steht im System; der Katalog liest es ab.]

#warn[A-04 · Kein Prüfgegenstand][
  Dieses Dokument prüft nichts und wird von nichts geprüft. Die Vorführpflicht
  der öffentlichen API hängt an #lbl[showcase/]; ein hier gestrichener Eintrag
  verschwindet nicht aus dem System.
]
#zweck("A-04", none)[Was hier steht, ist ein Vorschlag zum Streichen — kein Befund.]
