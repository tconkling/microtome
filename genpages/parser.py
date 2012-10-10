#!/usr/bin/env python

from stringscanner import StringScanner
from spec import *

import re
import util

WORD = re.compile(r'[a-zA-Z_]\w*')
ATTR_VALUE = re.compile(r'[\w\"]+')
CURLY_OPEN = re.compile(r'\{')
CURLY_CLOSE = re.compile(r'\}')
PAREN_OPEN = re.compile(r'\(')
PAREN_CLOSE = re.compile(r'\)')
ANGLE_OPEN = re.compile(r'<')
ANGLE_CLOSE = re.compile(r'>')
SEMICOLON = re.compile(r';')
EQUALS = re.compile(r'=')
COMMA = re.compile(r',')

WHITESPACE = re.compile(r'\s+')

def debug_print (str):
    pass #print(str)


class ParseError(Exception):
    '''Problem that occurred during parsing'''
    def __init__ (self, string, pos, msg):
        line_data = util.line_data_at_index(string, pos)

        self.line_number = [line_data.line_num]
        self.line = (string.splitlines()[line_data.line_num])[line_data.col:]
        self.message = msg

        self.args = (self.message, self.line_number, self.line)

class Parser:
    def parse (self, string):
        '''parses a page from a string'''
        self._scanner = StringScanner(string)
        # parse
        page = self.parse_page()
        # check semantics
        self.validate_page(page)
        return page

    @property
    def string (self): return self._scanner.string

    @property
    def pos (self): return  self._scanner.pos

    def validate_page (self, page):
        # check for duplicate property names
        prop_names = set()
        for prop in page.props:
            if prop.name in prop_names:
                raise ParseError(self.string, prop.pos, "Duplicate property name: '" + prop.name + "'")
            prop_names.add(prop.name)


    def parse_page (self):
        # name
        self.eat_whitespace()
        page_pos = self._scanner.pos;
        page_name = self.require_text(WORD, "Expected page name")
        debug_print("found page_name: " + page_name)

        # superclass
        self.eat_whitespace()
        page_superclass = None
        if self.get_text("extends") is not None:
            self.eat_whitespace()
            page_superclass = self.require_text(WORD, "Expected superclass name")
            debug_print("found superclass: " + page_superclass)

        # open-curly
        self.eat_whitespace()
        self.require_text(CURLY_OPEN)

        page_props = self.parse_props()

        # close-curly
        self.eat_whitespace()
        self.require_text(CURLY_CLOSE)

        return Page(name = page_name, superclass = page_superclass, props = page_props, pos = page_pos)

    def parse_props (self):
        props = []
        while True:
            prop = self.parse_prop()
            if not prop:
                break;
            props.append(prop)
        return props

    def parse_prop (self):
        # type
        self.eat_whitespace()
        prop_pos = self._scanner.pos
        prop_type = self.get_text(WORD)
        if not prop_type:
            return None
        debug_print("found prop_type: " + prop_type)

        # subtype
        subtype = None
        self.eat_whitespace()
        if self.get_text(ANGLE_OPEN):
            self.eat_whitespace()
            subtype = self.require_text(WORD, "Expected subtype")
            self.eat_whitespace()
            self.require_text(ANGLE_CLOSE, "Expected '>'")
            debug_print("found subtype: " + subtype)

        # name
        self.eat_whitespace()
        prop_name = self.require_text(WORD, "Expected prop name")
        debug_print("found prop_name: " + prop_name)

        # attrs
        attrs = None
        self.eat_whitespace()
        if self.get_text(PAREN_OPEN):
            attrs = self.parse_attrs()
            self.eat_whitespace()
            self.require_text(PAREN_CLOSE)

        self.require_text(SEMICOLON, "expected semicolon");

        return Prop(type = prop_type, subtype = subtype, name = prop_name, attrs = attrs, pos = prop_pos)

    def parse_attrs (self):
        attrs = []
        while True:
            attrs.append(self.parse_attr())
            self.eat_whitespace()
            if not self.get_text(COMMA):
                break;
        return attrs

    def parse_attr (self):
        # name
        self.eat_whitespace()
        attr_pos = self._scanner.pos
        attr_name = self.require_text(WORD, "Expected attribute name")
        debug_print("found attr_name: " + attr_name)

        # optional value
        attr_value = None
        self.eat_whitespace()
        if self.get_text(EQUALS):
            self.eat_whitespace()
            attr_value = self.require_text(ATTR_VALUE)
            debug_print("found attr_value: " + attr_value)

        return Attr(name = attr_name, value = attr_value, pos = attr_pos)

    def get_text (self, pattern):
        '''Returns the text that matches the given pattern if it exists at the current point
        in the stream, or None if it does not.'''
        return self._scanner.scan(pattern)

    def require_text (self, pattern, msg = None):
        '''Returns the text that matches the given pattern if it exists at the current point
        in the stream, or None if it does not.'''
        value = self.get_text(pattern)
        if value is None:
            raise ParseError(self.string, self.pos, msg or "Expected " + str(pattern.pattern))
        return value

    def eat_whitespace (self):
        '''advances the stream to the first non-whitespace character'''
        self._scanner.scan(WHITESPACE)

if __name__ == "__main__":
    parser = Parser()
    page = parser.parse('''
        MyPage extends AnotherPage {
            bool foo;
            int bar;
            bool bar;
            float baz (min = 3);
            string str (nullable, text="asdf");

            Tome<AnotherPage> theTome;
            PageRef<ThirdPage> theRef;
        }
        ''')

    print page

