---
name: 02_mandat
scope: project
purpose: Arbeitsteilung, Katalog-Ökonomie, Verhalten an den Rändern
---

Diese Regel beschreibt, **wofür das Template existiert und was die KI daran
tut**. Bei Zweifeln über Aufwand, Freiheit oder Zuständigkeit entscheidet sie.

> **Der Job der KI ist Inhalt. Gestaltung ist Auswahl, nicht Entwurf.**

Fliesst ein spürbarer Teil des Aufwands in Layout, Abstände oder Darstellung,
ist das ein Befund über das Template, kein Fleiss-Problem. Er gehört gemeldet,
nicht durch Mehrarbeit ausgeglichen.

## Was erlaubt ist

- **Auswahl** — pro Stelle den passenden Baustein wählen (`20_bausteine`,
  `30_struktur`, `40_tabellen`, `50_formeln`).
- **Regler** — pro Stelle die benannten Argumente des Bausteins setzen.
- **Stellschrauben** — pro ZSF einmalig in `zsf(...)` in `main.typ`.

**Nicht erlaubt:** eigene Bausteine oder Funktionen in Kapiteln, lokale
Schriftgrössen, lokale Abstände, direkte Farbgriffe, Layout-Handarbeit. Die
Grenze ist nicht Geschmack, sondern Ort: Gestaltung lebt in `src/`, Inhalt in
den Kapiteln. Eine Gestaltungsentscheidung in einer Kapiteldatei steht per
Definition am falschen Ort — auch wenn das Resultat gut aussieht.

Die **Spaltenzahl** ist hier anders als im LaTeX-Vorgänger eine ganz normale
Stellschraube (`columns`), weil nichts mehr auf vier Spalten geeicht ist. Der
Standard bleibt vier; ihn zu ändern ist eine bewusste Entscheidung des Nutzers,
kein Weg der KI, Platz zu gewinnen.

## Katalog-Ökonomie — ein Regler schlägt einen neuen Baustein

Der Katalog soll **vielseitiger** werden, nicht **grösser**.

1. **Erst der Regler.** Trägt ein vorhandener Baustein den Fall mit einem
   zusätzlichen benannten Argument, ist das die Lösung.
2. **Doppelte Lösungen sind ein Defekt.** Zwei Wege zum selben Ergebnis sind
   eine offene Frage, die jede künftige Verwendung neu beantworten muss.
3. **Gleiche Sache, gleiche Bedienung.** Bausteine derselben Familie nehmen
   ihre Argumente in derselben Form entgegen: `#baustein[Titel][Rumpf]`,
   Regler als benannte Argumente.

Ein neuer Baustein wird nie eigenmächtig angelegt; ein Vorschlag dafür nennt
zuerst, welcher vorhandene Baustein den Fall mit welchem Regler tragen könnte.

## Randverhalten I — kein passender Baustein

> **Lücke benennen, nicht füllen.**

1. Zuerst prüfen, ob ein vorhandener Baustein den Fall trägt. Meist trägt er.
2. Trägt er nicht: die Lücke dem Nutzer nennen, mit dem konkreten Fall. Nicht
   lokal improvisieren, auch nicht »nur diesmal«.
3. Ist etwas Neues nötig, gehört es nach `src/` und über den Nutzer — und
   zuerst als Regler an einem vorhandenen Baustein.

Lokale Notausgänge (`#v()`, `#text(size:)`, eigene `#let` in Kapiteln, direkte
Farben) sind nicht das kleinere Übel, sondern das Symptom. `make lint` meldet
sie. **Die Meldungen sind Daten, keine Schelte:** Jeder Notausgang benennt einen
Baustein, dem ein Regler fehlt.

## Randverhalten II — Inhalt

> **Inhalte nie eigenmächtig ändern, ergänzen, kürzen oder »korrigieren«.**

Keine zusätzlichen Sonderfälle, keine Präzisierungen, kein ungefragtes
Vervollständigen. Ausführlich in `80_didaktik`. Wer den Drang verspürt, etwas
fachlich »besser« zu machen, ist an dem Punkt, an dem gefragt und nicht
gehandelt wird.
