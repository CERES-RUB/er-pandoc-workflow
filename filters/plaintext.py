#!/usr/bin/python3

"""
Pandoc’s plain text output still contains some formatting. Remove inline formatting.
"""

from panflute import *

def plaintext(elem, doc):
    if isinstance(elem, (Emph, Strong)):
        return list(elem.content)

def main(doc=None):
    return run_filter(plaintext, doc=doc)

if __name__ == '__main__':
    main()
