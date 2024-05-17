#!/bin/sh

if [ $1 == "prep" ]; then
    cp -v ./src/model/*.yaml /var/www/htdocs/saved/schema/linkml/.
else
    if [ $1 == "web" ]; then
	WEBROOT=/var/www/htdocs
    else
	WEBROOT=../generated
    fi
    echo "Target directory is $WEBROOT"

    DATAMODEL=$DATAMODEL/saved/schema

    rm -rf $DATAMODEL/*
    mkdir -p $DATAMODEL/schema

    cp -rv ./site/* $DATAMODEL/.      # Built HTML
    cp -v ./src/model/*.yaml $DATAMODEL/schema/.
    cp -rv ./project/{docs,jsonld,jsonschema,owl} $DATAMODEL/.
    
    if [ -d ./project/rdf ]; then
	cp -rv ./project/rdf $DATAMODEL/.
    fi
fi
