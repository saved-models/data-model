SRC         = src
EXTRA_DIR   = $(SRC)/doc
CONTRIB_DIR = $(SRC)/contrib

SCHEMA_NAME = saved
SCHEMA_DIR  = $(SRC)/model
SCHEMA_ROOT = $(SCHEMA_DIR)/meta.yaml

PROJECT_DIR = project
PROJECT_RDF = $(PROJECT_DIR)/rdf

PYMODEL_DIR = $(PROJECT_DIR)/python

DOC_DIR        = staging
SCHEMA_DOC_DIR = $(DOC_DIR)/schema
EXTRA_DOC_DIR  = $(DOC_DIR)/doc
IMAGES_DOC_DIR = $(DOC_DIR)/images

SITE_DIR        = site
SCHEMA_SITE_DIR = $(SITE_DIR)/schema

DIAGRAMS_DIR = $(SRC)/diagrams

LIBPS  = /opt/local/lib/libgs.dylib
QUARTO = quarto

.PHONY: site python clean

all: site gen-python copy-rdf
site: gen-project gen-doc gen-images build-site copy-most-formats
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

gen-rdf: gen-rdf-ttl gen-rdf-nt

gen-python: $(PYMODEL_DIR)
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

gen-images:
	cd $(DIAGRAMS_DIR) ; \
	env LIBGS=$(LIBPS) latexmk -dvi fisdat rap ; \
	env LIBGS=$(LIBPS) dvisvgm --font-format=woff fisdat.dvi ; \
	env LIBGS=$(LIBPS) dvisvgm --font-format=woff rap.dvi ; \
	cd ../..

clean-images:
	cd $(DIAGRAMS_DIR) ; \
	latexmk -c ; \
	rm -f {fisdat,rap}.{dvi,svg} ; \
	cd ../..

copy-doc: $(GEN_IMAGES) $(EXTRA_DOC_DIR) $(IMAGES_DOC_DIR)
	mkdir -p $(EXTRA_DOC_DIR)/{utils,misc,contrib} ; \
	cp -v $(EXTRA_DIR)/index.md   $(DOC_DIR)/. ; \
	cp -v $(EXTRA_DIR)/utils/*.md $(EXTRA_DOC_DIR)/utils/. ; \
	cp -v $(EXTRA_DIR)/misc/*.md  $(EXTRA_DOC_DIR)/misc/. ; \
	mv -v $(DIAGRAMS_DIR)/*.svg   $(DOC_DIR)/images/.

copy-most-formats: $(SCHEMA_DOC_DIR)
	mkdir -p $(SCHEMA_SITE_DIR)/linkml ; \
	cp -v $(SCHEMA_DIR)/*.yaml $(SCHEMA_SITE_DIR)/linkml/. ; \
	cp -rv $(PROJECT_DIR)/{docs,jsonld,jsonschema,owl} $(SCHEMA_SITE_DIR)/.

copy-rdf: $(SCHEMA_DOC_DIR) gen-rdf copy-most-formats
	cp -rv $(PROJECT_RDF) $(SCHEMA_SITE_DIR)/.

build-site: copy-doc
	cd $(DOC_DIR) ; \
	env LIBGS=$(LIBPS) $(QUARTO) render ; \
	cd .. ; \
	cp -rv src/assets site/. ; \
	cp -v src/plumbing/dot.htaccess site/schema/.htaccess

clean: clean-images
	rm -rf $(PROJECT_DIR)
	rm -rf $(SITE_DIR)
	rm -rf $(SCHEMA_DOC_DIR)
	rm -rf $(EXTRA_DOC_DIR)
	rm -f  $(DOC_DIR)/index.md
	rm -rf $(DOC_DIR)/images
	rm -rf $(DOC_DIR)/.quarto
	rm -f  $(PYMODEL_DIR)
	rm -rf tmp
