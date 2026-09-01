---
name: 00_meta
scope: project
purpose: Zweck, Sprache, kritische Regeln
---

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
