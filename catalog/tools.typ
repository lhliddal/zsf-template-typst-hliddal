// =============================================================
// catalog/tools.typ — die Werkzeuge des Katalogs
// =============================================================
//
// Diese gehören dem KATALOG, nicht dem Template. Sie stehen hier und nicht in
// `src/`, weil sie nur diesem einen Dokument dienen — und nicht in einer
// Abschnittsdatei, weil dort keine Funktionen definiert werden
// (rules/02_mandat).

#import "@local/zsf:0.1.0": after, panel

// Der Mustertext ist in jedem Eintrag derselbe. Das ist der ganze Trick des
// Katalogs: Was sich zwischen zwei Einträgen unterscheidet, ist dann der
// Baustein und nie der Inhalt.
#let muster = [Mustertext zum Formvergleich. Die zweite Zeile zeigt, wie der
  Container umbricht und wie eng er seinen Inhalt fasst.]
#let kurz = [Mustertext zum Formvergleich.]

/// Die Zweckzeile — und zugleich die Anmeldung des Eintrags beim Inventar.
///
/// - `id`: die Adresse des Eintrags, »D-11 raus« genügt damit als Auftrag
/// - `deckt`: welche öffentlichen Namen der Eintrag zeigt — einer, eine Liste,
///   oder `none` bei Reglerwerten und allem ohne eigenen Namen
///
/// Die Anmeldung steht HIER und nicht im Inventar, weil sie sonst zweimal
/// gepflegt werden müsste. Das Inventar fragt sie ab und rechnet daraus die
/// Vollständigkeit aus — im Vorgänger war beides eine Handliste.
#let zweck(id, deckt, body) = {
  [#metadata((id: id, deckt: deckt))#label("kat-eintrag")]
  after(text(size: 0.88em, fill: luma(30%), body))
}

/// Für Einträge, die keinen eigenen Titel tragen können — Inline-Marker,
/// Verweise, Formelteile. Trägt die ID an derselben Stelle wie ein Boxtitel.
#let eintrag(id, name, body) = panel([#id · #name], body, weight: "quiet")
