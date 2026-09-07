#!/usr/bin/env bash
# =============================================================
# lint.sh — die Grenze zwischen Inhalt und Gestaltung
# =============================================================
# Zwei Fragen, mehr nicht:
#   1. Steht in einem Kapitel ein Layout-Befehl, für den es einen Baustein gibt?
#   2. Steht in src/ ein hartes Mass ausserhalb der einen Rechenstelle?
#
# Alles, was Typst selbst fängt (unbekannte Argumente, falsche Typen, fehlende
# Verweisziele), steht hier NICHT. Der Vorgänger prüfte das in Shell, weil
# LaTeX es stillschweigend annahm.
#
# Ausnahme pro Zeile: `// lint: erlaubt — <Grund>` in der Zeile davor.

set -uo pipefail
cd "$(dirname "$0")/.."
fail=0

report() { # datei:zeile  regel  fundstelle
  echo "  $1  [$2]"
  echo "      $3"
  fail=1
}

scan() { # dateiglob  regex  regel  hinweis
  local files="$1" pattern="$2" rule="$3" hint="$4"
  while IFS=: read -r file line text; do
    [ -z "${file:-}" ] && continue
    # Eine reine Kommentarzeile ist Dokumentation, kein Satzbefehl — dort steht
    # gerade das Beispiel, das die Regel erklärt.
    [[ "$(echo "$text" | sed 's/^[[:space:]]*//')" == //* ]] && continue
    # Vorzeile auf die Ausnahme prüfen
    local prev
    prev=$(sed -n "$((line - 1))p" "$file" 2>/dev/null)
    [[ "$prev" == *"lint: erlaubt"* ]] && continue
    report "$file:$line" "$rule" "$(echo "$text" | sed 's/^[[:space:]]*//' | cut -c1-90)"
    echo "      → $hint"
  done < <(grep -nE "$pattern" $files 2>/dev/null || true)
}

echo "lint: Kapitel"
CHAPTERS="template/chapters/*.typ showcase/*.typ"

scan "$CHAPTERS" '#set (page|text|par)\(' \
  "dokumentweite Einstellung im Kapitel" \
  "gehört als Stellschraube in zsf(...) in main.typ"
scan "$CHAPTERS" '#(pagebreak|colbreak)\(' \
  "roher Umbruch" \
  "newcol() ist der einzige Umbruch im System"
scan "$CHAPTERS" '#v\(-?[0-9]' \
  "harter vertikaler Abstand" \
  "Abstand entsteht aus dem Baustein; für einen Blockwechsel gibt es sep()"
# Farbe im Kapitel — dieselbe unbedingte Regel wie unten für src/. Die frühere
# Fassung verlangte den Farbaufruf UNMITTELBAR hinter `fill:`/`stroke:` und
# kannte vier Elementnamen. Damit ging beides durch, was man tatsächlich
# schreibt: `circle(stroke: 1pt + rgb("#215CAF"))` (Rechenausdruck, fremdes
# Element) und `text(fill: red)` (benannte Farbe). Die Referenz-Implementierung
# selbst enthielt genau den ersten Fall, ungemeldet.
scan "$CHAPTERS" '(rgb|luma|cmyk|oklch|oklab|color\.)\(' \
  "direkter Farbgriff" \
  "Farbe kommt aus dem Ton: tone: auto|neutral|warn|<Farbe>, in einer Zeichnung tone().accent"
scan "$CHAPTERS" '(fill|stroke): *[^,)]*\b(red|blue|green|yellow|orange|purple|aqua|fuchsia|maroon|navy|olive|silver|teal|black|white|gray|grey|eastern|lime)\b' \
  "benannte Farbe" \
  "Farbe kommt aus dem Ton: tone().accent, tone().rule, tone().frame-hard"
scan "$CHAPTERS" '#text\([^)]*size:' \
  "lokale Schriftgrösse" \
  "font: \"dense\" am Baustein, oder size/prose-scale in zsf(...)"
scan "$CHAPTERS" '#table\(' \
  "rohe Tabelle" \
  "tabular(cols: (...), ...) — table.cell für Verbünde bleibt erlaubt"

echo "lint: src/"
# Harte Masse gehören in die eine Rechenstelle (config.typ). Technische Nullen
# und relative Masse (em, %, fr) sind erlaubt — sie skalieren mit.
scan "$(ls src/*.typ | grep -v config.typ | tr '\n' ' ')" \
  '[^0-9a-zA-Z_.]([1-9][0-9]*(\.[0-9]+)?|0\.[0-9]+)(pt|mm|cm)' \
  "hartes Mass ausserhalb von config.typ" \
  "als benanntes Mass nach config.typ, dort folgt es Dichte und Grundgrösse"

# Dasselbe für Farbe. Ohne diese Regel standen sieben Grauwerte (30, 35, 40,
# 45, 50, 55, 60 %) über fünf Dateien verstreut — jeder für sich plausibel,
# gemeinsam heller stellen konnte sie niemand.
scan "$(ls src/*.typ | grep -v palette.typ | tr '\n' ' ')" \
  '(luma|rgb|cmyk|oklch|oklab)\(' \
  "rohe Farbe ausserhalb von palette.typ" \
  "als benanntes Token nach palette.typ (ink-muted, ink-faint, ink-ghost …)"

if [ "$fail" -eq 0 ]; then
  echo "lint: ok"
else
  echo "lint: FEHLER"
fi
exit "$fail"
