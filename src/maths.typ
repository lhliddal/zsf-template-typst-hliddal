// =============================================================
// maths.typ — Operatoren, die Typst nicht mitbringt
// =============================================================
//
// Kurz, weil das meiste nativ ist: `RR CC NN ZZ QQ`, `dif`, `abs norm`,
// `underbrace overbrace`, `vec mat`, `lim` mit Grenzen. Was der Vorgänger in
// 10_math und 11_math_advanced definierte, steht hier nur noch, soweit es
// tatsächlich fehlt — und ohne Opt-in-Schalter, weil ein paar Operatoren
// nichts kosten.

// ── Analysis / Allgemein ─────────────────────────────────────
#let sgn = math.op("sgn")
#let grad = math.op("grad")
#let divg = math.op("div")
#let rot = math.op("rot")

// ── Lineare Algebra ──────────────────────────────────────────
#let Ker = math.op("Ker")
#let Bild = math.op("Bild")
#let rang = math.op("rang")
#let Spur = math.op("Spur")
#let diag = math.op("diag")
#let spann = math.op("span")
#let eig = math.op("eig")
#let proj = math.op("proj")
#let Adj = math.op("Adj")

// ── Areafunktionen ───────────────────────────────────────────
#let Arsinh = math.op("Arsinh")
#let Arcosh = math.op("Arcosh")
#let Artanh = math.op("Artanh")

// ── Vektor: fett statt Pfeil (spart Höhe in schmalen Spalten) ─
#let vc = body => math.bold(body)
