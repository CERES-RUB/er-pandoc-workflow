#!/bin/bash

if [ -z "$1" ]; then
    echo "Specify an input file."
    exit 1
fi

DIR="$(dirname "$0")"
cd "$DIR" || exit

function build_tex {

    echo "Creating file $3 ... "

    BASEPATH="$(dirname "$2")"

    pandoc "$2" \
        --output "$3" \
        --defaults "defaults/${JOURNAL}_latex.yaml" \
        --resource-path ".:$BASEPATH" \
    && echo "done." \
    || echo "error!"

}

function build_html {

    echo "Creating file $3 ... "

    BASEPATH="$(dirname "$2")"

    pandoc "$2" \
        --defaults "defaults/${JOURNAL}_html.yaml" \
        --resource-path ".:$BASEPATH" \
    | xsltproc --nonet --novalid \
        filters/linktitles.xsl - \
    | xsltproc --nonet --novalid \
        --output "$3" \
        filters/pandoctweaks.xsl - \
    && echo "done." \
    || echo "error!"

}

JOURNAL="$1"
case $JOURNAL in
    er|mp) ;;
    *) echo "First argument needs to be the journal, 'er' or 'mp'."; exit 1 ;;
esac

INFILE="$2"
TEXFILE="${INFILE%.*}.tex"
PDFFILE="${INFILE%.*}.pdf"
HTMLFILE="${INFILE%.*}.html"

build_tex "$JOURNAL" "$INFILE" "$TEXFILE"
build_tex "$JOURNAL" "$INFILE" "$PDFFILE"
build_html "$JOURNAL" "$INFILE" "$HTMLFILE"
