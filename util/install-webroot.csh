#!/bin/csh

if ( $1 == "web") then
    set webroot=/var/www/htdocs
else
    set webroot=../generated
endif
echo "Target directory is $webroot"

set datamodel=$webroot/saved

rm -rf $datamodel/*
mkdir -p $datamodel/schema

cp -rv ./site/* $datamodel/.
cp -v ./src/model/*.yaml $datamodel/schema/.
cp -rv ./project/{docs,jsonld,jsonschema,owl} $datamodel/.

if ( -d ./project/rdf ) then
    cp -rv ./project/rdf $datamodel/.
endif
