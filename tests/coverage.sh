#!/usr/bin/env bash
# =============================================================
# coverage.sh — was es gibt, wird vorgeführt und beschrieben
# =============================================================
# Zwei Zusagen, je eine Richtung:
#   1. Jeder öffentliche Name steht im Katalog gesetzt — sonst behauptet die
#      Doku eine API, die niemand vergleichen kann.
#   2. Jeder öffentliche Name steht in rules/ — sonst existiert er für eine KI
#      nicht, und sie erfindet sich einen Ersatz.
# Dasselbe für die Stellschrauben aus config.typ.

set -uo pipefail
cd "$(dirname "$0")/.."
fail=0

# Öffentliche Namen: alles, was lib.typ aus src/ re-exportiert.
names=$(
  grep -E '^#import "src/[a-z]+\.typ": ' lib.typ \
    | grep -v ' as _' \
    | sed -E 's/^#import "src\/[a-z]+\.typ": //' \
    | tr ',' '\n' | sed -E 's/.* as //' | tr -d ' ' | grep -vE '^\*?$' | sort -u
)
names="$names
zsf"

# Namen, die von dieser Prüfung ausgenommen sind. Die Liste ist leer und soll
# es bleiben: Jeder öffentliche Name wird in `showcase/` oder `template/`
# vorgeführt — auch `tone-of`, das dort die Palette-Übersicht setzt.
internal=""

# Wird der Name irgendwo aufgerufen? Zwei Muster statt eines mit »^« in einer
# Gruppe: BSD-grep wertet den Anker dort unzuverlässig aus, und ein Verifier,
# der still immer durchwinkt, ist schlimmer als keiner.
used() { # name  dateien…
  local n="$1"
  shift
  grep -qE "[^A-Za-z0-9_-]$n[[(.]" "$@" 2>/dev/null || grep -qE "^$n[[(.]" "$@" 2>/dev/null
}

DEMO_FILES=(showcase/*.typ template/main.typ template/chapters/*.typ)

# Selbstprüfung: ein bekannter Name muss gefunden, ein erfundener darf nicht
# gefunden werden. Ohne sie merkt niemand, wenn das Muster kaputtgeht.
used panel "${DEMO_FILES[@]}" || {
  echo "coverage: Selbstprüfung gescheitert — »panel« wird nicht gefunden"
  exit 2
}
used gibtesnichtxyz "${DEMO_FILES[@]}" && {
  echo "coverage: Selbstprüfung gescheitert — erfundener Name wird gefunden"
  exit 2
}

echo "coverage: öffentliche Namen"
for n in $names; do
  case " $internal " in *" $n "*) continue ;; esac
  # Vorsicht: »[.« in einer Zeichenklasse ist ein POSIX-Collating-Symbol.
  if ! used "$n" "${DEMO_FILES[@]}"; then
    echo "  $n — nirgends vorgeführt (showcase/ oder template/)"
    fail=1
  fi
  if ! grep -qF "$n" rules/*.md 2>/dev/null; then
    echo "  $n — in rules/ nicht beschrieben"
    fail=1
  fi
done

echo "coverage: Stellschrauben"
knobs=$(
  sed -n '/^#let defaults = (/,/^)/p' src/config.typ \
    | grep -E '^  [a-z-]+:' | sed -E 's/^  ([a-z-]+):.*/\1/'
)
# Exakt suchen, nicht als Teilzeichenkette: »index« ginge sonst durch, weil
# »index-pages« ihn enthält — ein toter Regler bliebe unbemerkt.
exact() { grep -qE "[^A-Za-z0-9_-]$1[^A-Za-z0-9_-]" "${@:2}" 2>/dev/null; }
for k in $knobs; do
  if ! exact "$k" rules/*.md; then
    echo "  $k — Stellschraube in rules/ nicht beschrieben"
    fail=1
  fi
  # Sichtbare Schrauben prüft knobs.sh am Satz, unsichtbare identity.sh am PDF.
  if ! exact "$k" tests/knobs.sh && ! exact "$k" tests/identity.sh; then
    echo "  $k — Stellschraube wird nirgends auf Wirkung geprüft"
    fail=1
  fi
done

# Die README nennt die Zahl der Stellschrauben. Sie stand sechs zu niedrig, und
# das fiel nicht auf, weil eine Prosazahl von nichts abgeleitet ist — dieselbe
# Sorte stiller Drift wie ein Regler, der nirgends beschrieben ist.
readme_n=$(grep -oE '\*\*Stellschrauben\*\* — [0-9]+ benannte' README.md | grep -oE '[0-9]+')
actual_n=$(wc -w <<<"$knobs" | tr -d ' ')
if [ -z "$readme_n" ]; then
  echo "  README nennt die Zahl der Stellschrauben nicht mehr im erwarteten Satz"
  echo "      (»**Stellschrauben** — N benannte Argumente«) — Prüfung greift ins Leere"
  fail=1
elif [ "$readme_n" != "$actual_n" ]; then
  echo "  README nennt $readme_n Stellschrauben, config.typ hat $actual_n"
  fail=1
fi

# Die Gegenrichtung: eine Regel darf keinen Namen nennen, den es nicht gibt.
echo "coverage: rules/ gegen die API"
for n in $(grep -ohE '`[a-z][a-z-]{2,}\(\)`' rules/*.md 2>/dev/null | tr -d '`()' | sort -u); do
  if ! grep -qxF "$n" <<<"$names" && ! grep -qE "#let $n" src/*.typ lib.typ; then
    echo "  $n() — in rules/ beschrieben, existiert aber nicht"
    fail=1
  fi
done

if [ "$fail" -eq 0 ]; then
  echo "coverage: ok"
else
  echo "coverage: FEHLER"
fi
exit "$fail"
