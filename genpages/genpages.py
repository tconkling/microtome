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
        self.lineNumber = scanner.lineNumber()
        self.msg = msg
        self.args = (self.msg, self.lineNumber)


class Parser:
    def parse (self, string):
        self._scanner = StringScanner(string)
        self.parsePage()

    def parsePage (self):
        self.eatWhitespace()
        pageName = self.requireToken(WORD, "Expected page name")
        print("found pageName: " + str(pageName.value))

    def getToken (self, type):
        '''Returns the token of the given type if it exists at the current point in the stream,
        or None if it does not.'''
        value = self._scanner.scan(type)
        if value is None:
            return None
        return Token(type, value)

    def requireToken (self, type, errMsg = None):
        '''Returns a token of the given type if it exists at the current point in the stream,
        or throws an exception if it does not.'''
        token = self.getToken(type)
        if token is None:
            raise ParseError(errMsg, self._scanner)
        return token

    def eatWhitespace (self):
        '''advances the stream to the first non-whitespace character'''
        self._scanner.scan(WHITESPACE)

if __name__ == "__main__":
    parser = Parser()
    parser.parse("   qwert")

