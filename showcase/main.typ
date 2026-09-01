// =============================================================
// Living Showcase — jeder Baustein und jeder Regler, real gesetzt
// =============================================================
//
// Dieses Dokument ist die Referenz-Implementierung: Was `styles/README` und
// `rules/` behaupten, steht hier gesetzt daneben. `make check` baut es und
// prüft, dass jeder öffentliche Name darin vorkommt.
//
// Ein Fach-Fork enthält es NICHT — `typst init @local/zsf` kopiert nur
// `template/`.

#import "@local/zsf:0.1.0": *

#show: zsf.with(
  title: "ZSF Template — Katalog",
  author: "Loris Hliddal",
  subject: "Referenz-Implementierung",
  release: sys.inputs.at("release", default: "DEV"),
  build: sys.inputs.at("build", default: ""),
  quantities: ("Kraft": 0, "Weg": 1, "Moment": 4),
)

#include "01_bausteine.typ"
#include "02_regler.typ"
#include "03_tabellen.typ"
#include "04_formeln.typ"
#include "05_marker.typ"
#include "06_bilder.typ"
#include "07_stellschrauben.typ"
#include "08_palette.typ"

#front("Stichwortverzeichnis", short: "Reg")
#make-index()
