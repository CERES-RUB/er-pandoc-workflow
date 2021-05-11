#!/usr/bin/env python3

"""
Enable hanging indents for custom divs.

This filter looks for divs with the class `references`
which are not the main bibliography (with ID `refs`).
"""

from panflute import *


def hangbib(elem, doc):
    if (isinstance(elem, Div)
        and 'references' in elem.classes
        and not elem.identifier == 'refs'):
        if doc.format == 'latex':
            return [RawBlock(r'\begin{cslreferences}', format='latex'),
                    elem,
                    RawBlock(r'\end{cslreferences}', format='latex'),
                    ]
        if doc.format == 'html':
            elem.classes.append('hanging-indent')
            return elem


def main(doc=None):
    return run_filter(hangbib, doc=doc)


if __name__ == '__main__':
    main()
