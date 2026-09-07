#import "@local/zsf:0.1.0": *
#import "tools.typ": muster, kurz, zweck, eintrag

= Struktur <kat:struktur>

Kapitel und Abschnitte sind normale Überschriften. Die drei Ebenen und der
Dokumentkopf sind hier nicht als Eintrag darstellbar — sie stehen um diesen
Text herum und sind an jeder Kapitelgrenze dieses Dokuments zu sehen.

== Die Ebenen <kat:ebenen>

=== Dritte Ebene

#eintrag[B-01][`=` · `==` · `===`][
  Kapitel gesättigt, Abschnitt aufgehellt, Unterabschnitt nur getönt. Alle
  drei sind Show-Regeln auf `heading`, kein eigenes Makro.
]
#zweck("B-01", none)[Gliederung, die von selbst nummeriert, verlinkt und ins Register zeigt.]

#eintrag[B-02][`front(titel, short:, anchor:)`][
  Unnummeriertes Kapitel, trägt Slot 0. `short` ist der Wegweiser, der im
  Register an Stelle einer Abschnittsnummer erscheint; `anchor: <ze>` macht das
  Kapitel verweisbar — ein Label daneben zeigte auf das vorhergehende.
]
#zweck("B-02", "front")[Front-Matter und das Register selbst.]

#eintrag[B-03][`newcol()`][
  Der einzige Spaltenumbruch im System; steht immer sichtbar im Aufruf.
]
#zweck("B-03", "newcol")[Ein Kapitel bewusst auf einer neuen Spalte beginnen.]

#eintrag[B-04][Dokumentkopf][
  Entsteht aus `title` und `author` in `zsf(...)`, steht im Spaltenfluss und
  ist eine Spalte breit. Oben links auf Seite 1 zu sehen.
]
#zweck("B-04", none)[Wem gehört dieses Blatt, und was steht darauf.]
