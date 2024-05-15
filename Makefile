SRC         = src
CONTRIB_DIR = $(SRC)/contrib

SCHEMA_NAME = saved
SCHEMA_DIR  = $(SRC)/model
SCHEMA_ROOT = $(SCHEMA_DIR)/meta.yaml

PROJECT_DIR = project
PROJECT_RDF = $(PROJECT_DIR)/rdf

PYMODEL_DIR = $(PROJECT_DIR)/python

DOC_DIR     = docs
SITE_DIR    = site

MKDOCS      = mkdocs

.PHONY: site python clean

all: site python
site: gen-project gen-doc build-html
%.yaml: gen-project

$(PYMODEL_DIR):
	mkdir -p $@

$(DOC_DIR):
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

copy-contrib:
	cp $(SRC)/*.md $(DOC_DIR)

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

gen-doc: $(DOC_DIR)
	cp $(PROJECT_DIR)/docs/*.md $(DOC_DIR) ; \
	gen-doc -d $(DOC_DIR) $(SCHEMA_ROOT)

build-html:
	mkdocs build

clean:
	rm -rf $(PROJECT_DIR)
	rm -rf $(DOC_DIR)
	rm -rf $(SITE_DIR)
	rm -f  $(PYMODEL)
	rm -rf tmp
