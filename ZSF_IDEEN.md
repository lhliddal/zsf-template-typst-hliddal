# ZSF-Ideen (Prüfungsnavigation)

> Kuratierte Empfehlungen und Transfermuster — **kein verbindlicher Standard**.
> Das Template schreibt den Fach-ZSF nichts vor (siehe `rules/00_meta.md`):
> Was hier steht, ist die Default-Haltung des Templates, von der jeder Fork
> jederzeit bewusst abweichen darf.

## Default-Haltung des Templates

- **Fett-Anker:** Den ersten entscheidenden Scan-Begriff semantisch markieren (`#kw[...]`);
  Wiederholungen normal setzen. Bei aktivem Index reine Wiederholungsanker mit
  `#kw(index: false)[...]` vom Register entkoppeln.
- **Hierarchie:** Standardmässig zwei nummerierte Ebenen (`=`, `==`). Eine dritte Ebene
  (`===`) nur bei echter Lookup-Tiefe; sie ist kleiner und heller als der Hauptabschnitt.
- **Papierverweise:** `#xref(<ze>)` für Fernsprünge mit farbiger Abschnittsnummer,
  `#sec-ref(<ze>)` für lokale Router und Tabellenübersichten.
- **Rhythmus:** Abstände, Display-Mathematik, Tabellen und Boxen nur über zentrale
  Tokens und Regler (`#gap("s")`, `#sep()`, etc.); keine lokalen Korrekturketten.
- **Drucknavigation:** Kontrastreiche Seitenzahl im drucksicheren Bereich;
  Kapitelnummer und Farbe bleiben redundante Wegweiser.

## Selektive Transfermuster

- **Informatik:** `chapterindex` nur für aussergewöhnlich lange Nachschlagekapitel.
- **Lineare Algebra:** Äquivalenzlisten nur dort, wo echte fachliche Äquivalenzen bestehen.
- **Physik:** Symbol- und Einheiten-Frontmatter (`#quantity("Name", $Symbol$)`) nur für
  stark notationslastige Fächer.
- **Vier Spalten:** Standard für jede ZSF; das Layout und die Bausteine sind darauf optimiert.
  Keine Reduktion auf drei Spalten nur für Code — das Template setzt Code vier-spaltig sauber.
- **Verfahren:** `#steps` und „Wann verwenden“ nicht als Template-Pflicht; nur selektiv, wenn
  die Prüfungsaufgabe tatsächlich einer stabilen Schrittfolge folgt.

## Nicht als Default übernehmen

- Maximalverdichtung um jeden Preis, Vollregister für jedes Fach, unkritische Variablenregister,
  erzwungene dritte Ebenen oder pauschale Kapitelstarts auf neuer Spalte (`#newcol()`).
