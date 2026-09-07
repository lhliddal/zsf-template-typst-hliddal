# Didaktisches Prinzip der Zusammenfassungen

> Leitlinie für Inhalt und Erklärungen. Sie ist die Default-Haltung für jede ZSF, die aus diesem Template entsteht; eine Fach-ZSF darf begründet abweichen, wenn Stoffart oder Prüfungsform es verlangen (siehe `rules/00_meta.md` → Verhältnis zu Forks).
> Für Build-/Style-Regeln siehe `rules/*.md` (bzw. das generierte `AGENTS.md`/`CLAUDE.md`). Diese Datei betrifft **was** drinsteht und **wie** erklärt wird, nicht das Layout.

## Zweck der Zusammenfassung

Die ZSF wird **direkt in der Prüfung** verwendet. Massstab für jeden Satz ist daher:

> **Hilft das beim schnellen, sicheren Lösen von Prüfungsaufgaben?**

Nicht der Massstab ist fachliche Vollständigkeit, Allgemeinheit oder lückenlose Strenge.

## Grundgerüst: kopieren ist erlaubt

- Oft existiert als **Grundgerüst eine andere (kopierte) Zusammenfassung**. Das ist Absicht und kein Problem.
- Struktur und Formulierungen dürfen übernommen und an das System (Bausteine, Typst-Syntax, Sprache) angepasst werden.

## Umgang mit Ungenauigkeiten (zentral)

- **Ungenauigkeiten sind toleriert**, solange sie dem **Niveau des Stoffs** entsprechen und intuitiv tragfähig bleiben (vereinfachte, aber nutzbare Begriffe statt jeder Sonderfall-Ausformulierung).
- **Standard ist die einfachste Kursniveau-Form; Präzisierungen hinzuzufügen ist im Zweifel ein Fehler.** Platz und Prüfungszeit sind knapp — Zusatzstoff, Sonderfälle oder akademische Strenge, die über das zum Lösen der Prüfungsaufgaben Nötige hinausgehen, kosten in der Prüfung Lesezeit und Sicherheit. Im Zweifel **weglassen**. Eine Präzisierung nur aufnehmen, wenn sie *selbst* prüfungsrelevant ist **und** die Lesbarkeit nicht kostet. Das ist ein bewusster Schutz-Guardrail, keine blosse Stilfrage: ein fähigeres Modell neigt eher dazu, ungefragt „vollständiger"/„korrekter" zu werden — genau das ist hier unerwünscht und kann den Prüfling mit unnötigem Zusatzstoff aufhalten.

## Prüfungsaufgaben als Diagnosefälle

Wenn eine konkrete Prüfungsaufgabe mit der ZSF nicht oder nur umständlich lösbar ist, ist sie zunächst ein **Hinweis auf eine mögliche strukturelle Lücke** — keine Vorlage, deren spezielle Lösung einfach ergänzt werden soll. Ein auf die gezeigte Aufgabe zugeschnittener Patch hilft vor allem beim Wiederholen genau dieser Aufgabe, macht die ZSF aber länger und löst nahe Varianten oft weiterhin nicht. Umgekehrt beweist eine einzelne schwierige Aufgabe noch nicht, dass neuer Stoff fehlt: Manchmal ist das Wissen vorhanden, aber zu eng formuliert, schlecht verknüpft oder unter Prüfungsdruck nicht auffindbar.

Vor einer inhaltlichen Änderung deshalb die zugrunde liegende Ursache bestimmen:

1. Fehlt ein grundlegendes Konzept des Kurses?
2. Ist eine vorhandene Methode enger formuliert, als sie auf Kursniveau sein müsste?
3. Fehlt die Verbindung zwischen zwei bereits vorhandenen Themen?
4. Ist vorhandenes Wissen wegen Darstellung, Platzierung oder unnötiger Komplexität praktisch nicht anwendbar?

Behoben wird die **kleinste übertragbare Ursache innerhalb des Kursniveaus**. Bestehende Aussagen bevorzugt verständlicher oder passend breiter formulieren, zusammengehörende Stellen verbinden oder Inhalte am natürlichen fachlichen Ort besser auffindbar machen. Neuen Inhalt nur ergänzen, wenn tatsächlich ein Grundkonzept fehlt. Die konkrete Aufgabenlösung, ihre Zahlen und ihre spezielle Formulierung werden nicht übernommen, ausser sie bilden selbst ein besonders repräsentatives und platzsparendes Beispiel.

Übertragbarkeit bedeutet dabei nicht maximale Allgemeinheit: Die Verbesserung soll nahe Aufgabenvarianten des behandelten Kursstoffs abdecken, ohne zusätzliche Theorie oder abstrakte Sonderfälle einzuführen. Vor Abschluss intern an mindestens zwei nahen Varianten prüfen, ob die Änderung weiterhin hilft. Diese Testvarianten gehören nicht in die ZSF.

**Keine neuen Entscheidungsschemata, Rezepte oder „Wann verwenden"-Blöcke als Standardreaktion.** Ein Verfahren ist nur sinnvoll, wenn der Kursstoff tatsächlich eine stabile, wiederholt anwendbare Schrittfolge besitzt und diese noch nicht ausreichend dargestellt ist.

## Was eine gute Erklärung hier ausmacht

Auf die Bausteine stützen und für den Prüfungs-Lookup optimieren. Verfahren nur bei einer stabilen Schrittfolge als `#steps[...][#case...]` oder `#facts[+ ...]` darstellen. Stolperfallen als `#danger[...]`, ein konkretes Beispiel, Intuition oder Querchecks nur dort ergänzen, wo sie die schnelle Anwendung tatsächlich verbessern — kein fester Baukasten, den jede Box abhaken muss.

## Scannbarkeit & Übersichtlichkeit

In der Prüfung wird die ZSF nicht gelesen, sondern **durchsucht**. Scannbares Design und Übersichtlichkeit sind deshalb harte Anforderungen:

- Jede Information muss in Sekunden auffindbar sein — über Box-Titel, Marker (`#kw[...]`, `#danger[...]`, `#hl[...]`) und visuelle Struktur, nicht über langen Fliesstext.
- **Übersichtlichkeit schlägt Dichte:** Lieber klar gegliederte Blöcke (eine Box pro Aussage, Tabelle statt Aufzählung im Text) als kompakte, aber unstrukturierte Absätze.
- Lange Fliesstext-Passagen sind ein Warnsignal — solchen Inhalt in `#steps`, `#facts`, Tabellen (`#tabular`) oder einzelne Boxen (`#panel`) umstrukturieren, sodass das Auge beim Überfliegen hängen bleibt.

## Wenn unsicher

Im Zweifel **Nützlichkeit + Intuition vor Strenge**. Lieber eine knappe, leicht unscharfe Aussage, die in der Prüfung sofort anwendbar ist, als eine vollständige, die man unter Zeitdruck nicht parsen kann.

## Konsequenz für KI-Assistenten

- Beim Review/Bearbeiten **keine** Sonderfälle, Ausnahmen oder Präzisierungen eigenmächtig ergänzen.
- Erklärungen verbessern heisst hier: klarer formulieren, Beispiel ergänzen, Intuition hinzufügen, Stolperfalle markieren — **nicht** akademische Korrektheit erhöhen.
- Inhalte nie ohne expliziten Befehl ändern, kürzen oder „korrigieren" (siehe `rules/00_meta.md`).
