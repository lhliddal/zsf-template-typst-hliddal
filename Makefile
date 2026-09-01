# =============================================================
# zsf — Template-Repository
# =============================================================
# Ein Fach-Fork bekommt sein eigenes, kürzeres Makefile aus template/.

SHELL      := /bin/bash
PKG_NAME   := zsf
PKG_VER    := 0.1.0
# Zwei Dokumente, zwei Zwecke (rules/10_architektur):
#   showcase/ → die Referenz-Implementierung, im Fluss einer echten ZSF
#   catalog/  → alle Bausteine nebeneinander, zum Aussortieren
SHOWCASE   := template_fs0000_hliddal.pdf
CATALOG    := katalog.pdf
PKG_DIR    := $(HOME)/Library/Application Support/typst/packages/local/$(PKG_NAME)/$(PKG_VER)
ROOT       := $(CURDIR)

# Schriften liegen im Package, nicht im System — der Build ist damit auf jedem
# Rechner derselbe, ohne Installation.
export TYPST_FONT_PATHS := $(ROOT)/fonts

BUILD_DATE := $(shell date +%Y-%m-%d)
RELEASE_ID ?= DEV-$(BUILD_DATE)
BUILD_ID   := $(shell date -u +%Y%m%dT%H%M%SZ)-$(shell git rev-parse --short HEAD 2>/dev/null || echo nogit)
TYPST_ARGS := --root $(ROOT) --input release=$(RELEASE_ID) --input build=$(BUILD_ID)

.PHONY: all build watch catalog catalog-status fonts check test errors lint knobs coverage identity install fork thumbnail fmt sync-rules check-rules clean help

all: build

## build — die Referenz-Implementierung bauen
build: install
	@typst compile showcase/main.typ $(SHOWCASE) $(TYPST_ARGS)
	@echo "$(SHOWCASE) — $$(typst --version)"

## watch — Referenz live nachbauen
watch: install
	@typst watch showcase/main.typ $(SHOWCASE) $(TYPST_ARGS)

## catalog — den Baustein-Katalog bauen (Arbeitsinstrument, kein Prüfgegenstand)
catalog: install
	@typst compile catalog/main.typ $(CATALOG) $(TYPST_ARGS)
	@echo "$(CATALOG) — $$(pdfinfo $(CATALOG) 2>/dev/null | awk '/^Pages/{print $$2" Seiten"}')"

## catalog-status — ist der Katalog noch aktuell?
catalog-status:
	@if [ ! -f $(CATALOG) ]; then echo "Katalog: $(CATALOG) fehlt — 'make catalog'."; \
	elif [ -n "$$(find catalog src lib.typ -newer $(CATALOG) -print -quit 2>/dev/null)" ]; then \
	  echo "Katalog: $(CATALOG) ist VERALTET — 'make catalog'."; \
	else echo "Katalog: $(CATALOG) aktuell."; fi

## install — Package unter @local/zsf verfügbar machen (Symlink auf dieses Repo)
install:
	@mkdir -p "$$(dirname "$(PKG_DIR)")"
	@if [ ! -L "$(PKG_DIR)" ]; then ln -sfn "$(ROOT)" "$(PKG_DIR)"; echo "@local/$(PKG_NAME):$(PKG_VER) → $(ROOT)"; fi

## fork — neuen Fach-Fork anlegen:  make fork NAME=zsf-analysis2-fs2026
fork: install
	@test -n "$(NAME)" || { echo "NAME= fehlt, z.B. make fork NAME=zsf-analysis2-fs2026"; exit 1; }
	@typst init @local/$(PKG_NAME):$(PKG_VER) ../$(NAME)
	@cp template/Makefile ../$(NAME)/Makefile
	@echo "Fork in ../$(NAME) — dort: make build"

## fonts — Schriften ins System kopieren, damit der Editor sie kennt
fonts:
	@mkdir -p "$(HOME)/Library/Fonts"
	@cp fonts/* "$(HOME)/Library/Fonts/" && echo "Carlito und NewCM Sans Math installiert"

## check — der ganze Harness
check: build test errors lint knobs coverage identity check-rules
	@$(MAKE) -s catalog-status
	@echo "check: alles grün"

## test — Zusicherungen über die reinen Funktionen
test: install
	@typst compile tests/unit.typ tests/out-unit.pdf $(TYPST_ARGS) && rm -f tests/out-unit.pdf && echo "test: ok"

## errors — falsche Eingaben müssen laut und verständlich scheitern
errors: install
	@bash tests/errors.sh

## lint — verbotene Roh-Befehle in Kapiteln, harte Werte in src/
lint:
	@bash tests/lint.sh

## knobs — jede Stellschraube muss eine messbare Wirkung haben
knobs: install
	@bash tests/knobs.sh

## coverage — jeder öffentliche Name wird vorgeführt und beschrieben
coverage:
	@bash tests/coverage.sh

## identity — PDF-Metadaten nach dem Build
identity: build
	@bash tests/identity.sh $(SHOWCASE) "$(RELEASE_ID)"

## sync-rules — rules/*.md → AGENTS.md
sync-rules:
	@python3 tools/sync_rules.py

## check-rules — Drift zwischen rules/ und AGENTS.md
check-rules:
	@python3 tools/sync_rules.py --check

## thumbnail — Vorschaubild für typst init
thumbnail: install
	@typst compile showcase/main.typ thumbnail.png --pages 1 --ppi 60 $(TYPST_ARGS)

## fmt — Quellen formatieren (typstyle, falls installiert)
fmt:
	@command -v typstyle >/dev/null && typstyle -i lib.typ src/*.typ showcase/*.typ template/**/*.typ tests/*.typ || echo "typstyle nicht installiert — übersprungen"

## clean — erzeugte Dateien entfernen
clean:
	@rm -f $(SHOWCASE) $(CATALOG) thumbnail.png tests/out-unit.pdf
	@rmdir tests/out 2>/dev/null || true

help:
	@grep -E '^## ' $(MAKEFILE_LIST) | sed 's/## /  /'
