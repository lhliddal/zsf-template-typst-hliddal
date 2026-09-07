# ZSF Template (Typst) — AGENTS.md

> ERZEUGT — rules-hash:f29215157f8ca01e
>
> Quelle: `rules/*.md`. Nicht direkt bearbeiten.
> Ändern: `rules/*.md` editieren → `make sync-rules`. Drift: `make check-rules`.

Kompiliertes Regelwerk für KI-Agenten. Diese Datei ist eigenständig —
sie enthält alle Projekt-Regeln.

## Befehle

```bash
make build      # Katalog bauen (im Fork: die ZSF)
make watch      # live nachbauen
make check      # der ganze Harness
make fork NAME=zsf-fach-fs2026
```

## Regel-Index

- `00_meta.md` — project — Zweck, Sprache, kritische Regeln
- `02_mandat.md` — project — Arbeitsteilung, Katalog-Ökonomie, Verhalten an den Rändern
- `10_architektur.md` — project — Verzeichnisse, Package/Fork-Trennung, wo was hingehört
- `15_stellschrauben.md` — project — Was pro ZSF einmalig entschieden wird
- `20_bausteine.md` — chapters — Der Baustein-Katalog und seine Regler
- `30_struktur.md` — chapters — Überschriften, Marker, Verweise, Farbe, Register
- `40_tabellen.md` — chapters — Tabellen
- `50_formeln.md` — chapters — Mathematischer Satz
- `60_workflow.md` — project — Bauen, prüfen, forken, Dateien platzieren
- `70_github.md` — project — Namenskonventionen, PDF-Identity, Commit-Attribution
- `80_didaktik.md` — chapters — Inhaltliches Prinzip — was drinsteht und wie erklärt wird

## Regeln

### `00_meta.md`

Fächerunabhängiges Typst-Template für Prüfungs-Zusammenfassungen: A4 quer,
vier Spalten, dicht gesetzt. Gestaltung liegt vollständig im Package (`src/`);
Kapitel enthalten ausschliesslich Fach-Inhalt.

**Zweck der ZSF:** Prüfungsvorbereitung — sie wird in der Prüfung benutzt.
Schnelle Auffindbarkeit und visuelle Klarheit haben höchste Priorität.

**Zweck des Templates:** ein Leitplankensystem für KI-Autorschaft. Es existiert,
damit eine KI die ZSF-Ziele erreichen kann, ohne Gestaltung zu erfinden — und
ohne sie erfinden zu können. Ausformuliert in `02_mandat`.

**Verhältnis zu Forks:** Das Template ist Ausgangspunkt und Referenz.
`make fork NAME=…` erzeugt einen Fach-Fork; danach entwickelt sich dieser
eigenständig. Kein Sync-Zwang, keine Rückflusspflicht — Drift ist Normalbetrieb.
Daraus folgen zwei Verpflichtungen: Der Fork-Weg muss am Tag 1 funktionieren,
und der Katalog muss die technisch korrekte Fassung zeigen, in der man
nachschlägt, wie etwas gemeint ist.

## Seitenbudget

Ein Seitenlimit wird pro Fork festgelegt. Die KI berücksichtigt, prüft oder
optimiert es **nur auf ausdrückliche Aufforderung** — auch in der
Verdichtungsphase. Auf Nachfrage nennt sie den Stand und weist prüfungsrelevante
Seiten und ein allfälliges Schlusswort getrennt aus.

## Kritische Regeln

- **Inhalte niemals ändern, kürzen oder vereinfachen** ohne expliziten Befehl.
- Keine neuen Pakete oder Bausteine ohne Anfrage.
- **Sprache:** Inhalte auf Deutsch, Schweizer Rechtschreibung — `ss` statt `ß`,
  echte Umlaute statt `ae`/`oe`/`ue`. Technische Begriffe auf Englisch erlaubt.
  Bezeichner, Labels und Dateinamen auf Englisch und in ASCII.
- Formeln in Chat-Antworten immer als gerenderte Formelblöcke zeigen, nie als
  Roh-Syntax oder Codeblock. Gilt nicht für `.typ`-Dateien und Patches.
- Erledigt ist eine Aufgabe erst nach erfolgreichem `make build` (`60_workflow`).

### `02_mandat.md`

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

### `10_architektur.md`

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

### `15_stellschrauben.md`

Alle globalen Entscheidungen sind benannte Argumente von `zsf(...)` in
`main.typ`. **Was hier nicht steht, wird nicht pro ZSF entschieden**, sondern
pro Stelle über einen Regler am Baustein (`20_bausteine`) — oder gar nicht.

```typ
#show: zsf.with(
  title: "Analysis II FS2026",
  author: "Loris Hliddal",
  size: 7pt,
  density: 0.85,
)
```

Ein unbekannter Name bricht den Build und nennt die bekannten; `make check`
prüft zusätzlich jede Schraube am gerenderten Satz auf Wirkung.

## Identität

| Name | Vorbelegung | Wirkung |
|---|---|---|
| `title` | `"Zusammenfassung"` | Dokumentkopf und PDF-Titel |
| `author` | `""` | Zeile unter dem Titel im Dokumentkopf, und PDF-Autor |
| `subject` | `""` | nur PDF-Keywords — auf der Seite unsichtbar |
| `release`, `build` | aus `sys.inputs` | Kennungen; das Makefile setzt sie |

## Grösse und Dichte

| Name | Vorbelegung | Wirkung |
|---|---|---|
| `size` | `8pt` | Grundgrösse; nimmt den ganzen Satz mit, Verhältnisse bleiben |
| `content-scale` | `1.0` | wie laut der Bausteininhalt neben den Balken steht |
| `prose-scale` | `1.0` | wie laut die verbindende Prosa neben den Bausteinen steht |
| `leading` | `1.0` | Zeilenhöhe |
| `density` | `1.0` | alles Vertikale, das reiner Leerraum ist |
| `density-blocks` | `1.0` | nur die Abstände der Bausteine |
| `density-text` | `1.0` | nur der Absatzabstand im Fliesstext |
| `density-tables` | `1.0` | nur Zell- und Zeilenabstand |
| `density-structure` | `1.0` | nur Balkenpolsterung und der Abstand zu ihrem Inhalt |

**Drei Grössen-Regler, drei Fragen.** `size` verschiebt alles gemeinsam; die
beiden Rollen-Faktoren je **eine** Inhaltsart gegen die Balken, die stehen
bleiben — `content-scale` alles **in** einem Baustein (Boxtext, Zelle, Formel,
beide `font`-Stufen), `prose-scale` den Text, der zu **keinem** gehört.
`content-scale` ist der Regler, wenn der Inhalt an eine **Breite** stösst: ob
eine Formel in einer zweispaltigen Zelle einzeilig bleibt, entscheidet er
allein — über `size` gelöst schrumpfen die Balken mit.

**Reihenfolge beim Platzsparen:** `size` (grösster Hebel), dann `density`,
zuletzt `leading` — danach das PDF auf kollidierende Formelzeilen prüfen. Die
drei sind getrennt, weil unterschiedlich riskant: Abstände vertragen jede
Skalierung, die Zeilenhöhe enthält die Schrift selbst.

## Die 3-Ebenen-Regler-Pyramide (L1 / L2 / L3)

Das System steuert Abstände und Dichte hierarchisch über drei Ebenen:

| Ebene | Gilt für | Wo entschieden |
|---|---|---|
| **L1 Global** | das gesamte Dokument | `zsf(size: …, density: …, leading: …)` |
| **L2 Bereich** | eine Bausteinfamilie | `zsf(density-blocks: …, density-tables: …, …)` |
| **L3 Instanz** | eine einzelne Box | Regler am Baustein (`pad: …`, `weight: …`) |

Rechenweg: **effektives Mass = L1 × L2 × Basismass**.

**Warum L2 existiert (Schutz vor KI-Hacks):** Eine box-lastige ZSF braucht
engere Box-Polsterung bei unangetastetem Fliesstext. Ohne L2 bliebe einer KI nur,
lokale Abstände oder Notausgänge in Kapitel einzufügen. L2 erlaubt es, eine ganze
Familie zentral zu verdichten, ohne den Rest des Dokuments zu stauchen.

Für ein einzelnes Kapitel oder einen Anhang gibt es `density-scope(0.85)[…]`:
Es skaliert die Dichte lokal und erlaubt mit `breakable: true`, alle enthaltenen
Boxen durchlaufen zu lassen.

## Seite und Schrift

| Name | Vorbelegung | Wirkung |
|---|---|---|
| `columns` | `4` | Spaltenzahl |
| `margin` | `4mm` | Rand des Satzspiegels |
| `gutter` | `3.5mm` | Steg zwischen den Spalten |
| `font` | `"Carlito"` | Dokumentschrift |
| `math-font` | NewCM Sans Math | Formelschrift |
| `mono-font` | DejaVu Sans Mono | Code |
| `lang`, `region` | `"de"`, `"CH"` | Silbentrennung und Sprachregeln |
| `justify` | `false` | Blocksatz statt Flattersatz |
| `bind-units` | `true` | hält Zahl und Einheit in einer Zeile (`10 m/s`) |
| `check-overflow` | `false` | bricht bei überbreiten abgesetzten Formeln laut ab |

Flattersatz ist die Vorbelegung, weil der Blocksatz in ~50 mm schmalen Spalten
entweder trennen oder Wortzwischenräume aufblähen muss. `check-overflow: true`
prüft abgesetzte Formeln gegen den Satzspiegel und bricht bei Überlauf laut ab.

## Farbe und Bausteine

| Name | Vorbelegung | Wirkung |
|---|---|---|
| `palette` | 18 Slots | die Kapitelfarben (`30_struktur`) |
| `quantities` | `(:)` | Grössenfarben des Fachs (`50_formeln`) |
| `quantity-colors` | `true` | `false` nimmt sie für den S/W-Druck zurück, ohne die Vergabe anzutasten |
| `index-pages` | `true` | Register zeigt zusätzlich die Druckseite |
| `image-height` | `1.1cm` | Bildhöhe in einer Tabellenzeile |
| `figure-height` | `2.6cm` | Bildhöhe als eigener Block |

Die Bildhöhen sind Inhalt und kein Abstand — sie folgen der Dichte deshalb
nicht. Pro Stelle sticht ein `image(…, height: …)` die Vorbelegung.

### `20_bausteine.md`

## Aufruf-Konvention — für alle gleich

```typ
#baustein[Titel][Rumpf]        // mit Kopfzeile
#baustein[Rumpf]               // ohne
#baustein(regler: wert)[…][…]  // Regler sind benannte Argumente
```

Die Reihenfolge der Regler ist bedeutungslos, ein unbekannter Name bricht den
Build.

## Katalog

| Was wird ausgedrückt? | Baustein |
|---|---|
| Definition, Satz, gewichtige Aussage | `panel[Titel][…]` |
| Eigenschaft, kompakte Aussage | `panel(weight: "quiet")[Titel][…]` |
| Warnung, Stolperfalle | `warn[…]` (Titel vorbelegt mit »Achtung«) |
| Formel(n), evtl. mit Kontext | `formula[…]` |
| Benannte Formel | `formula(weight: "caption")[Name][…]` |
| Tabelle (einfach) | `tabular(title: […], cols: (…))[…]` (`40_tabellen`) |
| Container für Tabellen & Text | `tablebox[Titel][…]` (`pad: "none"`) |
| Textblock in randloser Box | `inset[…]` (erhält horizontalen Innenabstand) |
| Formel mit Notiz | `formula-line($…$, […])` |
| Abbildung aus Dateien | `fig(image("…"), cap: […])` |
| Selbstgezeichnetes Diagramm | `picture[Titel][…]` + `caption` |
| Bild neben Text | `fig-side(image("…"))[…]` |
| Aufzählung von Fakten | `facts[Titel][- …]` |
| Schritt-für-Schritt-Verfahren | `facts[Titel][+ …]` |
| Herleitung, Fallunterscheidung | `steps[Titel][…]` mit `case` |
| Code-Schnipsel | ``code[```python …``` ]`` — die Sprache steht am Codeblock |
| Zwei Blöcke nebeneinander | `split(links, rechts, ratio: 0.4)` |
| Vertikaler Blockabstand | `gap()` (`"xs"`, `"s"`, `"m"`, `"l"`, `"section"`) |
| Reiner Fliesstext | ein Absatz — kein Baustein nötig |

`warn`, `formula`, `picture`, `steps`, `code` und `tablebox` sind **Vorbelegungen von
`panel`**. Ein Name kommt nur dazu, wenn er eine eigene Absicht trägt *und*
eine Vorbelegung, die man sonst komponieren müsste.

## Die Regler

Alle gelten auf jeder Box, sofern sie die Eigenschaft hat.

| Regler | Werte (Vorbelegung zuerst) | Wirkung |
|---|---|---|
| `tone` | `auto`, `"neutral"`, `"warn"`, eine Farbe | die Farbwelt |
| `weight` | `"loud"`, `"quiet"`, `"caption"` | wohin der Titel geht |
| `pad` | `"normal"`, `"tight"`, `"none"`, `"bar"` | Innenabstand |
| `frame` | `"soft"`, `"strong"`, `"hard"`, `"none"` | Rahmenstärke |
| `surface` | `auto`, `"plain"`, `"quiet"`, `"emphasis"` | Flächen-Rolle |
| `align` | `left`, `center`, `right` | Justierung des Inhalts |
| `font` | `"normal"`, `"dense"` | Schriftgrösse des Inhalts |
| `tag` | Inhalt | Meta-Tag rechts im Titel |
| `breakable` | `false`, `true` | darf über die Spaltengrenze brechen |

**Ein Ton ist eine Farbe.** `tone: rgb("#8C6239")` genügt: Titelfläche, Flächen,
Rahmenstärken, Balken und Tabellenkopf werden daraus in OKLCH abgeleitet. Es
gibt keine Ton-Deklaration mit Pflichtrollen mehr.

**Wie laut was ist, liegt fest:** Der Titelbalken einer Box ist *hell mit
dunkler Schrift*, ihr Rumpf fast weiss. Gesättigt sind nur Kapitel- und
Abschnittsbalken, Tabellenkopf und der Warn-Ton — die vier Stellen, die von
weitem gefunden werden müssen.

`tone: "neutral"` heisst »gehört nicht zum Kapitelthema« (Konvention, Legende).
`weight: "quiet"` heisst »kompakt und dezent«. Beides sind Antworten auf eine
Inhaltsfrage, nicht auf »welche Box nehme ich«.

## Nutzungsregeln

- **Blockwechsel:** `sep()` trennt zwei Blöcke **innerhalb** einer Box,
  `sep(label: [Fall B])` benennt den folgenden. Wer stattdessen eine zweite Box
  danebenstellt, hat den Trenner nicht gefunden.
- **Der Ton gilt nach innen.** Was in einer Box steht, kennt ihren Ton: Der
  Trenner einer Warn-Box ist rot, die Glieder einer `steps(tone: "warn")` sind
  es auch. Es gibt dafür nichts zu setzen — `tone` an der Box genügt, und ein
  Baustein darin braucht ihn nicht ein zweites Mal.
- **Anmerkungen:** `note[…]` als dezente Zeile unter einer Formel.
- **Kollisionsfreie Formel-Notiz:** `formula-line($…$, […])` zentriert die Formel
  und setzt die Notiz rechtsbündig daneben. Bei Platzmangel weicht die Formel leicht aus
  oder bricht zweizeilig um, ohne jemals überdeckt zu werden.
- **Container vs. Inhalt:** `tablebox` ist der Rahmen (`pad: "none"`, `frame: "hard"`),
  `tabular` das Gitter. Dadurch kann eine Box mehrere Tabellen oder eine Tabelle mit
  erklärendem Text tragen: Textblöcke erhalten mit `inset[…]` horizontalen Innenabstand,
  während das Tabellenzebra bündig an den Rahmen stösst.
- **Text an eine Box binden:** `before[…]` gehört zur folgenden Box,
  `after[…]` zur vorhergehenden.
- **Listen:** Einträge sind native Listenpunkte (`-` bzw. `+`); `item[Marke][Text]`
  setzt nur die Marke. Die Marke ist optional — eine zu erfinden, nur damit die
  Form aufgeht, wäre eine Inhaltsänderung.
- **Ketten:** `case[Bedingung][Ausdruck][Resultat]` für den einzeiligen Fall;
  für mehrgliedrige Ketten `given` / `step` / `target` direkt.
- **Bilder:** Der Pfad steht immer im Kapitel (`image("graphics/x.svg")`), nie
  im Baustein-Aufruf. Die **Höhe stellt der Container**: in einer Tabellenzeile
  passt das Bild in die Zeile, in `fig` füllt es einen Block. `height` gehört
  nur an eine Stelle, die bewusst aus der Reihe fallen soll.
- **Beschriftung in Zeichnungen:** `diagram-label[…]` — nie ein lokales
  `#text(size: …)`. Für eine ganze `cetz`-Zeichnung einmal als deren
  `font`-Option setzen. Für echte Diagramme und Plots ist `cetz` zuständig und
  nicht dieses Template.
- **Farbe in Zeichnungen:** `tone()` gibt innerhalb von `context` die Farbwelt,
  in der die Zeichnung steht — `tone().accent`, `tone().rule`,
  `tone().frame-hard`. In einer Warn-Box ist die Skizze damit rot, ohne dass im
  Kapitel etwas steht. Ein `rgb(…)` im Kapitel meldet `make lint`.
- **Nebeneinander:** `split` ist ein eigener Baustein und kein Box-Regler —
  zwei Dinge nebeneinander ist eine Layout-Frage. Dadurch komponiert es in
  jeder Box.
- **Code:** Zeilen kurz halten. Eine Zeile, die in der schmalen Spalte
  umbricht, verliert dabei ihre Einrückung — das lässt sich nicht im Baustein
  reparieren, nur im Code selbst.
- **Umbruch:** Boxen sind atomar. `breakable: true` pro Box, wenn ein langes
  Register absichtlich durchlaufen soll. Titelbalken kleben von selbst an ihrem
  Inhalt; es gibt keine Reserven und keinen Pack-Modus mehr.
- **Vertikaler Abstand:** `gap()` setzt einen semantischen Abstand zwischen
  Blöcken (Vorbelegung `"m"`). Für einen Themenwechsel innerhalb einer Spalte
  ohne neuen Balken: `gap("section")`. Kollabiert dank `weak: true` sauber mit
  benachbarten Box-Rändern.
- **Bereichsweise Dichte:** `density-scope(0.85)[…]` verdichtet ein Kapitel oder
  einen Anhang punktuell; mit `breakable: true` werden alle enthaltenen Boxen
  durchlaufend.

### `30_struktur.md`

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

**Zahl und Einheit binden von selbst.** `10 m/s`, `95 %`, `20 °C` bleiben in
einer Zeile, ohne dass im Kapitel etwas steht (`bind-units`). Gebunden wird
nur ein Kürzel aus höchstens drei Buchstaben — `3 Fälle` bricht weiterhin
normal, sonst entstünden in einer 50 mm schmalen Spalte überlange Zeilen.

Für den Rest ist der Umbruch **native Typst-Syntax**, kein Makro:
`Donau\-dampf\-schiff` gibt eine Trennstelle vor, `#sym.zws` erlaubt eine,
`~` bindet von Hand. Sparsam — häufen sie sich, ist der Text zu lang für die
Spalte.

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

Die Registerform liest `kw` aus dem Begriff — auch aus einem ausgezeichneten
(`kw[Satz von *Taylor*]`). Steckt eine Formel darin, ist sie nicht lesbar und
der Build bricht ab: dann `kw(term: "C¹-Funktion")[$C^1$-Funktion]`.

**Inline-Betonung trägt keine Farbe.** Farbe ist für drei Dinge reserviert:
Kapitel-Identität auf Flächen, den Wegweiser zum Ziel eines Verweises, und die
Zuordnung in Formeln.

## Verweise & Doppelkodierung

`xref(<label>)` springt mit Pfeil und in der Farbe des Zielkapitels — einsetzen,
wenn der Sprung in der Prüfung Suchzeit spart. `sec-ref(<label>)` ist die
kompakte Zielnummer für lokale Übersichten. `script-ref(42)` verweist auf die
Skript-Seite. Ein Verweis ins Leere bricht den Build.

**Neuro-Didaktische Doppelkodierung (Farbe vor Zahl):** Unter Prüfungsstress
sinkt die sequentielle Lesekapazität. Das periphere Sehen erfasst Farben und
Formen in Millisekunden vor Ziffern:
- **Redundante Wegweiser:** `xref` paart immer die Farbe des Zielkapitels mit der
  Abschnittsnummer. Das Auge erkennt das Themenfeld sofort aus dem Augenwinkel.
- **Grössenfarben (`quantity`):** Eine Fachgrösse behält dokumentweit dieselbe Tinte
  (z. B. Geschwindigkeit immer Türkis). Substitutionsschritte werden sofort scanbar.
- **Lautstärke-Differenzierung:** Kapitel gesättigt, Abschnitte hell, Unterabschnitte
  dezent — hierarchische Orientierung ohne Farb-Wildwuchs im Fliesstext.

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
#idx-see("EW", "Eigenwert")             // »EW, siehe Eigenwert 5.3«
#idx("Ω", sort: "Omega")                // anders einsortiert, gleich angezeigt
#kw(term: "Zähler")[Zählers]            // anders angezeigt: die Lemmaform
```

Ausgegeben wird das Register mit `make-index()` unter einem `front`-Kapitel am
Dokumentende.

Ein `idx-see` trägt die Nummer seines Ziels mit — der Sprung bleibt einer.
Umlaute brauchen keinen Sortkey: Sortiert wird nach DIN 5007-1 (ä wie a,
ß wie ss). Begriffe ohne Buchstaben (`Ω`, `∇`) stehen als Gruppe **Symbole**
vor dem Alphabet. Zweimal derselbe Abschnitt zählt als eine Fundstelle.

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

### `40_tabellen.md`

Tabelle und Tabellenbox sind **ein** Baustein:

```typ
#tabular(
  title: [Vergleich],          // weggelassen → Tabelle ohne Box
  cols: (0.8, 1.4, 1),         // Gewichte; feste Längen sind erlaubt
  [Fall], [Bedingung], [Wert], // die ersten Zellen sind die Kopfzeile
  [A], [$x > 0$], [$+1$],
)
```

Die Kopfzeile **sind** die ersten Zellen. Sie »halb« zu setzen ist strukturell
nicht möglich; im Vorgänger führte genau das zu weisser Schrift auf weissem
Grund, ohne Fehlermeldung. Ein Zellverbund in der Kopfzeile wird in Spalten
gezählt, nicht in Argumenten.

Die Spaltengewichte sind Anteile und müssen zu nichts aufgehen; ein Gewicht
von null oder weniger bricht ab, weil zwei Zellen sonst übereinander drucken.

**Die Zellzahl muss aufgehen.** Fehlt eine Zelle, verrutscht ab dort jede Zeile
um eins — im Satz sieht das aus wie Absicht. Deshalb bricht der Build, wenn die
Zellen kein volles Vielfaches der Spaltenzahl füllen oder die Kopfzeile nicht
über alle Spalten reicht. Verbünde zählen mit ihrer `colspan`; bei `rowspan`
oder ausdrücklich platzierten Zellen wird nicht gerechnet statt falsch gemeldet.

## Regler

| Regler | Werte (Vorbelegung zuerst) | Wirkung |
|---|---|---|
| `header` | `true`, `false` | farbige Kopfzeile |
| `zebra` | `true`, `false` | Zebra-Streifen |
| `grid` | `"both"`, `"horizontal"`, `"none"` | Linien **zwischen** Zeilen und Spalten |
| `rows` | `"normal"`, `"roomy"`, `"tight"` | Zeilenhöhe |
| `colsep` | `"normal"`, `"tight"` | Zellpolsterung |
| `font` | `"normal"`, `"dense"` | Schriftgrösse |
| `align` | `left`, `center`, `right` | eine für alle — oder `(left, right)`, eine je Spalte |

Dazu gelten die Box-Regler (`tone`, `frame`, `breakable`, …), sobald `title`
gesetzt ist.

**Drei Regler, drei Fragen — bewusst nicht einer:** Eine Formeltabelle will
normale Schrift *und* mehr Zeilenhöhe; ein siebenspaltiges Register kleine
Schrift *und* knappe Polsterung *und* normale Zeilenhöhe.

Passt eine Tabelle knapp nicht, erst prüfen **woran** es liegt: zu breit →
`colsep: "tight"`, notfalls `font: "dense"`. Zeilen stossen aneinander →
`rows: "roomy"`.

## Linien

Beide Richtungen sind vorbelegt; Wegnehmen ist die Wahl. **Die Aussenkante ist
der Boxrahmen, nicht das Gitter** — nur er läuft an den runden Ecken mit.
Deshalb steht eine Tabellenbox auf `frame: "hard"`, und abgeschaltet wird die
Aussenkante an der **Box** (`frame: "none"`), nicht an der Tabelle.

## Zellverbund und Bilder

`table.cell(colspan: 3, align: center)[…]` ist Typsts eigener Verbund — dafür
gibt es keinen eigenen Namen. In einer Zelle steht das nackte
`image("graphics/x.svg")`; die Tabelle setzt die Höhe, damit eine Bildspalte
von selbst einheitlich hoch ist.

### `50_formeln.md`

Typst bringt den grössten Teil selbst mit — was dort steht, wird verwendet und
nicht nachgebaut:

`RR CC NN ZZ QQ` · `dif x` · `abs(x)` `norm(v)` · `underbrace` `overbrace` ·
`vec` `mat` · `lim_(x->0)` `sum_(k=1)^n` `integral_a^b` · `cases`

## Ergänzt

`sgn` `rang` `Spur` `Ker` `Bild` `eig` `diag` `spann` `proj` `Adj` ·
`grad` `divg` `rot` · `Arsinh` `Arcosh` `Artanh` · `vc(v)` (fetter Vektor).

Kein Opt-in-Modul: Ein paar Operatoren kosten nichts.

## Formelblöcke

Formeln stehen in `formula[…]`, benannte Formeln in
`formula(weight: "caption")[Name][…]`. Mehrere Blöcke in einer Box trennt
`sep()`. Anmerkungen kommen als `note[…]` darunter.

Lange Gleichungen in schmalen Spalten über mehrere Zeilen aufteilen, höchstens
eine Gleichung pro Zeile. Grössere Matrizen nie nebeneinander, sondern
untereinander. Überbreite Gleichungen bricht `check-overflow: true` im Build laut ab.

## Farbe in Formeln

**Positional, innerhalb einer Herleitung:** `markA` Quelle/gegeben, `markB`
Gegenstück/abgeleitet, `markC` Ziel/Endform, `markD` dritter Strang (sparsam).
Nur einsetzen, wenn die farbliche Verbindung mathematisch eindeutig stimmt.
Zur blossen Betonung sind sie falsch — dafür gibt es `danger` und `hl`.

**Über das ganze Dokument:** Grössenfarben. Eine Farbe gehört im ganzen
Dokument *einer* Grösse — vergeben in `zsf(quantities: ("Kraft": 0, …))`, nie
im Kapitel. Danach `$#quantity("Kraft", $F$) = m dot a$`. **Acht Slots (0–7),
und jeder nur einmal**; ein doppelt oder ausserhalb vergebener Slot bricht den
Build, ebenso ein nicht vergebener Name im Kapitel. Wo ein Fach keine
wiederkehrenden Grössen hat, bleibt der Eintrag leer.

Die Namen sind in Grossbuchstaben (`markA` statt `mark-a`), weil ein
Bindestrich im Mathe-Modus ein Minuszeichen ist.

### `60_workflow.md`

## Befehle

```bash
make build      # Referenz-Implementierung (im Fork: die ZSF)
make watch      # live nachbauen, während geschrieben wird
make catalog    # Baustein-Katalog — nach jeder Änderung an der API
make check      # der ganze Harness — vor jedem Commit
make fork NAME=zsf-fach-fs2026
make sync-rules # rules/*.md → AGENTS.md
```

`make check` meldet einen gegenüber `src/` veralteten Katalog.

**Erledigt ist eine Aufgabe erst nach erfolgreichem `make build`** — mit genau
diesem Befehl. Innerhalb einer Aufgabe wird nach abgeschlossenen Einheiten
gebaut, nicht nach jeder Zeile; ein Build dauert Bruchteile einer Sekunde, ein
zerschossener Stand kostet mehr.

`make check` ist eine Stufe, keine drei. Der Vorgänger brauchte die Staffelung,
weil seine Tiefenprüfungen Minuten liefen; hier läuft alles in wenigen Sekunden.

## Was der Harness prüft — und was nicht

| Prüfung | Frage |
|---|---|
| `test` | Stimmen die reinen Funktionen? (Sortierung, Farbrotation, Ton-Rollen, Massordnung) |
| `errors` | Bricht jede falsche Eingabe verständlich ab statt still durchzulaufen? |
| `lint` | Steht Gestaltung im Kapitel oder ein hartes Mass ausserhalb von `config.typ`? |
| `knobs` | Hat **jede** Stellschraube eine messbare Wirkung? |
| `coverage` | Wird jeder öffentliche Name vorgeführt **und** in `rules/` beschrieben? |
| `identity` | Trägt das PDF Titel, Autor und die Kennungen? |

Nicht geprüft wird, was Typst selbst fängt: unbekannte Argumente, falsche
Typen, fehlende Verweisziele, kollidierende Regler. Eine Prüfung dafür wäre
eine zweite Wahrheit neben dem Compiler.

## Regeln ändern

Nie `AGENTS.md` oder seine Symlinks editieren — sie sind erzeugt. Stattdessen
die passende `rules/*.md` ändern, dann `make sync-rules`. `make check` meldet
Drift.

**Was in `rules/` gehört:** Alles hier landet in jeder Sitzung im Kontext. Der
Massstab ist nicht »stimmt und ist interessant«, sondern: *Braucht eine KI das
beim Arbeiten, ohne dass man sie hinschickt?* Historische Begründungen,
Wiederholungen und Detailverbote gegen Dinge, die ohnehin niemand täte, gehören
nicht hinein. Was ein Verifier mechanisch fängt, gehört in seine Fehlermeldung.

## Dateien platzieren

Neue Dateien nie im Wurzelverzeichnis. Inhalt nach `chapters/`, Gestaltung nach
`src/`, Vorführung nach `showcase/`, Prüfung nach `tests/`, Bilder nach
`graphics/`.

Dateinamen ohne Umlaute, in ASCII und deskriptivem Englisch — sie überstehen
Shell, CI und fremde Systeme.

## Commit-Attribution

Commit-Autor ist ausschliesslich die menschliche Git-Identität. Niemals
`Co-Authored-By`, Modellnamen oder Tool-Signaturen in Commit-Nachrichten.

### `70_github.md`

## Identity und Namenskonventionen

- **Repository:** `eth-<fach>-zsf-<semester>-hliddal`
- **PDF-Dateiname:** `<fach>_<semester>_hliddal.pdf`
- **Semesterformat:** `fsYYYY` oder `hsYYYY`
- **Release-Tags:** Semantische Versionierung `vMAJOR.MINOR.PATCH`

Der `Makefile` im Fach-Fork setzt den Basisnamen und Titel für die PDF-Ausgabe:

```make
PDF_BASENAME  ?= analysis2_fs2026_hliddal
SUBJECT_TITLE ?= Analysis II
```

## Commit-Attribution & Git-Hygiene

Commit-Autor und Committer verwenden ausschliesslich die menschliche Git-Identität
des Repository-Eigentümers.

**Strikt verboten:** Niemals `Co-Authored-By`-Trailer, Modellnamen, Tool-Signaturen
oder sonstige KI-/Agenten-Attribution in Commit-Nachrichten. KI-Systeme sind
Werkzeuge und erscheinen auf GitHub nicht als Contributors.

## PDF-Identity

Titel, Autor und Versionierung werden zentral über die Stellschrauben von `zsf(...)`
in `main.typ` und den Makefile gesteuert. `tests/identity.sh` prüft die Metadaten
nach dem Build und darf in Forks nicht entfernt werden.

### `80_didaktik.md`

Die ZSF wird **in der Prüfung** benutzt. Massstab für jeden Satz:

> Hilft das beim schnellen, sicheren Lösen von Prüfungsaufgaben?

Nicht Vollständigkeit, nicht Allgemeinheit, nicht lückenlose Strenge.

## Kernregeln

- **Ungenauigkeiten auf Kursniveau sind ok**, solange sie tragfähig bleiben.
- **Standard ist die einfachste Kursniveau-Form.** Eine Präzisierung
  hinzuzufügen ist im Zweifel ein Fehler: Zusatzstoff und akademische Strenge
  über das zum Lösen Nötige hinaus kosten Lesezeit und Sicherheit. Nur
  aufnehmen, wenn die Präzisierung *selbst* prüfungsrelevant ist und die
  Lesbarkeit nicht kostet. Das ist ein bewusster Guardrail — ein fähigeres
  Modell neigt eher dazu, ungefragt »vollständiger« zu werden.
- Darstellungsformen sind Werkzeuge, keine Checkliste: eine nummerierte Liste
  nur bei einer stabilen Schrittfolge, `danger` nur bei einer echten Falle.

## Eine gezeigte Prüfungsaufgabe ist ein Diagnosefall

Sie ist **Evidenz für eine mögliche strukturelle Lücke, nicht die Vorlage für
neuen Inhalt**. Ein auf genau diese Aufgabe zugeschnittener Patch macht die ZSF
länger, ohne nahe Varianten abzudecken. Umgekehrt heisst eine schwierige
Aufgabe nicht zwingend, dass Stoff fehlt: Vorhandenes kann zu eng formuliert,
nicht verknüpft oder schlecht auffindbar sein.

1. Erst die Ursache bestimmen: fehlendes Grundkonzept, zu eng formulierte
   Methode, fehlende Verbindung oder Auffindbarkeitsproblem.
2. Prüfen, ob Vorhandenes verständlicher, breiter, verbunden oder besser
   platziert werden kann. Neuen Inhalt nur bei einer echten Konzeptlücke.
3. Die **kleinste übertragbare Verbesserung innerhalb des Kursniveaus**
   umsetzen — nicht maximal verallgemeinern.
4. Keine aufgabenspezifischen Zahlen oder Lösungstricks übernehmen.
5. Vor der Umsetzung in einem Satz die Lücke und die Absicht nennen.

## Scannbarkeit

In der Prüfung wird nicht gelesen, sondern gesucht. Jede Information muss in
Sekunden auffindbar sein — über Bausteine, Titel und Marker statt über
Fliesstext. **Übersichtlichkeit schlägt Dichte:** lieber klar gegliederte
Blöcke als kompakte, unstrukturierte Absätze. Lange Fliesstext-Passagen sind
ein Warnsignal.

**Inhalte nie ohne expliziten Befehl ändern, kürzen oder »korrigieren«** —
Permission-Guardrail, unabhängig vom didaktischen Urteil.
