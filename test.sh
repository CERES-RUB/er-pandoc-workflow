#!/bin/bash

TESTDIR="$(pwd)/$(dirname "$0")/test"
TAG="edge"
ARTICLE="test_article_simple"

FAILED=0

echo 'Test import:'

docker run --rm \
           --volume $TESTDIR/import:/work \
           --user `id -u`:`id -g` \
           registry.git.noc.ruhr-uni-bochum.de/entangled-religions/pandoc-workflow/import:"$TAG" \
           /work/test_article.docx

echo -n 'Test markdown ... '

diff_md=$(diff -u "$TESTDIR/import/expected/test_article.md" "$TESTDIR/import/test_article.md")

if [ -z "$diff_md" -a $? -eq 0 ]; then
    echo '✅ success'
    rm "$TESTDIR/import/test_article.md"
else
    echo '❌ failed.'
    ((FAILED++))
    echo "$diff_md"
fi

echo -n 'Test BibTeX ... '

diff_bib=$(diff -u "$TESTDIR/import/expected/test_article.bib" "$TESTDIR/import/test_article.bib")

if [ -z "$diff_bib" -a $? -eq 0 ]; then
    echo '✅ success'
    rm "$TESTDIR/import/test_article.bib"
else
    echo '❌ failed.'
    ((FAILED++))
    echo "$diff_bib"
fi

echo ''
echo 'Test export:'

docker run --rm \
           --volume $TESTDIR/export:/work \
           --user `id -u`:`id -g` \
           registry.git.noc.ruhr-uni-bochum.de/entangled-religions/pandoc-workflow/export:"$TAG" \
           "/work/$ARTICLE.md"

echo -n 'Test LaTeX ... '

diff_tex=$(diff -u "$TESTDIR/export/expected/$ARTICLE.tex" "$TESTDIR/export/$ARTICLE.tex")

if [ -z "$diff_tex" -a $? -eq 0 ]; then
    echo '✅ success'
    rm "$TESTDIR/export/$ARTICLE.tex"
else
    echo '❌ failed.'
    ((FAILED++))
    #echo "$diff_tex"
fi

echo -n 'Test PDF ... '

PDF_DIFFS=0
rm "$TESTDIR/export/$ARTICLE_img"*_diff.png
pdftoppm -png "$TESTDIR/export/$ARTICLE.pdf" "$TESTDIR/export/${ARTICLE}_img"
for img in "$TESTDIR/export/${ARTICLE}_img"*.png; do
    gm compare "$TESTDIR/export/expected/$(basename "$img")" "$img" "$img"_diff.png \
    && if [ -f "$img"_diff.png ]; then rm "$img"_diff.png; fi \
    || ((PDF_DIFFS++))
done
if [ $PDF_DIFFS -eq 0 ]; then
    echo '✅ success'
    rm "$TESTDIR/export/$ARTICLE.tex"
else
    echo "❌ failed, $PDF_DIFFS pages are different."
    ((FAILED++))
fi

echo -n 'Test HTML ... '

diff_html=$(diff -u "$TESTDIR/export/expected/$ARTICLE.html" "$TESTDIR/export/$ARTICLE.html")

if [ -z "$diff_html" -a $? -eq 0 ]; then
    echo '✅ success'
    rm "$TESTDIR/export/$ARTICLE.html"
else
    echo '❌ failed.'
    ((FAILED++))
    #echo "$diff_html"
fi


echo ''
if [ $FAILED -eq 0 ]; then
    echo '✅ All tests passed.'
else
    echo "❌ $FAILED tests failed."
fi
