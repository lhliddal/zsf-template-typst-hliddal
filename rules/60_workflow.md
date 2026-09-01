---
name: 60_workflow
scope: project
purpose: Bauen, prüfen, forken, Dateien platzieren
---

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
