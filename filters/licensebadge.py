#!/usr/bin/env python3

"""
A pandoc filter that enumerates paragraphs

"""

from panflute import *

LICENSES = {
    'http://creativecommons.org/licenses/by/4.0/': {
        'badge': 'cc-by',
        'label': 'Creative Commons Attribution 4.0',
    },
    'http://creativecommons.org/licenses/by-sa/4.0/': {
        'badge': 'cc-by-sa',
        'label': 'Creative Commons Attribution-ShareAlike 4.0',
    },
}

EXT = {
    None: '.svg',
    'latex': '.pdf',
}

def prepare(doc):
    if 'license' in doc.metadata:
        license = stringify(doc.metadata['license'])
        if license in LICENSES:
            if doc.format in EXT:
                ext = EXT[doc.format]
            else:
                ext = EXT[None]
            doc.metadata['license-badge'] = LICENSES[license]['badge'] + ext
            doc.metadata['license-label'] = LICENSES[license]['label']

def action(elem, doc):
    pass

def main(doc=None):
    return run_filter(action,
                      prepare=prepare,
                      doc=doc)

if __name__ == '__main__':
    main()
