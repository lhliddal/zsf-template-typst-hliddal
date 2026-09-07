---
name: 15_stellschrauben
scope: project
purpose: Was pro ZSF einmalig entschieden wird
---

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

Die Bereichsfaktoren multiplizieren den globalen Faktor für **ihren** Bereich —
für ZSF, die ungleich verteilt sind.

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

Flattersatz ist die Vorbelegung, weil der Blocksatz in ~50 mm schmalen Spalten
entweder trennen oder Wortzwischenräume aufblähen muss.

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
