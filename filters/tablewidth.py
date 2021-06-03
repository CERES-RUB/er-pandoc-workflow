#!/usr/bin/env python3

"""
A pandoc filter that allows to explicitly set the column widths for tables.

Column width can get passed to the table as an attribute in its caption:

    Table: This is the caption {#tbl:tab1 colwidth=".2 .2 .6"}

"""

from panflute import *


def update_width(elem, doc):
    if isinstance(elem, Table):
        if 'colwidth' in elem.attributes:
            # get new width values from `colwidth` attribute
            widths = [float(w) for w in elem.attributes['colwidth'].split()]
            # colspec is a list of (align, width) pairs.
            # Generate the new colspec by replacing the width values.
            colspec = [(align, newwidth)
                       for (align, oldwidth), newwidth
                       in zip(elem.colspec, widths)]
            elem.colspec = colspec
            # Remove colwidth attribute, since it’s now obsolete
            del elem.attributes['colwidth']


def main(doc=None):
    return run_filter(update_width, doc=doc)


if __name__ == '__main__':
    main()
