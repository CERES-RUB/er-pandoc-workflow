#!/usr/bin/env python3

import re
from collections import namedtuple

from panflute import *


__all__ = ['Attrs', 'parse_attributes', 'serialize_attributes',
           'extract_attributes']

Attrs = namedtuple('Attrs', ['identifier', 'classes', 'attributes'])

def parse_attributes(attr_str):
    """
    Gets an attribute string and returns an Attrs instance:

    >>> parse_attributes('{#tbl:test .class1 .class2 colwidth=".2 .2 .6"}')
    Attrs(identifier='tbl:test', classes=['class1', 'class2'],
          attributes={'colwidth': '.2 .2 .6'})

    """
    # Remove brackets
    attr_str = attr_str.lstrip('{')
    attr_str = attr_str.rstrip('}')
    # First, look for key=value attributes. Since they might contain
    # characters like . and # we strip them before parsing ids and classes.
    attr_re = r'(\w+)="(.*?)"'
    attributes = re.findall(attr_re, attr_str)
    attributes = dict(attributes)
    attr_str = re.sub(attr_re, '', attr_str)

    # Look for ID and classes
    identifier = re.search(r'(^|\s)#(?P<id>\S+)', attr_str)
    if identifier:
        identifier = identifier.group('id')

    classes = [m.group('class') for m in
               re.finditer(r'(^|\s)\.(?P<class>\S+)', attr_str)]

    return Attrs(identifier, classes, attributes)

def serialize_attributes(attr):
    """
    Takes an Attrs object and returns a pandoc attribute string.

    """
    parts = []
    if attr.identifier:
        parts.append(f'#{attr.identifier}')
    parts.extend([f'.{c}' for c in attr.classes])
    parts.extend([f'{k}="{v}"' for k, v in attr.attributes.items()])
    return '{' + ' '.join(parts) + '}'

def extract_attributes(caption):
    """
    Takes a table caption and returns a (content, attr) tuple.

    """
    actual_content = []
    attributes_str = ''
    isattr = False
    for token in caption:
        if isinstance(token, Str) and token.text.startswith('{'):
            isattr = True
        if isattr:
            if isinstance(token, Quoted):
                attributes_str += '"' + stringify(token) + '"'
            else:
                attributes_str += stringify(token)
        else:
            actual_content.append(token)
        if isinstance(token, Str) and token.text.endswith('}'):
            isattr = False

    # Parse attributes
    attr = parse_attributes(attributes_str)
    if actual_content and isinstance(actual_content[-1], Space):
        actual_content.pop()
    return (actual_content, attr)
