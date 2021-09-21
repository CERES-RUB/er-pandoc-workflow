#!/bin/bash

if [ -z "$1" ]; then
    echo "Specify an input file."
    exit -1
fi

DIR=$(dirname $0)
cd $DIR

function build_tex {

    echo "Creating file $2 ... "

    BASEPATH="$(dirname $1)"

    pandoc "$1" \
        --output "$2" \
        --defaults "defaults/common.yaml" \
        --defaults "defaults/latex.yaml" \
        --resource-path ".:$BASEPATH" \
        --filter "filters/noindent.py" \
    && echo "done." \
    || echo "error!"

}

function build_html {

    echo "Creating file $2 ... "

    BASEPATH="$(dirname $1)"

    pandoc "$1" \
        --defaults "defaults/common.yaml" \
        --defaults "defaults/html.yaml" \
        --resource-path ".:$BASEPATH" \
    | xsltproc --nonet --novalid \
        filters/linktitles.xsl - \
    | xsltproc --nonet --novalid \
        --output "$2" \
        filters/pandoctweaks.xsl - \
    && echo "done." \
    || echo "error!"

}

INFILE="$1"
TEXFILE="${INFILE%.*}.tex"
PDFFILE="${INFILE%.*}.pdf"
HTMLFILE="${INFILE%.*}.html"

build_tex "$INFILE" "$TEXFILE"
build_tex "$INFILE" "$PDFFILE"
build_html "$INFILE" "$HTMLFILE"
