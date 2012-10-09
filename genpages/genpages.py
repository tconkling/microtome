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

WORD = r'\w+'
CURLY_OPEN = r'\{'
CURLY_CLOSE = r'\}'
PAREN_OPEN = r'\('
PAREN_CLOSE = r'\)'
ANGLE_OPEN = r'<'
ANGLE_CLOSE = r'>'
SEMICOLON = r';'
EQUALS=r'='

WHITESPACE = r'\s+'

Token = namedtuple("Token", ["value", "type"])


class Parser:
    def parse (self, string):
        self._scanner = Scanner(string)

    def parsePage (self):
        self.eatWhitespace()


    def eatWhitespace (self):
        '''advances the stream to the first non-whitespace character'''
        whitespace = self._scanner.scan()

    def peekToken (self):
        '''Returns the next token in the stream'''

    def eatToken (self):
        '''Returns the next token in the stream and advances the stream pointer'''

    def requireToken (self, tokenType):
        ''' Returns the next token in the stream and advances the stream pointer.
        Throws an exception if the required token is not the next'''

if __name__ == "__main__":
    scanner = StringScanner("1\n2\n3")
    print(scanner.lineNumber())
