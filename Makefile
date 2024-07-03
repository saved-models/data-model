SRC         = src
EXTRA_DIR   = $(SRC)/doc
CONTRIB_DIR = $(SRC)/contrib

SCHEMA_NAME = saved
SCHEMA_DIR  = $(SRC)/model
SCHEMA_ROOT = $(SCHEMA_DIR)/meta.yaml

PROJECT_DIR = project
PROJECT_RDF = $(PROJECT_DIR)/rdf

PYMODEL_DIR = $(PROJECT_DIR)/python

DOC_DIR        = saved
SCHEMA_DOC_DIR = $(DOC_DIR)/schema
EXTRA_DOC_DIR  = $(DOC_DIR)/doc
IMAGES_DOC_DIR = $(DOC_DIR)/images
SITE_DIR       = site

DIAGRAMS_DIR = $(SRC)/diagrams

LIBPS  = /opt/local/lib/libgs.dylib
QUARTO = quarto

.PHONY: site python clean

all: site rdf python
site: gen-project gen-doc gen-images build-html
%.yaml: gen-project

$(PYMODEL_DIR):
	mkdir -p $@

$(SCHEMA_DOC_DIR):
	mkdir -p $@

$(EXTRA_DOC_DIR):
	mkdir -p $@

$(IMAGES_DOC_DIR):
	mkdir -p $@

$(PROJECT_DIR):
	mkdir -p $@

$(PROJECT_RDF):
	mkdir -p $@

$(DIAGRAMS_DIR):
	mkdir -p $@

help:
	@echo "make site  | build markdown documentation and HTML site"
	@echo "make rdf   | additionally generate RDF (turtle and n-triples)"
	@echo "make clean | clean up"
	@echo "make help  | show this help message"

gen-project: $(PROJECT_DIR)
	gen-project -d $(PROJECT_DIR) --config-file gen_project_config.yaml $(SCHEMA_ROOT)

gen-rdf-nt: $(PROJECT_RDF) gen-project
	gen-rdf -v --stacktrace -f nt -o $(PROJECT_RDF)/saved.nt $(SCHEMA_ROOT)

gen-rdf-ttl: $(PROJECT_RDF) gen-project
	gen-rdf -v --stacktrace -f ttl -o $(PROJECT_RDF)/saved.ttl $(SCHEMA_ROOT)

rdf: gen-rdf-ttl gen-rdf-nt

python: $(PYMODEL_DIR)
	gen-python --mergeimports $(SCHEMA_ROOT) > $(PYMODEL_DIR)/meta.py

#python: $(PYMODEL_DIR)
#	@for file in $(wildcard $(SCHEMA_DIR)/*.yaml); do \
#		base=$$(basename $$file); \
#		filename_without_suffix=$${base%.*}; \
#		$(RUN) gen-python --genmeta $$file > $(PYMODEL_DIR)/$$filename_without_suffix.py; \
#	done

gen-doc: $(SCHEMA_DOC_DIR)
	cp $(PROJECT_DIR)/docs/*.md  $(SCHEMA_DOC_DIR) ; \
	gen-doc -d $(SCHEMA_DOC_DIR) $(SCHEMA_ROOT)

gen-images: $(DIAGRAMS_DIR)
	cd $(DIAGRAMS_DIR) ; \
	env LIBGS=$(LIBPS) latexmk -dvi fisdat rap ; \
	env LIBGS=$(LIBPS) dvisvgm --font-format=woff fisdat.dvi ; \
	env LIBGS=$(LIBPS) dvisvgm --font-format=woff rap.dvi ; \
	cd ../..

copy-doc-extra: $(GEN_IMAGES) $(EXTRA_DOC_DIR) $(IMAGES_DOC_DIR)
	cp -v  $(EXTRA_DIR)/index.qmd    $(DOC_DIR)
	cp -rv $(EXTRA_DIR)/{utils,misc} $(EXTRA_DOC_DIR)
	cp -v $(DIAGRAMS_DIR)/{fisdat.svg,rap.svg} $(DOC_DIR)/images/
#	cp $(CONTRIB_DIR)/*.md $(DOC_DIR)

build-html: copy-doc-extra
	cd $(DOC_DIR) ; \
	env LIBGS=$(LIBPS) $(QUARTO) render ; \
	cd ..

clean:
	rm -rf $(PROJECT_DIR)
	rm -rf $(SITE_DIR)
	rm -rf $(SCHEMA_DOC_DIR)
	rm -rf $(EXTRA_DOC_DIR)
	rm -f  $(DOC_DIR)/index.qmd
	rm -rf $(DOC_DIR)/images
	rm -rf $(DOC_DIR)/.quarto
	rm -f  $(PYMODEL_DIR)
	rm -rf tmp
