#!/usr/bin/python3

"""
A pandoc filter that formats tables as LaTeX floats.

Based on <https://gist.github.com/rriemann/56017da044861f7dd459dc5ab2f25cb9>,
ported to panflute.

"""
import logging
logging.basicConfig(level=logging.WARNING)

from panflute import *

from tabletools import *

def inlatex(s):
    return RawInline(s, format='latex')

def latex(s):
    return RawBlock(s, format='latex')

def get_inline_content(block):
    if not block.content:
        return []
    if len(block.content) > 1:
        logging.warning('Table cell contains more than one child element.')
    content_block = block.content[0]
    if not isinstance(content_block, Plain):
        logging.error(f'Table cell contains complex content of type {type(content_block)}.')
        return []
    return content_block.content

def tbl_caption(s):
    # check if there is no header
    if len(s) == 0:
        return Para()

    return Para(*[inlatex(r'\caption{')] + s + [inlatex('}')])

def tbl_alignment(alignment):
    aligns = {
        "AlignDefault": 'l',
        "AlignLeft": 'l',
        "AlignCenter": 'c',
        "AlignRight": 'r',
    }
    align = ['@{}']
    for a in alignment:
        align.append(aligns[a])
    align.append('@{}')
    return ''.join(align)

def tbl_headers(header, delimiter):
    result = []
    for cell in header.content:
        result.extend(get_inline_content(cell))
        result.append(inlatex(r' & '))
    result[-1] = inlatex(delimiter + '\n' + r'\midrule')
    return Plain(*result)

def tbl_contents(content, delimiter):
    result = []
    for row in content:
        para = []
        for cell in row.content:
            para.extend(get_inline_content(cell))
            para.append(inlatex(' & '))
        result.extend(para)
        result[-1] = inlatex(delimiter + '\n')
    return Plain(*result)

def action(elem, doc):
    if isinstance(elem, Table):
        # Only process if 'float' class is set.
        if not elem.caption:
            return None
        actual_caption, attr = extract_attributes(elem.caption)
        if not 'float' in attr.classes:
            return None
        table = []
        table.append(latex(r'\begin{table*}' '\n' r'\centering' '\n'))
        table.append(latex(r'\begin{tabular}{'
                     + tbl_alignment(elem.alignment)
                     + ('}' '\n' r'\toprule')))
        delimiter = r'\\'
        # check if there is no header
        if elem.header:
            table.append(tbl_headers(elem.header, delimiter))
        table.append(tbl_contents(elem.content, delimiter))
        table.append(latex(r'\bottomrule' '\n'))
        table.append(latex(r'\end{tabular}' '\n'))
        table.append(tbl_caption(actual_caption))
        table.append(latex(r'\end{table*}'))

        return table

def main(doc=None):
    return run_filter(action,
                      doc=doc)

if __name__ == '__main__':
    main()
