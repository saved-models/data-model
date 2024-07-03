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

    cp -rv ./site/* $DATAMODEL/.      # Built HTML
fi
