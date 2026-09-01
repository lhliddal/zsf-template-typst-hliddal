---
name: 50_formeln
scope: chapters
purpose: Mathematischer Satz
---

Typst bringt den grössten Teil selbst mit — was dort steht, wird verwendet und
nicht nachgebaut:

`RR CC NN ZZ QQ` · `dif x` · `abs(x)` `norm(v)` · `underbrace` `overbrace` ·
`vec` `mat` · `lim_(x->0)` `sum_(k=1)^n` `integral_a^b` · `cases`

## Ergänzt

`sgn` `rang` `Spur` `Ker` `Bild` `eig` `diag` `spann` `proj` `Adj` ·
`grad` `divg` `rot` · `Arsinh` `Arcosh` `Artanh` · `vc(v)` (fetter Vektor).

Kein Opt-in-Modul: Ein paar Operatoren kosten nichts.

## Formelblöcke

Formeln stehen in `formula[…]`, benannte Formeln in
`formula(weight: "caption")[Name][…]`. Mehrere Blöcke in einer Box trennt
`sep()`. Anmerkungen kommen als `note[…]` darunter.

Lange Gleichungen in schmalen Spalten über mehrere Zeilen aufteilen, höchstens
eine Gleichung pro Zeile. Grössere Matrizen nie nebeneinander, sondern
untereinander.

## Farbe in Formeln

**Positional, innerhalb einer Herleitung:** `markA` Quelle/gegeben, `markB`
Gegenstück/abgeleitet, `markC` Ziel/Endform, `markD` dritter Strang (sparsam).
Nur einsetzen, wenn die farbliche Verbindung mathematisch eindeutig stimmt.
Zur blossen Betonung sind sie falsch — dafür gibt es `danger` und `hl`.

**Über das ganze Dokument:** Grössenfarben. Eine Farbe gehört im ganzen
Dokument *einer* Grösse — vergeben in `zsf(quantities: ("Kraft": 0, …))`, nie
im Kapitel. Danach `$#quantity("Kraft", $F$) = m dot a$`. Ein nicht vergebener
Name bricht den Build. Wo ein Fach keine wiederkehrenden Grössen hat, bleibt
der Eintrag leer.

Die Namen sind in Grossbuchstaben (`markA` statt `mark-a`), weil ein
Bindestrich im Mathe-Modus ein Minuszeichen ist.
