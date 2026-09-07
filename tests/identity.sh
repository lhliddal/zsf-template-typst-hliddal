#!/usr/bin/env bash
# =============================================================
# identity.sh — die PDF-Metadaten nach dem Build
# =============================================================
# Titel, Autor und die Kennungen stehen im PDF; ohne sie ist eine ausgegebene
# Datei nicht mehr zuzuordnen. Geprüft wird das FERTIGE PDF, nicht die Quelle.

set -uo pipefail
cd "$(dirname "$0")/.."
PDF="${1:-katalog.pdf}"
RELEASE="${2:-}"
BUILD="${3:-}"
fail=0

[ -f "$PDF" ] || {
  echo "identity: $PDF fehlt — erst bauen"
  exit 1
}
command -v pdfinfo >/dev/null || {
  echo "identity: pdfinfo nicht installiert — übersprungen"
  exit 0
}

info=$(pdfinfo "$PDF")
want() { # feld  muster
  if ! grep -E "^$1:" <<<"$info" | grep -qF "$2"; then
    echo "  $1 enthält »$2« nicht: $(grep -E "^$1:" <<<"$info" || echo '(Feld fehlt)')"
    fail=1
  fi
}

want Title "ZSF Template"
want Author "Hliddal"
# `subject`, `release` und `build` sind auf der Seite unsichtbar bzw. nur als
# Kennung im Fuss zu sehen; ihr einziger Nachweis steht hier. Geprüft wird der
# WERT, nicht das Feld: »build-id:« stünde auch dann im PDF, wenn die
# Stellschraube gar nicht mehr gelesen würde — der leere Wert fiel niemandem
# auf, und `coverage.sh` hielt `build` allein wegen dieses Kommentars für
# geprüft.
want Keywords "subject:Referenz-Implementierung"
[ -n "$RELEASE" ] && want Keywords "release-id:$RELEASE"
[ -n "$BUILD" ] && want Keywords "build-id:$BUILD"
if [ -z "$RELEASE" ] || [ -z "$BUILD" ]; then
  echo "  identity: ohne Release- und Build-Kennung aufgerufen — die zwei"
  echo "      Stellschrauben bleiben dann ungeprüft (Aufruf: identity.sh PDF RELEASE BUILD)"
  fail=1
fi

# Das Format ist Teil der Identität: A4 quer, sonst stimmt der ganze Satz nicht.
if ! grep -E '^Page size' <<<"$info" | grep -q "841.89 x 595.276"; then
  echo "  Seitenformat ist nicht A4 quer: $(grep -E '^Page size' <<<"$info")"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "identity: ok — $(grep -E '^Pages:' <<<"$info" | tr -s ' ')"
else
  echo "identity: FEHLER"
fi
exit "$fail"
