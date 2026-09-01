// =============================================================
// Baustein-Katalog — zweites Dokument neben showcase/
// =============================================================
// Zweck: EINE Seite Wahrheit darüber, was das Template an sichtbaren
// Bausteinen hergibt. Jeder Eintrag zeigt denselben Mustertext, damit
// Unterschiede rein gestalterisch sind und Redundanz auffällt.
//
// Bewusst KEINE zweite Showcase:
//   showcase/ — führt die Bausteine im Fluss einer ZSF vor
//               (Referenz-Implementierung, Grundlage von `make coverage`)
//   catalog/  — reiht sie zum Vergleich nebeneinander
//               (Arbeitsinstrument fürs Aussortieren; prüft nichts)
//
// Bauen: make catalog → katalog.pdf

#import "@local/zsf:0.1.0": *

#show: zsf.with(
  title: "Baustein-Katalog",
  author: "Loris Hliddal",
  subject: "Arbeitsinstrument",
  release: sys.inputs.at("release", default: "DEV"),
  build: sys.inputs.at("build", default: ""),
  quantities: ("Kraft": 0, "Weg": 1),
)

#include "a_lesehilfe.typ"
#include "b_struktur.typ"
#include "c_boxen.typ"
#include "d_regler.typ"
#include "e_tabellen.typ"
#include "f_marker.typ"
#include "g_bilder_formeln.typ"
#include "h_inventar.typ"
