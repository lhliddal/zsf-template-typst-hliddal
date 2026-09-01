---
name: 30_struktur
scope: chapters
purpose: Überschriften, Marker, Verweise, Farbe, Register
---

## Gliederung sind normale Überschriften

```typ
= Kapitel <ch:name>          // Balken in der Kapitelfarbe, auto-nummeriert
== Abschnitt <sec:name>      // getönter Balken
=== Unterabschnitt           // Akzentkante, nur bei echter fachlicher Tiefe
#front("Zeichen & Einheiten", short: "Z&E")   // unnummeriert, Slot 0
#newcol()                    // bewusster Spaltenumbruch, vor die Überschrift
```

Kapitel bringen dadurch Gliederung, PDF-Lesezeichen und die Registernummern
von selbst mit.

**Zeilenumbruch im Satz ist native Typst-Syntax**, kein Makro: `5~kg` bindet
Zahl und Einheit, `Donau\-dampf\-schiff` gibt eine Trennstelle vor,
`#sym.zws` erlaubt eine. Sparsam — häufen sie sich, ist der Text zu lang für
die Spalte.

Ein Front-Kapitel wird über **`anchor`** verweisbar: `#front("Zeichen &
Einheiten", short: "Z&E", anchor: <ze>)`. Ein Label daneben hinge an der Marke
**vor** der Überschrift, und `xref` läse dort die Nummer des vorhergehenden
Kapitels ab — falsch, ohne Meldung. Register und Verweis zeigen das Kurzlabel.

`short:` bei `front` ist der Kurz-Wegweiser, der im Register an der Stelle
einer Abschnittsnummer erscheint — ein Front-Kapitel hat keine.

## Kapitelfarbe

18 Slots. Slot 0 gehört dem Front-Matter (ETH-Blau), nummerierte Kapitel
rotieren über die übrigen 17.

Die drei Gliederungsebenen sind verschieden laut: Kapitel gesättigt mit weisser
Schrift, Abschnitt aufgehellt mit weisser Schrift, Unterabschnitt nur getönt mit
dunkler. Jede Stufe hat über alle 18 Slots hinweg dieselbe Helligkeit und damit
denselben Kontrast — im Katalog nachgeschlagen unter »Palette«. Die Farbe wird aus dem Überschriften-Zähler
**abgeleitet** und ist kein Zustand — sie kann an keiner Stelle veralten.
Kapitelfarben nie hart schreiben; die Töne holen sie sich selbst.

## Inline-Marker

| Marker | Wofür |
|---|---|
| `kw[…]` | Fachbegriff, primärer Scan-Anker — **landet automatisch im Register** |
| `lbl[…]` | neutrale Beschriftung ohne Fachbegriff-Semantik, kein Registereintrag |
| `danger[…]` | Inline-Pille für eine kurze Warnung innerhalb einer Box |
| `concl[…]` | leitet eine Folgerung ein (⇒) |
| `hl[…]` | die prüfungskritischste Aussage einer Box, sparsam |

`kw` und `lbl` sehen gleich aus und unterscheiden sich allein in der Bedeutung.
Nach der Bedeutung wählen, nicht nach dem Aussehen. `kw(index: false)[…]` ist
der Fachbegriff, der ausnahmsweise nicht ins Register soll.

**Inline-Betonung trägt keine Farbe.** Farbe ist für drei Dinge reserviert:
Kapitel-Identität auf Flächen, den Wegweiser zum Ziel eines Verweises, und die
Zuordnung in Formeln.

## Verweise

`xref(<label>)` springt mit Pfeil und in der Farbe des Zielkapitels — einsetzen,
wenn der Sprung in der Prüfung Suchzeit spart. `secref(<label>)` ist die
kompakte Zielnummer für lokale Übersichten. `script-ref(42)` verweist auf die
Skript-Seite. Ein Verweis ins Leere bricht den Build.

## Der Ink-Vertrag

Ein farbtragender Marker auf einer Fläche, die ihre eigene Textfarbe setzt,
erbt deren Kontrastfarbe automatisch und bleibt lesbar. Das ist keine gepflegte
Liste von Flächen, sondern eine Ableitung — wer eine neue gefärbte Fläche baut,
muss dafür nichts tun.

Die eine Folgerung fürs Schreiben: Ein `xref` im Titel eines Balkens ist erlaubt
und lesbar, verliert dort aber seine Wegweiser-Farbe. Wo die Farbe die
eigentliche Information ist, gehört der Verweis in den Boxinhalt.

## Register

Ein Eintrag zeigt auf die **Abschnittsnummer** in der Farbe des Zielkapitels;
bei genau einer Fundstelle zusätzlich auf die Druckseite.

```typ
#kw[Stetigkeit]                         // markiert und indexiert zugleich
#idx("Lemma von Zorn")                  // unsichtbarer Eintrag
#idx-see("EW", "Eigenwert")             // »EW, siehe Eigenwert«
#idx("Zählers", sort: "Zähler")         // abweichender Sortierschlüssel
```

Ausgegeben wird das Register mit `make-index()` unter einem `front`-Kapitel am
Dokumentende.

Umlaute brauchen keinen Sortkey: Sortiert wird nach DIN 5007-1 (ä wie a,
ß wie ss).

**Was hineingehört:** ein Name, den jemand gezielt ansteuert — eine benannte
Grösse, ein Gesetz, eine Regel, ein Verfahren, ein Objekt. An dem *einen* Ort,
wo es definiert oder anwendbar ist, nicht bei jeder Erwähnung. Massstab ist
Auffindbarkeit unter Zeitdruck, nicht Vollständigkeit.

**Der grösste Hebel** ist das Treffen der Wörter, die jemand tatsächlich sucht:
Abkürzungen (`idx-see("DGL", "Differentialgleichung")`), Eponyme in beide
Richtungen, Einheiten und Symbole auf den Sachbegriff, die Nominalform zu einem
nur adjektivisch erwähnten Konzept, typische »wie mache ich X«-Suchen.

`kw` nur auf **Begriffe** anwenden, nie auf ganze Sätze — sonst landet der Satz
als Registereintrag.
