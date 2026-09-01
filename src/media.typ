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
#import "palette.typ": ink-muted
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
    text(size: c.font-size.note, fill: ink-muted, body),
  ))
}

/// Die eigenständige Abbildung. Mehrere Bilder ergeben eine Reihe.
///
///   #fig(image("graphics/skizze.svg"), cap: [Aufbau])
#let fig(..args, cap: none, height: auto) = context {
  let c = conf()
  // `cap` und `height` sind deklariert und damit gebunden, bevor der Sink
  // greift — was in `args.named()` übrig bleibt, sind Box-Regler und geht
  // unverändert an `panel`, das Unbekanntes abweist.
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
  panel(body, ..((surface: "plain", align: center) + args.named()))
}

/// Bild links, Text rechts. `frame: "none"` macht daraus die rahmenlose Fassung.
#let fig-side(picture, body, ..args, ratio: 0.4, height: auto) = context {
  let c = conf()
  panel(
    split(
      image-budget(if height == auto { c.figure-height } else { height }, picture),
      body,
      ratio: ratio,
      align: horizon,
    ),
    ..((surface: "plain") + args.named()),
  )
}
