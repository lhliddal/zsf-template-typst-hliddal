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
  echo '#panel(weight: "quiet")[T][x]'
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
