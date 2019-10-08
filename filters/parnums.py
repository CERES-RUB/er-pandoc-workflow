#!/usr/bin/python3

"""
A pandoc filter that enumerates paragraphs

"""

import sys
import re
import itertools

from panflute import *

def latex(s):
    return RawInline(s, format='latex')

def ancestorisinstance(elem, cls):
    while elem.parent:
        elem = elem.parent
        if isinstance(elem, cls):
            return True
    return False

def prepare(doc):
    doc.parnum = 0

def finalize(doc):
    del doc.parnum

def test_para(elem):
    # Only paragraphs
    if not isinstance(elem, Para):
        return False
    # but not inside tables, footnotes or metadata
    if ancestorisinstance(elem, (Table, Note, MetaBlocks)):
        return False
    # not within .noparnums class
    if isinstance(elem.parent, Div) and 'noparnums' in elem.parent.classes:
        return False
    # and no figures
    if len(elem.content) == 1 and isinstance(elem.content[0], Image):
        return False
    return True

def test_list(elem):
    # only compact lists:
    if not isinstance(elem, (BulletList, OrderedList)):
        return False
    has_complex_content = False
    for child in elem.content:
        if isinstance(child, ListItem):
            if not isinstance(child.content[0], Plain):
                has_complex_content = True
                break
    return not has_complex_content

def enumerate_paragraphs(elem, doc):
    parnum = None
    if test_para(elem) or test_list(elem):
        doc.parnum += 1
        parnum = Str(f'[{doc.parnum}]')
        pre_content = None
        if doc.format in ('html', 'html4', 'html5'):
            link = Link(Str(f'{doc.parnum}'), url=f'#p{doc.parnum}')
            anchor = Link(identifier=f'p{doc.parnum}', classes=['parid'])
            pre_content = Div(Para(link), classes=['parnum'])
            extra_content = [anchor]
        elif doc.format == 'latex':
            extra_content = [latex(r'\leavevmode\marginpar{\textcolor{parnum}{'),
                             parnum,
                             latex(r'}}')]
        else:
            extra_content = [parnum]
        if isinstance(elem, (BulletList, OrderedList)):
            parnum_container = elem.content[0].content[0]
        else:
            parnum_container = elem
        new_content = itertools.chain(extra_content, parnum_container.content)
        parnum_container.content = new_content
        if pre_content:
            return [pre_content, elem]

def main(doc=None):
    return run_filter(enumerate_paragraphs,
                      prepare=prepare,
                      finalize=finalize,
                      doc=doc)

if __name__ == '__main__':
    main()
