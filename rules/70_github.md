---
name: 70_github
scope: project
purpose: Namenskonventionen, PDF-Identity, Commit-Attribution
---

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
