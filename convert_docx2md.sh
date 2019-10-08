#!/bin/bash

INFILE="$1"
OUTFILE="${INFILE%.*}.md"

if [ -f "$OUTFILE" ]; then
    echo "Output file $OUTFILE already exists, doing nothing."
    echo "If you want to convert the file again, delete the output file first."
    exit -1
fi

echo "Creating file $OUTFILE ... "

pandoc "$INFILE" \
    --output "$OUTFILE" \
    --to markdown-smart \
    --wrap none \
    --atx-headers \
    --reference-location block

status=$?
if [ $status -eq 0 ]; then
    echo "done."
else
    echo "error!"
    exit $status
fi
