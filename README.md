# zsf — Prüfungs-Zusammenfassungen in Typst

Vierspaltiges A4-Querformat, dicht gesetzt, für Zusammenfassungen, die **in der
Prüfung** benutzt werden. Nachfolger des LaTeX-Templates in `../zsf-template`.

Der Kern ist eine Bibliothek (`src/`) mit einem kleinen Baustein-Katalog und
vielen Reglern. Kapitel enthalten Inhalt und sonst nichts.

## Anfangen

```bash
make install                       # Package unter @local/zsf bereitstellen
make build                         # Referenz  → template_fs0000_hliddal.pdf
make catalog                       # Katalog   → katalog.pdf
make watch                         # live nachbauen
make fork NAME=zsf-analysis2-fs2026
```

**Zwei Dokumente.** Die *Referenz* führt jeden Baustein im Fluss einer echten
ZSF vor und ist die Grundlage der Coverage-Prüfung. Der *Katalog* reiht
dieselben Bausteine mit identischem Mustertext nebeneinander, jeder mit einer
ID — ein Arbeitsinstrument fürs Aussortieren, das nichts prüft und von nichts
geprüft wird. Sein Inventar liest die API beim Bauen aus dem Quelltext.

Ein Fork enthält `main.typ`, `chapters/`, `graphics/` und ein Makefile — sonst
nichts. Der Katalog bleibt hier.

```bash
cd ../zsf-analysis2-fs2026
make watch                         # schreiben, PDF aktualisiert sich
```

Voraussetzungen: `typst` (0.15+), `make`, `python3`, optional `pdfinfo` für die
Identitätsprüfung.

Die Schriften liegen im Repository und werden dem Compiler vom Makefile
übergeben — deshalb immer über `make`, nicht über `typst` direkt. Wer sie auch
im Editor sehen will (Vorschau in VS Code, tinymist): `make fonts` kopiert sie
einmalig nach `~/Library/Fonts`.

Genau deshalb ist dies ein **lokales** Package (`@local/zsf`) und keines für
Typst Universe: Ein veröffentlichtes Package darf keine Schriften mitliefern,
und ohne Carlito und NewCM Sans Math stimmt das Satzbild nicht. Ein Fork ist
folglich nicht eigenständig — er braucht dieses Repository am Platz.

## Ein Kapitel sieht so aus

```typ
#import "@local/zsf:0.1.0": *

= Ableitungen <ch:ableitungen>
== Rechenregeln <sec:regeln>

Fliesstext braucht keinen Baustein. Zentrale #kw[Fachbegriffe] werden markiert
und landen damit automatisch im Register.

#formula(weight: "caption")[Kettenregel][
  $ dif / (dif x) f(g(x)) = f'(g(x)) dot g'(x) $
  #note[Von aussen nach innen ableiten.]
]

#warn[#danger[Nur für differenzierbare $g$.] Sonst greift die Regel nicht.]

#tabular(title: [Übersicht], cols: (1, 1.4),
  [Funktion], [Ableitung],
  [$x^n$], [$n x^(n-1)$],
  [$e^x$], [$e^x$],
)
```

## Was es gibt

**Bausteine** — `panel` und fünf Vorbelegungen davon: `warn`, `formula`,
`picture`, `steps`, `code`. Dazu `tabular`, `facts`, `fig`, `fig-side`,
`split`, `sep`, `note`, `before`, `after`.

**Regler** — benannte Argumente, auf jeder Box: `tone`, `weight`, `pad`,
`frame`, `surface`, `align`, `font`, `tag`, `breakable`.

**Marker** — `kw`, `lbl`, `danger`, `concl`, `hl`, `xref`, `sec-ref`,
`markA`–`markD`, `quantity`.

**Stellschrauben** — 24 benannte Argumente von `zsf(...)`, von `size` und
`density` bis `palette` und `columns`. Ein Tippfehler bricht den Build.

Vollständig gesetzt in der Referenz (`make build`), nebeneinander im Katalog
(`make catalog`), beschrieben in `rules/`.

## Prüfen

```bash
make check       # alles, in ~3 Sekunden
```

| Stufe | Frage |
|---|---|
| `test` | Stimmen die reinen Funktionen? |
| `errors` | Bricht jede falsche Eingabe verständlich ab statt still durchzulaufen? |
| `lint` | Steht Gestaltung im Kapitel oder ein hartes Mass ausserhalb von `config.typ`? |
| `knobs` | Hat **jede** Stellschraube eine messbare Wirkung? |
| `coverage` | Wird jeder öffentliche Name vorgeführt und beschrieben? |
| `warnings` | Bauen Referenz, Katalog und Fork-Vorlage ohne eine einzige Compiler-Meldung? |
| `identity` | Trägt das PDF Titel, Autor und Kennungen? |

Nicht geprüft wird, was Typst selbst fängt — unbekannte Argumente, falsche
Typen, fehlende Verweisziele. Eine Prüfung dafür wäre eine zweite Wahrheit
neben dem Compiler.

## Aufbau

```
lib.typ        die öffentliche API — das Einzige, was ein Kapitel importiert
src/           das System: config, knobs, palette, readability, structure,
               blocks, tables, media, markup, maths, index
template/      was ein Fork bekommt
showcase/      die Referenz-Implementierung
catalog/       der Baustein-Katalog
fonts/         Carlito (OFL) und NewCM Sans Math (GUST)
rules/         das Regelwerk für KI-Agenten → AGENTS.md
tests/         der Harness
```

## Gegenüber dem LaTeX-Vorgänger

| | LaTeX | Typst |
|---|---|---|
| Gestaltungssystem | 5560 Zeilen | 1355 Zeilen |
| Harness | 4102 Zeilen | 731 Zeilen |
| Regelwerk | 95 KB | 29 KB |
| Vollbuild | 7,2 s | 0,13 s |
| `make check` | 8 s + Tiefenprüfungen | 3,1 s |
| Fork anlegen | eigenes Skript plus Verifier | `typst init` |

Der grösste Teil des alten Systems war Notwehr gegen LaTeX: verzögerte
Farbauflösung, damit Regler einander nicht verwerfen; Reserven und Penalties,
damit ein Titelbalken nicht allein am Spaltenfuss steht; ein Verifier, der jedes
Reglerpaar in beiden Reihenfolgen setzt. In Typst sind benannte Argumente
reihenfolgefrei, `block(sticky: true)` bindet den Balken, und ein unbekanntes
Argument bricht den Build.

Erhalten geblieben ist das Satzbild: vier Spalten, dieselbe 18-Slot-Palette mit
Slot 0 für Front-Matter, heller Box-Titel mit dunkler Schrift auf fast weissem
Rumpf, gesättigte Kapitel- und Abschnittsbalken, Register mit farbcodiertem
Abschnitts-Locator.

Das Farbmodell ist dabei nicht übersetzt, sondern **abgeleitet**: Die 18
handgewählten Aufhellungen des Vorgängers liegen alle bei L ≈ 88.5 % mit einem
Fünftel der Buntheit ihres Akzents. Aus dieser gemessenen Regel entsteht hier
jede Fläche — mit dem Nebeneffekt, dass jeder Slot exakt denselben Kontrast
trägt, wo der Vorgänger je nach Farbe zwischen 33 und 41 Punkten schwankte.

## Lizenz

MIT für den Code. Schriften unter ihren eigenen Lizenzen: Carlito (SIL OFL 1.1),
New Computer Modern (GUST Font License).
