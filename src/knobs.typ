// =============================================================
// knobs.typ — ein Regler ist eine Tabelle, kein if-Baum
// =============================================================
//
// Zwei Zusagen des Systems hängen an dieser Datei:
//
//   1. Ein falsch geschriebener Regler bricht den Build.
//   2. Ein falsch geschriebener WERT bricht ihn auch.
//
// Die zweite fehlte, solange jeder Regler eine if-Kette war: Ein unbekannter
// Wert fiel hinten heraus und bekam die Vorbelegung. `weight: "quite"` liess
// die Kopfzeile ersatzlos verschwinden — ohne Meldung.
//
// Deshalb ist ein Regler hier ein Wörterbuch Wert → Ergebnis. Das Nachschlagen
// IST die Prüfung, und die Fehlermeldung kennt die erlaubten Werte, ohne dass
// sie jemand zweimal aufschreibt.

/// Schlägt einen Reglerwert nach und bricht bei einem unbekannten ab.
#let pick(name, value, table) = {
  if value not in table {
    panic(
      "Regler »" + name + "«: den Wert " + repr(value) + " gibt es nicht. Erlaubt: "
        + table.keys().map(k => repr(k)).join(", "),
    )
  }
  table.at(value)
}

/// Weist unbekannte Regler-NAMEN ab.
///
/// Nötig, weil ein Baustein einen Argument-Sink braucht (Titel und Rumpf sind
/// positional) — und ein Sink schluckt auch jeden Tippfehler.
#let reject-unknown(baustein, named, known) = {
  let unknown = named.keys().filter(k => k not in known)
  if unknown.len() > 0 {
    panic(
      "Unbekannter Regler an " + baustein + ": " + unknown.join(", ")
        + ". Bekannt sind: " + known.join(", "),
    )
  }
}
