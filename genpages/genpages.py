#!/usr/bin/env python

from stringscanner import StringScanner

from collections import namedtuple
import re

'''
MyPage extends Page {
        bool foo;
        int bar;
        float baz;
        string str (nullable=true);

        Tome<AnotherPage> theTome;
        PageRef<ThirdPage> theRef;
    }
'''

WORD = re.compile(r'[a-zA-Z_]\w*')
CURLY_OPEN = re.compile(r'\{')
CURLY_CLOSE = re.compile(r'\}')
PAREN_OPEN = re.compile(r'\(')
PAREN_CLOSE = re.compile(r'\)')
ANGLE_OPEN = re.compile(r'<')
ANGLE_CLOSE = re.compile(r'>')
SEMICOLON = re.compile(r';')
EQUALS = re.compile(r'=')

WHITESPACE = re.compile(r'\s+')

Page = namedtuple("Page", ["name", "superclass", "props"])
Prop = namedtuple("Prop", ["type", "name", "attrs"])
Attr = namedtuple("Attr", ["name", "value"])

class ParseError(Exception):
    '''Problem that occurred during parsing'''
    def __init__ (self, msg, scanner):
        self.line_number = scanner.line_number()
        self.msg = msg
        self.args = (self.msg, self.line_number)


class Parser:
    def parse (self, string):
        self._scanner = StringScanner(string)
        self.parse_page()

    def parse_page (self):
        # name
        self.eat_whitespace()
        page_name = self.require_text(WORD, "Expected page name")
        print("found page_name: " + page_name)

        # superclass
        self.eat_whitespace()
        page_superclass = None
        if self.get_text("extends") is not None:
            self.eat_whitespace()
            page_superclass = self.require_text(WORD, "Expected superclass name")
            print("found superclass: " + page_superclass)

        # open-curly
        self.eat_whitespace()
        self.require_text(CURLY_OPEN)

        page_props = self.parse_props()

        # close-curly
        self.eat_whitespace()
        self.require_text(CURLY_CLOSE)

    def parse_props (self):
        props = []
        while True:
            prop = self.parse_prop()
            if not prop:
                break;
            props.append(prop)
        return props

    def parse_prop (self):
        self.eat_whitespace()
        prop_type = self.get_text(WORD)
        if not prop_type:
            return None
        print("found prop_type: " + prop_type)
        self.eat_whitespace()
        prop_name = self.require_text(WORD, "Expected prop name")
        print("found prop_name: " + prop_name)
        self.require_text(SEMICOLON, "expected semicolon");
        return Prop(prop_type, prop_name, None)


    def get_text (self, pattern):
        '''Returns the text that matches the given pattern if it exists at the current point
        in the stream, or None if it does not.'''
        return self._scanner.scan(pattern)

    def require_text (self, pattern, msg = None):
        '''Returns the text that matches the given pattern if it exists at the current point
        in the stream, or None if it does not.'''
        value = self.get_text(pattern)
        if value is None:
            raise ParseError(msg or "Expected " + str(pattern.pattern), self._scanner)
        return value

    def eat_whitespace (self):
        '''advances the stream to the first non-whitespace character'''
        self._scanner.scan(WHITESPACE)

if __name__ == "__main__":
    parser = Parser()
    parser.parse('''
        MyPage extends AnotherPage {
            bool myBool;

        }
        ''')

