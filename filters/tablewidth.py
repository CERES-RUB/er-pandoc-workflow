#!/usr/bin/python3

"""
A pandoc filter that allows to explicitly set the column widths for tables.

Column width can get passed to the table as an attribute in its caption:

    Table: This is the caption {#tbl:tab1 colwidth=".2 .2 .6"}

"""

import re
from collections import namedtuple

from panflute import *

from tabletools import *

def update_width(elem, doc):
    if isinstance(elem, Table):
        # Split the caption into the actual content and attributes
        actual_content, attr = extract_attributes(elem.caption)
        if 'colwidth' in attr.attributes:
            width = [float(w) for w in attr.attributes['colwidth'].split()]
            elem.width = width
            # Remove colwidth attribute, since it’s now obsolete
            del attr.attributes['colwidth']

        if attr.identifier or attr.classes or attr.attributes:
            # Re-add remaining attributes
            actual_content.append(Space)
            actual_content.append(Str(serialize_attributes(attr)))

        elem.caption = actual_content

def main(doc=None):
    return run_filter(update_width, doc=doc) 

if __name__ == '__main__':
    main()
