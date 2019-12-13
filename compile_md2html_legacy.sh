#!/bin/bash

if [ -z "$1" ]; then
    echo "Specify an input file."
    exit -1
fi

FILTERS="filters"
TEMPLATE="template"
BADGES="badges"
CSS="https://er.ceres.rub.de/public/journals/2/styleSheet.css"

function build_html {

    echo "Creating file $2 ... "

    BASEPATH="$(dirname $1)"

    pandoc "$1" \
        --output "$2" \
        --to html5 \
        --standalone \
        --section-divs \
        --default-image-extension ".svg" \
        --resource-path "$BASEPATH" \
        --css "$CSS" \
        --filter "$FILTERS"/licensebadge.py \
        --filter "$FILTERS"/tablewidth.py \
        --filter "$FILTERS"/conditionalspans.py \
        --filter pandoc-fignos \
        --filter pandoc-tablenos \
        --filter pandoc-citeproc \
        --variable "indent" \
        --variable "img-prefix=https://static.ceres.rub.de/er/images/" \
        --template "$TEMPLATE"/er_template.html

    local status=$?
    if [ $status -eq 0 ]; then
        echo "done."
    else
        echo "error!"
        exit $status
    fi

}

INFILE="$1"
HTMLFILE="${INFILE%.*}.html"

build_html "$INFILE" "$HTMLFILE"
