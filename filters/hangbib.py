#!/usr/bin/python3

"""
Wrap bibliography in `hangparas` environment.
"""

from panflute import *

def hangbib(elem, doc):
    if isinstance(elem, Div) and elem.identifier == 'refs':
        if doc.format == 'latex':
            return [RawBlock(r'\begin{hangparas}{\leftmargin}{1}', format='latex'),
                    elem,
                    RawBlock(r'\end{hangparas}', format='latex'),
                   ]

def main(doc=None):
    return run_filter(hangbib, doc=doc) 

if __name__ == '__main__':
    main()
