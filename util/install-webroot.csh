#!/bin/csh

# The webroot should have the following directories
#
# The data model web-pages: saved/schema/
# The RAP data directory:   saved/rap/
# RDF / other formats under saved/schema/rdf &c., with redirect rules set up.

if ( $1 == "prep" ) then
    mkdir -p /var/www/htdocs/saved/schema/linkml
    cp -v ./src/model/*.yaml /var/www/htdocs/saved/schema/linkml/.
else
    if ( $1 == "web" ) then
	set webroot=/var/www/htdocs
    else
	set webroot=../generated
    endif
    echo "Target directory is $webroot"

    set datamodel=$webroot/saved/
    
    rm -rf $datamodel/*
    cp -rv ./site/* $datamodel/.
endif
