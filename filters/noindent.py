#!/usr/bin/env python3

"""
A pandoc filter that places a \\noindent before every paragraph (this might be useful in case there are many short paragraphs and you don't want to use a list)
"""

from panflute import *

def latex(s):
    return RawInline(s, format='latex')

def no_indent_paras(elem, doc):
    if isinstance(elem, Para):
        if isinstance(elem.parent, Div) and 'noindent' in elem.parent.classes:
            if doc.format == "latex":
                return Para(latex(r"\noindent"), Space, *elem.content)

def main(doc=None):
    return run_filter(no_indent_paras, doc=doc)

if __name__ == "__main__":
    main()
