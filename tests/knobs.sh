#!/usr/bin/env bash
# =============================================================
# knobs.sh — jede Stellschraube muss eine messbare Wirkung haben
# =============================================================
# Eine Stellschraube, die nichts tut, sieht im Code korrekt aus und ist im PDF
# nicht zu sehen — genau die Sorte Defekt, die niemand von selbst bemerkt.
#
# Verglichen wird die GERENDERTE Seite, nicht das PDF: Ein PDF trägt einen
# Zeitstempel und unterscheidet sich bei jedem Lauf ohnehin.

set -uo pipefail
cd "$(dirname "$0")/.."
export TYPST_FONT_PATHS="$PWD/fonts"
mkdir -p tests/out
trap 'rm -rf tests/out' EXIT
fail=0

# Die Probe enthält alles, worauf eine Schraube wirken kann: Balken, Boxen,
# Fliesstext, Formel, Tabelle, Liste, Code, Bild, Marker, Register.
probe_body() {
  cat <<'TYP'
= Kapitel <k>
== Abschnitt <a>
Ein Absatz Fliesstext mit einem Differentialgleichungssystem, lang genug für
mehrere Zeilenumbrüche in einer schmalen Spalte, mit einem #kw[Fachbegriff]
und einem Verweis #xref(<a>).

Ein zweiter Absatz — erst zwischen zweien wird der Absatzabstand sichtbar,
und auch die Silbentrennung braucht Wahrscheinlichkeitsverteilungen als
hinreichend lange Wörter.
#panel[Titel][Inhalt mit #hl[Hervorhebung] und #danger[Warnung].]
#panel(weight: "quiet")[Leise][Kompakt.]
#formula[$ integral_0^1 x^2 dif x = 1/3 $ #note[Anmerkung.]]
#tabular(title: [Tabelle], cols: (1, 1.5), [A], [B], [1], [2], [3], [4])
#facts[Liste][- #item[Marke][Text.]
- Ohne Marke.]
#code[```python
def f(x): return x
```]
#fig(image("../probe.svg"), cap: [Bild])
#tabular(cols: (1, 1), [Bild], [Text], image("../probe.svg"), [in der Zelle])
#front("Register", short: "R")
#make-index()
TYP
}

render() { # argumente → Hash der gerenderten Seiten
  local file="tests/out/probe.typ"
  {
    echo '#import "@local/zsf:0.1.0": *'
    echo "#show: zsf.with($1)"
    probe_body
  } >"$file"
  rm -f tests/out/p*.png
  if ! typst compile "$file" "tests/out/p{p}.png" --ppi 40 --root . >/dev/null 2>&1; then
    echo "BUILD-FEHLER"
    return
  fi
  cat tests/out/p*.png | shasum | cut -d' ' -f1
}

# Ohne Argument: alle Vorbelegungen. So kollidiert keine Prüfung mit dem Grundlauf.
base=$(render '')
if [ "$base" = "BUILD-FEHLER" ]; then
  echo "knobs: Grundlauf schlägt fehl —"
  typst compile tests/out/probe.typ /dev/null --root . 2>&1 | head -20
  exit 1
fi

check() { # beschreibung  argumente
  local got
  got=$(render "$2")
  if [ "$got" = "BUILD-FEHLER" ]; then
    echo "  $1 — Build gescheitert"
    fail=1
  elif [ "$got" = "$base" ]; then
    echo "  $1 — KEINE WIRKUNG"
    fail=1
  fi
}

echo "knobs: Wirkung prüfen"
check "size" 'size: 7pt'
check "prose-scale" 'prose-scale: 0.8'
check "content-scale" 'content-scale: 0.8'
check "leading" 'leading: 1.3'
check "density" 'density: 0.6'
check "density-blocks" 'density-blocks: 0.5'
check "density-text" 'density-text: 2.2'
check "density-tables" 'density-tables: 0.4'
check "density-structure" 'density-structure: 2.4'
check "columns" 'columns: 3'
check "margin" 'margin: 12mm'
check "gutter" 'gutter: 9mm'
check "font" 'font: "Libertinus Serif"'
check "math-font" 'math-font: "New Computer Modern Math"'
check "mono-font" 'mono-font: "Libertinus Serif"'
check "justify" 'justify: true'
check "lang" 'lang: "en", region: "GB"'
check "palette" 'palette: (rgb("#3B0A45"), rgb("#0A453B"), rgb("#453B0A"))'
check "title" 'title: "Anderer Titel"'
check "author" 'author: "A. Anderer"'
check "release" 'release: "v9.9.9"'
check "index-pages" 'index-pages: false'
check "figure-height" 'figure-height: 0.6cm'
check "image-height" 'image-height: 0.3cm'


# `quantities` wirkt nur dort, wo eine Grösse gesetzt wird — eigene Probe mit
# zwei verschiedenen Slots, beide gültig.
qprobe() {
  {
    echo '#import "@local/zsf:0.1.0": *'
    echo "#show: zsf.with(title: \"P\", quantities: (\"Kraft\": $1))"
    echo '= K'
    echo '$#quantity("Kraft", $F$) = m dot a$'
  } >tests/out/q.typ
  rm -f tests/out/q*.png
  typst compile tests/out/q.typ "tests/out/q{p}.png" --ppi 60 --root . >/dev/null 2>&1 || {
    echo BUILD-FEHLER
    return
  }
  cat tests/out/q*.png | shasum | cut -d' ' -f1
}
if [ "$(qprobe 0)" = "$(qprobe 3)" ]; then
  echo "  quantities — KEINE WIRKUNG"
  fail=1
fi

# `quantity-colors: false` muss dieselbe Grösse ungefärbt setzen.
qbw() {
  {
    echo '#import "@local/zsf:0.1.0": *'
    echo "#show: zsf.with(title: \"P\", quantities: (\"Kraft\": 3), quantity-colors: $1)"
    echo '= K'
    echo '$#quantity("Kraft", $F$) = m dot a$'
  } >tests/out/qbw.typ
  rm -f tests/out/qbw*.png
  typst compile tests/out/qbw.typ "tests/out/qbw{p}.png" --ppi 60 --root . >/dev/null 2>&1 || {
    echo BUILD-FEHLER
    return
  }
  cat tests/out/qbw*.png | shasum | cut -d' ' -f1
}
if [ "$(qbw true)" = "$(qbw false)" ]; then
  echo "  quantity-colors — KEINE WIRKUNG"
  fail=1
fi

# `subject` und `build` stehen nur in den PDF-Metadaten und sind auf der Seite
# nicht sichtbar — geprüft werden sie deshalb in identity.sh, nicht hier.

if [ "$fail" -eq 0 ]; then
  echo "knobs: ok — jede Stellschraube wirkt"
else
  echo "knobs: FEHLER"
fi
exit "$fail"
