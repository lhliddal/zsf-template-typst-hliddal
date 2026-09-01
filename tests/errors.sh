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
  echo '#xref(<k>)'
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
