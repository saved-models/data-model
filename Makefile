SRC         = src
CONTRIB_DIR = $(SRC)/contrib

SCHEMA_NAME = saved
SCHEMA_DIR  = $(SRC)/model
SCHEMA_ROOT = $(SCHEMA_DIR)/meta.yaml

PROJECT_DIR = project

PYMODEL     = $(SCHEMA_DIR)/datamodel
DOC_DIR     = docs
SITE_DIR    = site

.PHONY: all clean

all: gen-project gen-doc build-html
%.yaml: gen-project

$(PYMODEL):
	mkdir -p $@

$(DOC_DIR):
	mkdir -p $@

$(PROJECT_DIR):
	mkdir -p $@

help:
	@echo "make all    | build markdown documentation and HTML site"
	@echo "make clean  | clean up"
	@echo "make help   | show this help message"

copy-contrib:
	cp $(SRC)/*.md $(DOC_DIR)

gen-project: $(PROJECT_DIR)
	gen-project -d $(PROJECT_DIR) $(SCHEMA_ROOT) && \
	mv $(PROJECT_DIR)/*.py $(PYMODEL)

MKDOCS = mkdocs

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
