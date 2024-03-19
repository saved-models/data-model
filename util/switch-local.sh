#!/bin/sh

# Simple script to change the saved: schemata to either local or remote path
if [ $# -ne 1 ]; then
    echo "usage: switch-local.sh [--to-local|--to-web]"
elif [ $1 = "--to-local" ]; then
    echo \`"saved:core -> ./core' &c"
    sed -i .bak 's/- saved:\([a-z]*\)/- .\/\1/g'  src/model/*.yaml
elif [ $1 = "--to-web" ]; then
    echo \`"./core -> saved:core' &c"
    sed -i .bak 's/\.\/\([a-z]*\)/saved:\1/g' src/model/*.yaml
else
    echo "usage: switch-local.csh [--to-local|--to-web]"
fi

