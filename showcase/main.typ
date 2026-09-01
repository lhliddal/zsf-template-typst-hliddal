// =============================================================
// Living Showcase — jeder Baustein im Fluss einer echten ZSF
// =============================================================
//
// Dieses Dokument ist die Referenz-Implementierung: Was `rules/` behauptet,
// steht hier gesetzt daneben. `make check` baut es und prüft, dass jeder
// öffentliche Name darin vorkommt.
//
// Nicht zu verwechseln mit `catalog/`: Dort stehen dieselben Bausteine mit
// identischem Mustertext nebeneinander, zum Aussortieren. Hier stehen sie im
// Fluss, so wie eine Fach-ZSF sie benutzt.
//
// Ein Fach-Fork enthält es NICHT — `typst init @local/zsf` kopiert nur
// `template/`.

#import "@local/zsf:0.1.0": *

#show: zsf.with(
  title: "ZSF Template",
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

#front("Stichwortverzeichnis", short: "Reg", anchor: <ch:register>)
#make-index()
