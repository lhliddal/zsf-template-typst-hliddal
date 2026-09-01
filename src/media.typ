// =============================================================
// media.typ — Abbildungen
// =============================================================
//
// Bildpfade stehen IMMER im Kapitel, nie hier: Package-Code darf nur eigene
// Dateien lesen, ein durchgereichter Pfad würde relativ zum Package aufgelöst
// und nicht gefunden. Der Autor schreibt also `image("graphics/x.svg")`.
//
// Daraus folgt der bessere Entwurf: Die maximale Höhe gehört dem CONTAINER und
// wird als `set`-Regel gesetzt. In einer Tabellenzeile passt ein Bild in die
// Zeile, als eigener Block füllt es einen — beides ohne Zutun des Aufrufs.
// Ein `image(…, height: …)` im Kapitel sticht die Vorbelegung, weil eine
// ausdrückliche Angabe eine Set-Regel immer schlägt.

#import "config.typ": conf
#import "blocks.typ": panel, split

/// Bindet die Bildhöhe an das Budget des Containers.
#let image-budget(height, body) = {
  set image(height: height, fit: "contain")
  body
}

/// Bildunterschrift. Nur nötig, wenn eine `picture` direkt befüllt wird
/// (Zeichnung statt Bilddatei) — `fig` setzt sie selbst.
#let caption(body) = context {
  let c = conf()
  block(above: c.space.xs, below: 0pt, width: 100%, align(
    center,
    text(size: c.font-size.note, fill: luma(35%), body),
  ))
}

/// Die eigenständige Abbildung. Mehrere Bilder ergeben eine Reihe.
///
///   #fig(image("graphics/skizze.svg"), cap: [Aufbau])
#let fig(..args) = context {
  let c = conf()
  let named = args.named()
  let cap = named.at("cap", default: none)
  let height = named.at("height", default: auto)
  let box-args = named
  for k in ("cap", "height") {
    if k in box-args { box-args.remove(k) }
  }

  let images = args.pos()
  let body = {
    image-budget(if height == auto { c.figure-height } else { height }, {
      if images.len() == 1 { images.first() } else {
        grid(
          columns: images.len(),
          gutter: c.pad.x,
          align: center + horizon,
          ..images,
        )
      }
    })
    if cap != none { caption(cap) }
  }
  panel(body, ..((surface: "plain", align: center) + box-args))
}

/// Bild links, Text rechts. `frame: "none"` macht daraus die rahmenlose Fassung.
#let fig-side(picture, body, ..args) = context {
  let c = conf()
  let named = args.named()
  let ratio = named.at("ratio", default: 0.4)
  let height = named.at("height", default: auto)
  let box-args = named
  for k in ("ratio", "height") {
    if k in box-args { box-args.remove(k) }
  }

  panel(
    split(
      image-budget(if height == auto { c.figure-height } else { height }, picture),
      body,
      ratio: ratio,
      align: horizon,
    ),
    ..((surface: "plain") + box-args),
  )
}
