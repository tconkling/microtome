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

Token = namedtuple("Token", ["type", "value"])

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
        page_name = self.require_token(WORD, "Expected page name").value
        print("found page_name: " + page_name)

        # superclass
        self.eat_whitespace()
        page_superclass = None
        if self.get_text("extends") is not None:
            print("found 'extends'")
            self.eat_whitespace()
            page_superclass = self.require_token(WORD, "Expected superclass name").value
            print("found superClass: " + page_superclass)


    def get_text (self, pattern):
        '''Returns the text that matches the given pattern if it exists at the current point
        in the stream, or None if it does not.'''
        return self._scanner.scan(pattern)

    def require_text (self, pattern, msg):
        '''Returns the text that matches the given pattern if it exists at the current point
        in the stream, or None if it does not.'''
        value = get_text(pattern)
        if value is None:
            raise ParseError(msg, self._scanner)
        return value

    def get_token (self, type):
        '''Returns the token of the given type if it exists at the current point in the stream,
        or None if it does not.'''
        value = self._scanner.scan(type)
        if value is None:
            return None
        return Token(type, value)

    def require_token (self, type, msg = None):
        '''Returns a token of the given type if it exists at the current point in the stream,
        or throws an exception if it does not.'''
        token = self.get_token(type)
        if token is None:
            raise ParseError(msg, self._scanner)
        return token

    def eat_whitespace (self):
        '''advances the stream to the first non-whitespace character'''
        self._scanner.scan(WHITESPACE)

if __name__ == "__main__":
    parser = Parser()
    parser.parse("   qwert")

