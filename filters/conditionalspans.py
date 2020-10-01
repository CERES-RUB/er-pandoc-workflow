#!/usr/bin/env python3

"""
Wrap bibliography in `hangparas` environment.
"""

from panflute import *

def conditionalspans(elem, doc):
    if isinstance(elem, Span) and ('only' in elem.attributes
                                   or 'not' in elem.attributes):
        if 'only' in elem.attributes and elem.attributes['only'] != doc.format:
            return []
        if 'not' in elem.attributes and elem.attributes['not'] == doc.format:
            return []
        # Otherwise, return content
        return list(elem.content)

def main(doc=None):
    return run_filter(conditionalspans, doc=doc) 

if __name__ == '__main__':
    main()
