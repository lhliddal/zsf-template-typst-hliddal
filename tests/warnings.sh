#!/usr/bin/env bash
# =============================================================
# warnings.sh — der Compiler hat immer recht
# =============================================================
# Typst meldet Dinge, die kompilieren, aber nicht gemeint sind: `**fett**` aus
# Markdown-Gewohnheit erzeugt zwei leere Auszeichnungen und lässt den Text
# unbetont stehen. Der Build läuft, die Seite sieht fast richtig aus, und
# niemand schaut in die Ausgabe.
#
# Geprüft werden alle drei Dokumente, die dieses Repository baut — die dritte
# ist der frisch erzeugte Fork: Sonst merkt niemand, wenn die Fork-Vorlage
# etwas benutzt, das die Bibliothek nicht mehr hat.

set -uo pipefail
cd "$(dirname "$0")/.."
export TYPST_FONT_PATHS="$PWD/fonts"
mkdir -p tests/out
trap 'rm -rf tests/out' EXIT
fail=0

check() { # name  quelle  wurzel
  local out
  out=$(typst compile "$2" tests/out/w.pdf --root "$3" 2>&1)
  if [ -n "$out" ]; then
    echo "  $1:"
    sed 's/^/      /' <<<"$out" | head -20
    fail=1
  fi
}

echo "warnings: sauber bauen"
check "Referenz" showcase/main.typ .
check "Katalog" catalog/main.typ .
# Die Fork-Vorlage baut gegen das installierte Package, mit sich selbst als
# Wurzel — genau so, wie ein Fach-Fork sie später baut.
check "Fork-Vorlage" template/main.typ template

if [ "$fail" -eq 0 ]; then
  echo "warnings: ok — keine Meldung in Referenz, Katalog und Fork-Vorlage"
else
  echo "warnings: FEHLER"
fi
exit "$fail"
