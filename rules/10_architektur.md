---
name: 10_architektur
scope: project
purpose: Verzeichnisse, Package/Fork-Trennung, wo was hingehört
---

Das Template ist ein **Typst-Package**. Es hat zwei Rollen, und die sind
strukturell getrennt statt durch Marker im selben Text:

| Verzeichnis | Rolle |
|---|---|
| `lib.typ`, `src/` | das System — die einzige Stelle mit Gestaltung |
| `template/` | was ein Fach-Fork bekommt (`typst init` kopiert nur das) |
| `showcase/` | die Referenz: jeder Baustein im Fluss einer echten ZSF |
| `catalog/` | dieselben Bausteine nebeneinander, mit ID und Mustertext |
| `fonts/` | Carlito und NewCM Sans Math, mitgeliefert |
| `tests/`, `rules/` | Harness und Regelwerk |

**Zwei Dokumente.** `showcase/` zeigt die Bausteine im Fluss einer echten ZSF
und ist die Grundlage von `make coverage`. `catalog/` reiht dieselben Bausteine
mit **identischem Mustertext** nebeneinander, jeder mit einer ID (»D-11 raus«
genügt als Auftrag) — ein Arbeitsinstrument fürs Aussortieren, das nichts prüft
und von nichts geprüft wird. Sein Inventar liest die API beim Bauen aus dem
Quelltext und kann nicht veralten.

Ein Fork entsteht mit `make fork NAME=zsf-fach-fs2026`. Er enthält `main.typ`,
`chapters/`, `graphics/` und ein eigenes Makefile — sonst nichts. Weil der
Katalog gar nicht erst mitkommt, gibt es keine »template-only«-Blöcke, kein
Strip-Skript und keinen Verifier dafür.

## Die Module in `src/`

| Datei | Inhalt |
|---|---|
| `config.typ` | die Stellschrauben, ihre Vorbelegungen und **alle** abgeleiteten Masse |
| `palette.typ` | die 18 Kapitel-Slots, Ton-Ableitung, Ink-Vertrag, gedämpfte Tinte |
| `knobs.typ` | Reglerwerte nachschlagen, unbekannte Regler abweisen |
| `readability.typ` | Umbruchschutz: Zahl und Einheit bleiben zusammen |
| `structure.typ` | Balken, Kapitelfarbe, `front`, `newcol`, Kopf und Fuss |
| `blocks.typ` | die Box und ihre Vorbelegungen, Trenner, Listen, Ketten |
| `tables.typ` | `tabular` |
| `media.typ` | `fig`, `fig-side`, `caption`, das Bild-Höhenbudget |
| `markup.typ` | Inline-Marker, Verweise, Formel-Marker, Grössenfarben |
| `maths.typ` | die Operatoren, die Typst nicht mitbringt |
| `index.typ` | Register: Eintrag, Sortierung, Ausgabe |

**Farbe gehört nach `palette.typ`, ein Reglerwert in eine Tabelle.** Beides
meldet der Linter bzw. `pick(name, wert, tabelle)` selbst: Nachschlagen **ist**
die Prüfung, und eine if-Kette gäbe einem unbekannten Wert still die
Vorbelegung.

**Masse haben genau eine Rechenstelle.** Jede Länge wird in `config.typ` aus
den Stellschrauben gerechnet. Ein hartes `pt`/`mm`-Mass in einem anderen Modul
meldet `make lint` — relative Masse (`em`, `%`, `fr`) sind erlaubt, weil sie
mitskalieren.

## Beim Editieren von `src/`

- Neue Gestaltungsmasse nach `config.typ`, nicht daneben.
- Farbe kommt aus dem Ton, nie direkt: `tone-of(accent)` liefert alle Rollen.
- Wer eine neue gefärbte **Fläche** baut, setzt dort eine Textfarbe — damit
  erbt jeder Marker darauf automatisch den Kontrast (`30_struktur` → Ink).
- Prüffrage vor jedem Eingriff: *Eckenradius aller Boxen ändern — reicht eine
  Zeile?* Lautet die Antwort nein, fehlt Modularität.
