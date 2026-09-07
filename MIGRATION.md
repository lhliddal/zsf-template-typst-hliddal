# Migration: Von LaTeX zu Typst

Leitfaden für die Übertragung bestehender Zusammenfassungen aus dem LaTeX-Vorgängertemplate (`zsf-template`) auf das moderne Typst-System (`zsf-template-typst`).

## Grundprinzipien der Migration

1. **Inhalte bleiben unberührt:** Formulierungen, Stoffumfang und didaktischer Aufbau der bestehenden ZSF werden übernommen. Es geht rein um die technische und typografische Übersetzung.
2. **Keine LaTeX-Workarounds nachbauen:** Typst bricht Zeilen, Spalten und Formeln deterministisch. Manuelle LaTeX-Hacks (`\vbox`, `\vphantom`, `\raisebox`, erzwungene Umbrüche) entfallen ersatzlos.
3. **`make lint` ist die TODO-Liste:** Nach dem ersten Eintragen meldet der Linter exakt, wo noch rohe oder unzulässige Konstrukte stehen.

---

## Befehls-Mapping: LaTeX → Typst

### 1. Struktur & Gliederung

| LaTeX (Vorgänger) | Typst (Neu) | Bemerkung |
|---|---|---|
| `\StartChapter[id]{Titel}` | `= Titel <id>` | Nativer Heading-Level 1 |
| `\StartFrontChapter[id]{Titel}` | `#front("Titel", short: "id")` | Unnummeriertes Front-/Back-Matter |
| `\SubsectionBar[id]{Titel}` | `== Titel <id>` | Nativer Heading-Level 2 |
| `\SubsectionBar*{Titel}` | `== Titel` | Ohne Label |
| `\SubsubsectionBar[id]{Titel}` | `=== Titel <id>` | Nativer Heading-Level 3 |
| `\ZSFNewColumn` | `#newcol()` | Der einzige explizite Spaltenumbruch |

### 2. Boxen & Container

| LaTeX (Vorgänger) | Typst (Neu) | Bemerkung |
|---|---|---|
| `\begin{defbox}[Titel] ... \end{defbox}` | `#panel[Titel][...]` | Standard-Inhaltsbox |
| `\begin{defbox}[][weight=quiet] ...` | `#panel(weight: "quiet")[...]` | Leise Variante mit Akzentkante |
| `\begin{warnbox}[Titel] ... \end{warnbox}` | `#warn[Titel][...]` | Stolperfalle (`tone: "warn"`) |
| `\begin{formulabox}[Titel] ...` | `#formula[Titel][$ ... $]` | Betont geflächter Formelblock |
| `\begin{figbox}[Titel] ... \end{figbox}` | `#picture[Titel][...]` | Container für Zeichnungen |
| `\begin{splitbox}[split=0.4] A \tcblower B` | `#split[A][B]` | Zwei Blöcke nebeneinander |
| `\begin{goalbox}[Titel] ... \end{goalbox}` | `#steps[Titel][#case[Bed.][Ausdr.][Ziel]]` | Herleitungen und Zielketten |
| `\begin{codebox}[Titel] ... \end{codebox}` | `#code[Titel][```lang ... ```]` | Nativer Typst-Codeblock |

### 3. Fügen, Trennen & Abstände

| LaTeX (Vorgänger) | Typst (Neu) | Bemerkung |
|---|---|---|
| `\ZSFsep` | `#sep()` | Blocktrenner innerhalb einer Box |
| `\ZSFsep[Titel]` | `#sep(label: [Titel])` | Trenner mit Beschriftung |
| `\formulanote{Text}` | `#note[Text]` | Dezente Notiz unter Formel/Aussage |
| `\textVorBox{Text}` | `#before[Text]` | Text an nachfolgende Box binden |
| `\textNachBox{Text}` | `#after[Text]` | Text an vorhergehende Box binden |
| `\ZSFgap[XS\|S\|M\|L]` | `#gap("xs"\|"s"\|"m"\|"l")` | Semantischer Abstand (weak collapse) |
| `\ZSFSectionGap` | `#gap("section")` | Thementrenner ohne neuen Balken |

### 4. Inline-Marker & Verweise

| LaTeX (Vorgänger) | Typst (Neu) | Bemerkung |
|---|---|---|
| `\ZSFkeyword{Begriff}` | `#kw[Begriff]` | Scan-Anker mit automatischem Registereintrag |
| `\ZSFkeyword*{Begriff}` | `#kw(index: false)[Begriff]` | Scan-Anker ohne Registereintrag |
| `\ZSFlabel{Text}` | `#lbl[Text]` | Neutrale fette Beschriftung |
| `\ZSFdanger{Text}` | `#danger[Text]` | Inline-Warnpille |
| `\ZSFconclusion{Text}` | `#concl[Text]` | Folgerungspfeil |
| `\ZSFhl{Text}` | `#hl[Text]` | Gelber Textmarker für Kernaussage |
| `\ZSFref{label}` | `#xref(<label>)` | Querverweis mit Zielkapitelfarbe |
| `\ZSFsectionref{label}` | `#sec-ref(<label>)` | Nur kompakte Zielnummer |
| `\ZSFScriptRef{42}` | `#script-ref(42)` | Skript-Seitenzahl |
| `\ZSFindex{Begriff}` | `#idx("Begriff")` | Unsichtbarer Registeranker |
| `\ZSFindexsee{Synonym}{Ziel}` | `#idx-see("Synonym", "Ziel")` | Synonymverweis im Register |

### 5. Tabellen

| LaTeX (Vorgänger) | Typst (Neu) | Bemerkung |
|---|---|---|
| `\begin{tablebox}[Titel]` + `\begin{ZSFtable}` | `#tabular(title: [Titel], cols: (1, 1.2), ...)` | Tabelle und Box sind **ein** Baustein |
| `\ZSFheaderRow \ZSFhead{A} & \ZSFhead{B}` | `[A], [B],` | Die ersten Zellen **sind** der Header |
| `Y{1.4} Z{0.8} Q{0.8}` (Spaltengewichte) | `cols: (1.4, 0.8, 0.8)` | Einfaches Zahlen-Array |
| `\ZSFspan{C}{2}{Inhalt}` | `table.cell(colspan: 2)[Inhalt]` | Nativer Zellverbund |
| `\ZSFimage{grafik.svg}` | `image("graphics/grafik.svg")` | Tabelle setzt die Höhe automatisch |
| `[header=false]` | `header: false` | Zebra beginnt ab Zeile 1 |
| `[zebra=false]` | `zebra: false` | Keine Streifen |
| `[grid=horizontal\|none]` | `grid: "horizontal"\|"none"` | Linien-Steuerung |
| `[rows=roomy\|tight]` | `rows: "roomy"\|"tight"` | Zeilenhöhe |
| `[colsep=tight]` | `colsep: "tight"` | Zellpolsterung |

### 6. Listen

| LaTeX (Vorgänger) | Typst (Neu) | Bemerkung |
|---|---|---|
| `\begin{ZSFlist}[Titel] \ZSFItem{M}{Text}` | `#facts(title: [Titel])[ - #item[M][Text] ]` | Markdown-Liste mit `#item` |
| `\begin{ZSFlist}[ordered] \ZSFItem{M}{Text}` | `#facts[ + #item[M][Text] ]` | Mit `+` statt `-` geordnet |

### 7. Mathematik

| LaTeX (Vorgänger) | Typst (Neu) | Bemerkung |
|---|---|---|
| `\R, \C, \N, \Z, \Q` | `$RR, CC, NN, ZZ, QQ$` | Typst Standard-Symbole |
| `\dd x` | `$dif x$` | Aufrechtes Differential |
| `\vect v` | `$vc(v)$` | Vektorsatz |
| `\abs{x}, \norm{v}` | `$abs(x), norm(v)$` | Gepaarte Begrenzer |
| `\grad, \divg, \rot` | `$grad, divg, rot$` | Feldoperatoren |
| `\Ker, \rang, \Spur, \diag` | `$Ker, rang, Spur, diag$` | Operatoren aus `src/maths.typ` |
| `\ZSFmhlA{...}` bis `\ZSFmhlD{...}` | `$markA(...)$` bis `$markD(...)$` | Farbige Termverfolgung |
| `\ZSFqKraft{F}` | `#quantity("Kraft", $F$)` | Grössenfarben |

---

## Typst-spezifische Besonderheiten beachten

1. **Mathematik-Modus:**
   * Inline-Mathe steht zwischen zwei Dollarzeichen: `$x^2 + 1$`.
   * Display-Mathe hat Leerzeichen um die Dollarzeichen: `$ integral_0^1 f(x) dif x $`.
2. **Labels und Referenzen:**
   * Labels werden mit spitzen Klammern definiert: `<ch:intro>`, `<sec:definition>`.
   * Referenzen über `#xref(<ch:intro>)`.
3. **Listen und Aufzählungen:**
   * Reine Markdown-Syntax: `- Eintrag` (Aufzählung), `+ Eintrag` (Nummerierung).
