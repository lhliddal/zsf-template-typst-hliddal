# zsf — Prüfungs-Zusammenfassungen in Typst

Vierspaltiges A4-Querformat, dicht gesetzt, für Zusammenfassungen, die **in der
Prüfung** benutzt werden. Nachfolger des LaTeX-Templates in `../zsf-template`.

Der Kern ist eine Bibliothek (`src/`) mit einem kleinen Baustein-Katalog und
vielen Reglern. Kapitel enthalten Inhalt und sonst nichts.

## Anfangen

```bash
make install                       # Package unter @local/zsf bereitstellen
make build                         # Katalog bauen  → katalog.pdf
make watch                         # live nachbauen
make fork NAME=zsf-analysis2-fs2026
```

Ein Fork enthält `main.typ`, `chapters/`, `graphics/` und ein Makefile — sonst
nichts. Der Katalog bleibt hier.

```bash
cd ../zsf-analysis2-fs2026
make watch                         # schreiben, PDF aktualisiert sich
```

Voraussetzungen: `typst` (0.15+), `make`, `python3`, optional `pdfinfo` für die
Identitätsprüfung. Die Schriften liegen im Repository — nichts zu installieren.

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

**Bausteine** — `panel` und sieben Vorbelegungen davon: `warn`, `formula`,
`picture`, `steps`, `facts`, `code`, `tabular`. Dazu `fig`, `fig-side`,
`split`, `sep`, `note`, `before`, `after`.

**Regler** — benannte Argumente, auf jeder Box: `tone`, `weight`, `pad`,
`frame`, `surface`, `align`, `font`, `tag`, `breakable`.

**Marker** — `kw`, `lbl`, `danger`, `concl`, `hl`, `xref`, `secref`,
`markA`–`markD`, `quantity`.

**Stellschrauben** — 24 benannte Argumente von `zsf(...)`, von `size` und
`density` bis `palette` und `columns`. Ein Tippfehler bricht den Build.

Vollständig gesetzt im Katalog (`make build`), beschrieben in `rules/`.

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
| `identity` | Trägt das PDF Titel, Autor und Kennungen? |

Nicht geprüft wird, was Typst selbst fängt — unbekannte Argumente, falsche
Typen, fehlende Verweisziele. Eine Prüfung dafür wäre eine zweite Wahrheit
neben dem Compiler.

## Aufbau

```
lib.typ        die öffentliche API — das Einzige, was ein Kapitel importiert
src/           das System: config, palette, structure, blocks, tables,
               media, markup, maths, index
template/      was ein Fork bekommt
showcase/      der Katalog
fonts/         Carlito (OFL) und NewCM Sans Math (GUST)
rules/         das Regelwerk für KI-Agenten → AGENTS.md
tests/         der Harness
```

## Gegenüber dem LaTeX-Vorgänger

| | LaTeX | Typst |
|---|---|---|
| Gestaltungssystem | 5560 Zeilen | 1275 Zeilen |
| Harness | 4102 Zeilen | 666 Zeilen |
| Regelwerk | 95 KB | 28 KB |
| Vollbuild | 7,2 s | 0,13 s |
| `make check` | 8 s + Tiefenprüfungen | 3,1 s |
| Fork anlegen | eigenes Skript plus Verifier | `typst init` |

Der grösste Teil des alten Systems war Notwehr gegen LaTeX: verzögerte
Farbauflösung, damit Regler einander nicht verwerfen; Reserven und Penalties,
damit ein Titelbalken nicht allein am Spaltenfuss steht; ein Verifier, der jedes
Reglerpaar in beiden Reihenfolgen setzt. In Typst sind benannte Argumente
reihenfolgefrei, `block(sticky: true)` bindet den Balken, und ein unbekanntes
Argument bricht den Build.

Erhalten geblieben sind die Prinzipien: vier Spalten, die 18-Slot-Palette mit
Slot 0 für Front-Matter, ein kleiner Katalog mit vielen Reglern, Gestaltung
nur in `src/`, und das Register mit farbcodiertem Abschnitts-Locator.

## Lizenz

MIT für den Code. Schriften unter ihren eigenen Lizenzen: Carlito (SIL OFL 1.1),
New Computer Modern (GUST Font License).
