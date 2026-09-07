# =============================================================
# Fach-ZSF — Build
# =============================================================
# Namenskonvention:  <fach>_<semester>_<autor>.pdf

PDF_BASENAME ?= fach_fs2026_hliddal

PKG_DIR    := $(HOME)/Library/Application Support/typst/packages/local/zsf/0.1.0
export TYPST_FONT_PATHS := $(PKG_DIR)/fonts

BUILD_DATE := $(shell date +%Y-%m-%d)
RELEASE_ID ?= DEV-$(BUILD_DATE)
BUILD_ID   := $(shell date -u +%Y%m%dT%H%M%SZ)-$(shell git rev-parse --short HEAD 2>/dev/null || echo nogit)
TYPST_ARGS := --input release=$(RELEASE_ID) --input build=$(BUILD_ID)

MAX_PAGES ?= 4

.PHONY: all build watch pages check-pages fonts clean

all: build

## build — PDF bauen
build:
	@typst compile main.typ $(PDF_BASENAME).pdf $(TYPST_ARGS)
	@echo "$(PDF_BASENAME).pdf"

## watch — live nachbauen, während geschrieben wird
watch:
	@typst watch main.typ $(PDF_BASENAME).pdf $(TYPST_ARGS)

## fonts — Schriften ins System kopieren, damit der Editor sie kennt
fonts:
	@mkdir -p "$(HOME)/Library/Fonts"
	@cp "$(PKG_DIR)"/fonts/* "$(HOME)/Library/Fonts/" && echo "Carlito und NewCM Sans Math installiert"

## pages — Seitenzahl des aktuellen Standes
pages: build
	@pdfinfo $(PDF_BASENAME).pdf 2>/dev/null | awk '/^Pages/ {print "Seiten: " $$2}'

## check-pages — prüft, ob das Seitenbudget eingehalten wird
check-pages: build
	@PAGES=$$(pdfinfo $(PDF_BASENAME).pdf 2>/dev/null | awk '/^Pages:/ {print $$2}'); \
	if [ -z "$$PAGES" ]; then \
	  echo "Hinweis: pdfinfo nicht gefunden, Seitenprüfung übersprungen."; \
	elif [ "$$PAGES" -gt "$(MAX_PAGES)" ]; then \
	  echo "FEHLER: Seitenbudget überschritten ($$PAGES > $(MAX_PAGES) Seiten)!"; exit 1; \
	else \
	  echo "check-pages: ok ($$PAGES / $(MAX_PAGES) Seiten)"; \
	fi

clean:
	@rm -f $(PDF_BASENAME).pdf
