#!/usr/bin/env python3

import sys
import argparse
import logging

import bibtexparser
import langid


langmap = {
    'af': 'afrikaans',
    'am': 'amharic',
    'ar': 'arabic',
    'bg': 'bulgarian',
    'bn': 'bengali',
    'br': 'breton',
    'ca': 'catalan',
    'cy': 'welsh',
    'da': 'danish',
    'de': 'german',
    'el': 'greek',
    'en': 'english',
    'eo': 'esperanto',
    'es': 'spanish',
    'et': 'estonian',
    'eu': 'basque',
    'fa': 'farsi',
    'fi': 'finnish',
    'fr': 'french',
    'ga': 'irish',
    'gl': 'galician',
    'he': 'hebrew',
    'hi': 'hindi',
    'hr': 'croatian',
    'hu': 'magyar',
    'hy': 'armenian',
    'id': 'indonesian',
    'is': 'icelandic',
    'it': 'italian',
    'ja': 'japanese',
    'kn': 'kannada',
    'la': 'latin',
    'lo': 'lao',
    'lt': 'lithuanian',
    'lv': 'latvian',
    'ml': 'malayalam',
    'mn': 'mongolian',
    'mr': 'marathi',
    'nb': 'norsk',
    'nl': 'dutch',
    'nn': 'nynorsk',
    'no': 'norwegian',
    'oc': 'occitan',
    'pl': 'polish',
    'pt': 'portuguese',
    'ro': 'romanian',
    'ru': 'russian',
    'se': 'samin',
    'sk': 'slovak',
    'sl': 'slovenian',
    'sr': 'serbian',
    'sv': 'swedish',
    'ta': 'tamil',
    'te': 'telugu',
    'th': 'thai',
    'tr': 'turkish',
    'uk': 'ukrainian',
    'ur': 'urdu',
    'vi': 'vietnamese',
    'zh': 'chinese',
}


def identify_langs(infile, outfile):
    bib_db = bibtexparser.load(infile)
    for entry in bib_db.entries:
        try:
            lang, conf = langid.classify(entry['title'])
        except KeyError:
            continue
        if lang in langmap:
            entry['langid'] = langmap[lang]
    bibtexparser.dump(bib_db, outfile)


def main():
    # Parse commandline arguments
    arg_parser = argparse.ArgumentParser()
    arg_parser.add_argument('-v', '--verbose', action='store_true')
    arg_parser.add_argument('-o', '--outfile', default=sys.stdout,
                            type=argparse.FileType('w'))
    arg_parser.add_argument('bibfile', type=argparse.FileType())
    args = arg_parser.parse_args()
    # Set up logging
    if args.verbose:
        level = logging.DEBUG
    else:
        level = logging.ERROR
    logging.basicConfig(level=level)
    # annotate bibliography
    identify_langs(args.bibfile, args.outfile)
    # Return exit value
    return 0


if __name__ == '__main__':
    sys.exit(main())
