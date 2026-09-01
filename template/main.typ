// =============================================================
// <FACH> — Zusammenfassung
// =============================================================
//
//   make watch                      während der Arbeit
//   make build                      fertiges PDF
//
// Immer über `make`, nicht über `typst` direkt: Die Schriften liegen im
// Package und werden dem Compiler vom Makefile übergeben. `make fonts`
// installiert sie zusätzlich ins System, damit auch der Editor sie kennt.
//
// Alle globalen Entscheidungen stehen unten in `zsf(...)`. Was dort nicht
// steht, wird nicht pro ZSF entschieden, sondern pro Stelle über einen Regler
// am Baustein. Ein Tippfehler in einer Stellschraube bricht den Build und
// nennt die bekannten Namen.

#import "@local/zsf:0.1.0": *

#show: zsf.with(
  title: "Fach FS2026",
  author: "Loris Hliddal",
  subject: "Zusammenfassung",
  release: sys.inputs.at("release", default: "DEV"),
  build: sys.inputs.at("build", default: ""),
  // ── Platz gewinnen, in dieser Reihenfolge ──────────────────
  // size: 7pt,          // Grundgrösse; der grösste Hebel (~30 % Fläche 8pt→7pt)
  // density: 0.85,      // Abstände; ~5 % Gesamthöhe
  // leading: 0.95,      // Zeilenhöhe; kleiner Hebel, danach das PDF prüfen
  // prose-scale: 0.9,   // nur der verbindende Fliesstext
  //
  // ── Grössenfarben des Fachs ────────────────────────────────
  // Eine Farbe gehört im ganzen Dokument EINER Grösse. Danach im Kapitel:
  // $#quantity("Kraft", $F$) = m dot a$
  // quantities: ("Kraft": 0, "Weg": 1, "Moment": 4),
)

#include "chapters/01_beispiel.typ"

// Weitere Kapitel hier einhängen. Für einen bewussten Spaltenumbruch
// `#newcol()` vor die Überschrift setzen.

#front("Stichwortverzeichnis", short: "Reg")
#make-index()
