// =============================================================
// readability.typ — Umbruchschutz im Fliesstext
// =============================================================
//
// In einer ~50 mm schmalen Spalte bricht eine Zeile oft genau dort, wo sie
// nicht soll: zwischen Zahl und Einheit. »Der Wert beträgt 10 / m/s« ist kein
// Schönheitsfehler, sondern zwingt zum Zurückspringen.
//
// Der Vorgänger löste das mit einem LuaLaTeX-Filter, der jede QUELLZEILE vor
// dem Parsen umschrieb — samt Platzhaltern für `\%` und `$$` und einer Liste
// von Umgebungen, in denen er sich abschalten musste. Typst arbeitet nach dem
// Parsen: Eine Show-Regel sieht Text, und Formeln sowie eingefärbte Codeblöcke
// erreicht sie von selbst nicht.
//
// GEBUNDEN WIRD MIT `box`, NICHT MIT EINEM GESCHÜTZTEN LEERZEICHEN. Ein `box`
// ist für den Umbruch atomar, lässt die Zeichen aber unangetastet: Wer die
// Formel aus dem PDF kopiert, bekommt weiterhin ein normales Leerzeichen und
// kein U+00A0. Genau deshalb ist der Rest hier so kurz — es gibt nichts zu
// schützen und nichts wiederherzustellen.

/// Zahl, Leerraum, Einheit.
///
/// Die Wortgrenze am Ende ist der ganze Trick. Ohne sie band die Regel auch
/// »1 Fliesstext« zu »1 Fli« + »esstext«: Drei Buchstaben passen auf jeden
/// Wortanfang. Mit `\b` muss das Kürzel VOLLSTÄNDIG sein — »m«, »kg«, »m/s«
/// gehen durch, »Fälle« und »Beispiele« nicht.
///
/// Höchstens drei Buchstaben, weil das die SI-Symbole abdeckt (m, kg, mm,
/// MPa, Hz, N/mm) und alles Längere deutsche Wörter wären. Dass dabei auch
/// »3 der« gebunden wird, ist gewollt: Ein Zahlwort an ein dreibuchstabiges
/// Wort zu binden kostet in keiner Spalte etwas.
///
/// `%` und `°C` stehen als eigene Zweige da — sie tragen keine Wortgrenze,
/// weil auf sie ein Satzzeichen folgen darf.
#let unit-pattern = "\d+(?:[.,]\d+)?[ \t]+(?:%|°[CFK]?|[A-Za-zµΩ]{1,3}(?:/[A-Za-zµΩ]{1,3})?\b)"

/// Kurzer Bezeichner mit Doppelpunkt (Variablenbeschreibung, z. B. »m: 5«, »r: Rang«).
///
/// Längenbegrenzung (COLON_MAX_IDENT <= 4, Folgewort <= 8 Zeichen): Nur kurze
/// Bezeichner mit kompaktem Folgewert werden gebunden. Ein Satzdoppelpunkt oder
/// eine lange Folgeerklärung darf umbrechen, um in ~50 mm schmalen Spalten
/// überlaufende Zeilen zu verhindern.
#let colon-pattern = "(?:\b|\A)([a-zA-Z0-9äöüÄÖÜ_]{1,4}:)[ \t]+([^\s]{1,8}\b)"

/// Bindet Zahl und Einheit sowie kurze Variablen-Doppelpunkte im ganzen Dokument.
#let bind-units(body) = {
  show regex(unit-pattern): it => box(it)
  show regex(colon-pattern): it => box(it)
  body
}
