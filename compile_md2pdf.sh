#!/bin/bash

if [ -z "$1" ]; then
    echo "Specify an input file."
    exit -1
fi

FILTERS="filters"
TEMPLATE="template"
BADGES="badges"
CSS="https://er.ceres.rub.de/public/journals/2/styleSheet.css"

function build_tex {

    echo "Creating file $2 ... "

    BASEPATH="$(dirname $1)"

    pandoc "$1" \
        --output "$2" \
        --to latex \
        --default-image-extension ".pdf" \
        --pdf-engine xelatex \
        --resource-path "$BASEPATH" \
        --filter "$FILTERS"/licensebadge.py \
        --filter "$FILTERS"/parnums.py \
        --filter "$FILTERS"/tablewidth.py \
        --filter "$FILTERS"/conditionalspans.py \
        --filter pandoc-fignos \
        --filter pandoc-tablenos \
        --filter pandoc-citeproc \
        --csl "$TEMPLATE"/entangled-religions.csl \
        --metadata "reference-section-title=References" \
        --metadata "link-citations" \
        --variable "documentclass=scrartcl" \
        --variable "classoption=a4paper" \
        --variable "classoption=DIV=12" \
        --variable "classoption=footlines=2.1" \
        --variable "classoption=usegeometry=true" \
        --variable "mainfont=Charis SIL" \
        --variable "sansfont=Charis SIL Compact" \
        --variable "linestretch=1.1" \
        --variable "colorlinks" \
        --variable "linkcolor=NavyBlue" \
        --variable "indent" \
        --template "$TEMPLATE"/er_template.tex

    local status=$?
    if [ $status -eq 0 ]; then
        echo "done."
    else
        echo "error!"
        exit $status
    fi

}

function build_html {

    echo "Creating file $2 ... "

    BASEPATH="$(dirname $1)"

    pandoc "$1" \
        --to html5 \
        --standalone \
        --section-divs \
        --default-image-extension ".svg" \
        --resource-path "$BASEPATH" \
        --css "$CSS" \
        --filter "$FILTERS"/licensebadge.py \
        --filter "$FILTERS"/parnums.py \
        --filter "$FILTERS"/tablewidth.py \
        --filter "$FILTERS"/conditionalspans.py \
        --filter pandoc-fignos \
        --filter pandoc-tablenos \
        --filter pandoc-citeproc \
        --csl "$TEMPLATE"/entangled-religions.csl \
        --metadata "reference-section-title=References" \
        --metadata "link-citations" \
        --variable "indent" \
        --variable "img-prefix=https://static.ceres.rub.de/er/images/" \
        --template "$TEMPLATE"/er_template.html \
    | xsltproc --nonet --novalid \
        "$FILTERS"/linktitles.xsl - \
    | xsltproc --nonet --novalid \
        --output "$2" \
        "$FILTERS"/pandoctweaks.xsl -

    local status=$?
    if [ $status -eq 0 ]; then
        echo "done."
    else
        echo "error!"
        exit $status
    fi

}

INFILE="$1"
TEXFILE="${INFILE%.*}.tex"
PDFFILE="${INFILE%.*}.pdf"
HTMLFILE="${INFILE%.*}.html"

build_tex "$INFILE" "$TEXFILE"
build_tex "$INFILE" "$PDFFILE"
build_html "$INFILE" "$HTMLFILE"
