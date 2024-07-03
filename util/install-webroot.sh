#!/bin/sh

if [ $1 == "prep" ]; then
    mkdir -p /var/www/htdocs/saved/schema/linkml
    cp -v ./src/model/*.yaml /var/www/htdocs/saved/schema/linkml/.
else
    if [ $1 == "web" ]; then
	WEBROOT=/var/www/htdocs
    else
	WEBROOT=../generated
    fi
    echo "Target directory is $WEBROOT"

    DATAMODEL=$WEBROOT/saved

    rm -rf $DATAMODEL/*
    mkdir -p $DATAMODEL/schema/linkml

    cp -rv ./site/* $DATAMODEL/.      # Built HTML
    cp -v ./src/model/*.yaml $DATAMODEL/schema/linkml/.
    cp -rv ./project/{docs,jsonld,jsonschema,owl} $DATAMODEL/schema/.
    
    if [ -d ./project/rdf ]; then
	cp -rv ./project/rdf $DATAMODEL/schema/.
    fi
fi
