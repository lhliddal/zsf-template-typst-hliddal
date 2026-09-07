#!/usr/bin/env bash
# =============================================================
# fork.sh — der Fork-Weg muss am Tag 1 funktionieren
# =============================================================
# `00_meta` nennt genau zwei Verpflichtungen des Templates, und dies ist die
# erste. Geprüft wird sie hier am echten Weg: `typst init` aus dem installierten
# Package, dann `make build` im erzeugten Verzeichnis — so, wie ein Fach-Fork
# an seinem ersten Tag entsteht.
#
# `warnings.sh` baut `template/main.typ` an Ort und Stelle und fängt damit den
# einen Fall, dass die Vorlage etwas benutzt, das die Bibliothek nicht mehr hat.
# Es sagt aber nichts darüber, ob `[template]` in `typst.toml` auf die richtigen
# Dateien zeigt, ob das Makefile der Vorlage mitkommt und ob es ohne das
# Repository funktioniert. Genau das kann der Compiler nicht sehen.

set -uo pipefail
cd "$(dirname "$0")/.."
fail=0

WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

echo "fork: typst init → make build"

# Bewusst OHNE TYPST_FONT_PATHS aus diesem Repo: Der Fork muss seine Schriften
# selbst finden (sein Makefile zeigt dafür auf das installierte Package).
unset TYPST_FONT_PATHS

out=$(cd "$WORK" && typst init @local/zsf:0.1.0 zsf-forkcheck 2>&1)
if [ $? -ne 0 ]; then
  echo "  typst init schlägt fehl:"
  sed 's/^/      /' <<<"$out"
  exit 1
fi

DIR="$WORK/zsf-forkcheck"

# Was ein Fork mitbekommt — und was er auf keinen Fall mitbekommt.
for f in main.typ Makefile chapters/01_beispiel.typ; do
  [ -f "$DIR/$f" ] || {
    echo "  $f fehlt im frischen Fork"
    fail=1
  }
done
for f in src lib.typ showcase catalog tests rules AGENTS.md; do
  [ -e "$DIR/$f" ] && {
    echo "  $f ist im Fork gelandet — dort gehört nur Inhalt hin"
    fail=1
  }
done

# Der eigentliche Punkt: baut er mit seinem eigenen Makefile?
build=$(cd "$DIR" && make build 2>&1)
if [ $? -ne 0 ]; then
  echo "  make build im Fork schlägt fehl:"
  sed 's/^/      /' <<<"$build" | head -20
  exit 1
fi

PDF=$(ls "$DIR"/*.pdf 2>/dev/null | head -1)
[ -n "$PDF" ] || {
  echo "  make build erzeugt kein PDF"
  exit 1
}

# Und trägt das Ergebnis seine Identität? Ein Fork, dessen Kennungen leer
# bleiben, ist später keiner Quelle mehr zuzuordnen.
if command -v pdfinfo >/dev/null; then
  info=$(pdfinfo "$PDF")
  grep -qE '^Keywords:.*release-id:DEV-' <<<"$info" || {
    echo "  Fork-PDF ohne Release-Kennung: $(grep -E '^Keywords:' <<<"$info")"
    fail=1
  }
  grep -E '^Page size' <<<"$info" | grep -q "841.89 x 595.276" || {
    echo "  Fork-PDF ist nicht A4 quer: $(grep -E '^Page size' <<<"$info")"
    fail=1
  }
fi

if [ "$fail" -eq 0 ]; then
  echo "fork: ok — $(basename "$PDF") aus einem frischen Fork"
else
  echo "fork: FEHLER"
fi
exit "$fail"
