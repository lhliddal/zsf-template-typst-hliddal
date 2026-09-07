#!/usr/bin/env bash
# =============================================================
# errors.sh — falsche Eingaben müssen laut scheitern
# =============================================================
# Der teuerste Defekt ist der, der nichts tut: ein Regler mit Tippfehler, ein
# Verweis ins Leere, eine Grösse, die niemand vergeben hat. In LaTeX war das
# der Normalfall und der Grund für den halben Verifier-Bestand des Vorgängers.
#
# Hier wird geprüft, dass jede dieser Eingaben mit einer VERSTÄNDLICHEN Meldung
# abbricht — nicht nur, dass sie abbricht.

set -uo pipefail
cd "$(dirname "$0")/.."
export TYPST_FONT_PATHS="$PWD/fonts"
mkdir -p tests/out
trap 'rm -rf tests/out' EXIT
fail=0

expect() { # beschreibung  erwartete-textstelle  rumpf
  {
    echo '#import "@local/zsf:0.1.0": *'
    echo "#show: zsf.with()"
    echo '= Kapitel <k>'
    printf '%s\n' "$3"
  } >tests/out/e.typ
  local out rc
  out=$(typst compile tests/out/e.typ tests/out/e.pdf --root . 2>&1)
  rc=$?
  if [ "$rc" -eq 0 ]; then
    echo "  $1 — kein Fehler (still durchgelaufen)"
    fail=1
  elif ! grep -qF "$2" <<<"$out"; then
    echo "  $1 — Meldung nennt »$2« nicht:"
    echo "      $(head -2 <<<"$out" | tail -1)"
    fail=1
  fi
}

echo "errors: falsche Eingaben"
expect "Regler mit Tippfehler" "Unbekannter Regler" '#panel(weigth: "quiet")[T][x]'
expect "Regler auf einer Vorbelegung" "Unbekannter Regler" '#formula(padx: "none")[x]'
expect "unbekannter Ton" "erwartet auto" '#panel(tone: "lila")[T][x]'
expect "zu viele Argumente" "erwartet [Rumpf]" '#panel[a][b][c]'
expect "Verweis ins Leere" "gibt es nicht" '#xref(<nichtvorhanden>)'
expect "nicht vergebene Grösse" "Unbekannte Grösse" '$#quantity("Kraft", $F$)$'

# Der Sink schluckt auch an Tabelle, Liste und Abbildung. `tabular(colss: …)`
# war der teuerste Fall: Die Tabelle stand einspaltig, und nichts brach.
expect "Regler an der Tabelle" "Unbekannter Regler" '#tabular(zebar: false, cols: (1,), [a])'
expect "Spaltenliste mit Tippfehler" "Unbekannter Regler" '#tabular(colss: (1, 2), [a], [b])'
expect "Regler an der titellosen Liste" "Unbekannter Regler" '#facts(frmae: "hard")[- x]'
expect "Box-Regler ohne Träger" "Unbekannter Regler" '#facts(frame: "hard")[- x]'
expect "Regler an der Abbildung" "Unbekannter Regler" '#fig(rect(), captoin: [x])'

# Nicht nur der NAME eines Reglers, auch sein WERT. Als if-Kette fiel ein
# falscher Wert hinten heraus und bekam die Vorbelegung: `weight: "quite"`
# liess die Kopfzeile ersatzlos verschwinden — ohne Meldung.
expect "Wert von weight" "Regler »weight«" '#panel(weight: "quite")[T][x]'
expect "Wert von pad" "Regler »pad«" '#panel(pad: "tigt")[T][x]'
expect "Wert von frame" "Regler »frame«" '#panel(frame: "hrad")[T][x]'
expect "Wert von surface" "Regler »surface«" '#panel(surface: "emphsis")[T][x]'
expect "Wert von font" "Regler »font«" '#panel(font: "dens")[T][x]'
expect "Wert von align" "Regler »align«" '#panel(align: "mitte")[T][x]'
expect "Wert von grid" "Regler »grid«" '#tabular(cols: (1,), grid: "hoizontal", [a])'
expect "Wert von rows" "Regler »rows«" '#tabular(cols: (1,), rows: "romy", [a])'
expect "Wert von colsep" "Regler »colsep«" '#tabular(cols: (1,), colsep: "tigt", [a])'
expect "Wert von gap" "Regler »gap«" '#gap("tigt")'
expect "Dichte von density-scope" "density-scope" '#density-scope(-1)[x]'
expect "breakable von density-scope" "density-scope" '#density-scope(breakable: "ja")[x]'

# Der zweite stille Fehlschlag neben dem Sink: eine Eingabe, die durchläuft und
# dabei etwas WEGLÄSST. Das Register hing daran gleich dreifach.
expect "Begriff, den das Register nicht lesen kann" "nicht als Text" '#kw[$C^1$-Funktion]'
expect "Registereintrag ohne Begriff" "ohne Begriff" '#idx("")'
expect "siehe-Verweis ins Leere" "ohne Begriff" '#idx-see("EW", "")'
expect "drittes Argument an fig-side" "genau zwei Teile" '#fig-side(rect(), [a], [b])'
expect "Ausrichtung je Spalte, falsche Anzahl" "Regler »align«" \
  '#tabular(cols: (1, 1, 1), align: (left, right), [A], [B], [C])'
expect "Ausrichtung, die keine ist" "Regler »align«" \
  '#tabular(cols: (1,), align: ("rechts",), [A])'

# Entartete Geometrie: kompiliert, sieht aber falsch aus. Ohne Spalten fällt
# alles in eine, mit Gewicht 0 drucken zwei Zellen übereinander, und ein
# `ratio` ausserhalb (0,1) gibt einer Hälfte negative Breite.
expect "Tabelle ohne Spalten" "mindestens eine Spalte" '#tabular(cols: (), [a], [b])'
expect "Spaltengewicht null" "grösser null" '#tabular(cols: (0, 1), [a], [b])'
expect "negatives Spaltengewicht" "grösser null" '#tabular(cols: (1, -2), [a], [b])'
expect "split ausserhalb von 0..1" "echt zwischen" '#split([a], [b], ratio: 1.4)'
expect "split mit ratio 0" "echt zwischen" '#split([a], [b], ratio: 0)'

# Die Stellschrauben werden am selben Muster geprüft, aber am Dokumentkopf.
# Ausgabe erst einfangen, dann durchsuchen: In einer Pipe würde `pipefail` am
# Exitcode des Compilers hängenbleiben, obwohl die Meldung stimmt.
{
  echo '#import "@local/zsf:0.1.0": *'
  echo '#show: zsf.with(titel: "Tippfehler")'
  echo '= K'
} >tests/out/e.typ
knob_out=$(typst compile tests/out/e.typ tests/out/e.pdf --root . 2>&1)
if ! grep -qF "Unbekannte Stellschraube" <<<"$knob_out"; then
  echo "  Stellschraube mit Tippfehler — keine verständliche Meldung"
  fail=1
fi

# Grössenfarben: Zwei Namen auf demselben Slot bekamen still dieselbe Farbe,
# und ein Slot ausserhalb der Liste rutschte per `calc.rem` auf einen fremden.
# Damit sagte die Farbe nichts mehr — der einzige Zweck des Reglers.
for q in 'quantities: ("Kraft": 0, "Moment": 0)' 'quantities: ("Weg": 8)' 'quantities: ("Weg": -1)'; do
  {
    echo '#import "@local/zsf:0.1.0": *'
    echo "#show: zsf.with($q)"
    echo '= K'
  } >tests/out/e.typ
  q_out=$(typst compile tests/out/e.typ tests/out/e.pdf --root . 2>&1)
  if ! grep -qF "Grösse »" <<<"$q_out"; then
    echo "  $q — keine verständliche Meldung"
    fail=1
  fi
done

# Eine Palette mit einer Farbe teilte in der Farbrotation durch null — ein roher
# Compiler-Fehler mitten in src/, statt einer Meldung mit dem Namen der Schraube.
{
  echo '#import "@local/zsf:0.1.0": *'
  echo '#show: zsf.with(palette: (rgb("#333333"),))'
  echo '= K'
} >tests/out/e.typ
pal_out=$(typst compile tests/out/e.typ tests/out/e.pdf --root . 2>&1)
if ! grep -qF "Stellschraube »palette«" <<<"$pal_out"; then
  echo "  Palette mit einer Farbe — keine verständliche Meldung"
  fail=1
fi

# check-overflow mit ungültigem Typ
{
  echo '#import "@local/zsf:0.1.0": *'
  echo '#show: zsf.with(check-overflow: "ja")'
  echo '= K'
} >tests/out/e.typ
of_out=$(typst compile tests/out/e.typ tests/out/e.pdf --root . 2>&1)
if ! grep -qF "Stellschraube »check-overflow«" <<<"$of_out"; then
  echo "  check-overflow mit falschem Typ — keine verständliche Meldung"
  fail=1
fi

# Gegenprobe: die richtige Schreibweise darf NICHT scheitern. Ohne sie könnte
# dieser Test grün sein, weil einfach alles abbricht.
{
  echo '#import "@local/zsf:0.1.0": *'
  echo '#show: zsf.with(title: "Richtig")'
  echo '= K <k>'
  echo '#panel(weight: "quiet", pad: "bar", frame: "none", font: "dense")[T][x]'
  echo '#panel(weight: "caption", surface: "emphasis", align: center)[T][x]'
  echo '#tabular(cols: (1, 2), grid: "none", rows: "roomy", colsep: "tight", font: "dense", [a], [b])'
  echo '#facts(tone: "warn")[- x]'
  echo '#fig(rect(), cap: [C], tone: "neutral")'
  echo '#fig-side(rect(), [t], ratio: 0.3, frame: "none")'
  echo '#tabular(cols: (1, 2), [A], table.cell(colspan: 1)[B], [1], [2])'
  echo '#tabular(cols: (1, 1, 1), table.cell(colspan: 3)[Gruppe], [1], [2], [3])'
  echo '#tabular(cols: (1, 1), [K], [W], table.cell(rowspan: 2)[hoch], [1], [2])'
  echo '#tabular(cols: (1, 1), header: false, [a], [b], [c], [d])'
  echo '#xref(<k>)'
  echo '#tabular(cols: (1, 1), align: (left, right), [A], [B], [x], [1])'
  echo '#kw(term: "C¹-Funktion")[$C^1$-Funktion] #kw[Satz von *Taylor*]'
  echo '#idx("Ω") #idx-see("Ω", "Ohm")'
  echo '#context [#tone().accent]'
  echo '#make-index()'
} >tests/out/e.typ
if ! typst compile tests/out/e.typ tests/out/e.pdf --root . >/dev/null 2>&1; then
  echo "  Gegenprobe gescheitert — korrekte Eingabe baut nicht"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "errors: ok — jede falsche Eingabe bricht verständlich ab"
else
  echo "errors: FEHLER"
fi
exit "$fail"
