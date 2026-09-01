#!/usr/bin/env python3
"""rules/*.md -> AGENTS.md.

Ein Compiler, kein Framework: Die Regeln werden in fester Reihenfolge
zusammengesetzt, mit Index und Hash-Stempel. `--check` meldet Drift.

Der Vorgänger erzeugte vier Adapter (AGENTS, CLAUDE, .cursor, .agents). Hier
gibt es eine Datei und einen Symlink — jedes Werkzeug, das dieses Repo liest,
liest eines von beiden.
"""

from __future__ import annotations

import hashlib
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
RULES = ROOT / "rules"
OUT = ROOT / "AGENTS.md"
BUDGET = 40_000  # Zeichen; alles hier landet in jeder Sitzung im Kontext

FRONT = re.compile(r"\A---\n(.*?)\n---\n", re.S)


def parse(path: Path) -> tuple[dict[str, str], str]:
    text = path.read_text(encoding="utf-8")
    m = FRONT.match(text)
    if not m:
        sys.exit(f"{path.name}: Frontmatter fehlt (name, scope, purpose)")
    meta = {}
    for line in m.group(1).splitlines():
        if ":" in line:
            k, v = line.split(":", 1)
            meta[k.strip()] = v.strip()
    for key in ("name", "scope", "purpose"):
        if key not in meta:
            sys.exit(f"{path.name}: »{key}« fehlt im Frontmatter")
    return meta, text[m.end() :].strip()


def build() -> str:
    files = sorted(RULES.glob("*.md"))
    if not files:
        sys.exit("rules/ ist leer")
    parsed = [(p, *parse(p)) for p in files]

    body_hash = hashlib.sha256(
        "".join(b for _, _, b in parsed).encode("utf-8")
    ).hexdigest()[:16]

    out = [
        "# ZSF Template (Typst) — AGENTS.md",
        "",
        f"> ERZEUGT — rules-hash:{body_hash}",
        ">",
        "> Quelle: `rules/*.md`. Nicht direkt bearbeiten.",
        "> Ändern: `rules/*.md` editieren → `make sync-rules`. Drift: `make check-rules`.",
        "",
        "Kompiliertes Regelwerk für KI-Agenten. Diese Datei ist eigenständig —",
        "sie enthält alle Projekt-Regeln.",
        "",
        "## Befehle",
        "",
        "```bash",
        "make build      # Katalog bauen (im Fork: die ZSF)",
        "make watch      # live nachbauen",
        "make check      # der ganze Harness",
        "make fork NAME=zsf-fach-fs2026",
        "```",
        "",
        "## Regel-Index",
        "",
    ]
    for path, meta, _ in parsed:
        out.append(f"- `{path.name}` — {meta['scope']} — {meta['purpose']}")
    out += ["", "## Regeln", ""]
    for path, _, body in parsed:
        out += [f"### `{path.name}`", "", body, ""]
    return "\n".join(out).rstrip() + "\n"


def main() -> int:
    text = build()
    size = len(text)
    pct = round(100 * size / BUDGET)

    if "--check" in sys.argv:
        current = OUT.read_text(encoding="utf-8") if OUT.exists() else ""
        if current != text:
            print("check-rules: AGENTS.md weicht von rules/ ab — `make sync-rules`")
            return 1
        print(f"check-rules: synchron ({size // 1000} KB, {pct} % des Budgets)")
        return 0

    OUT.write_text(text, encoding="utf-8")
    link = ROOT / "CLAUDE.md"
    if not link.is_symlink():
        link.unlink(missing_ok=True)
        link.symlink_to("AGENTS.md")
    print(f"sync-rules: AGENTS.md ({size // 1000} KB, {pct} % des Budgets)")
    if pct > 75:
        print("  Budget zu über 75 % belegt — kürzen (rules/60_workflow → Regeln ändern)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
