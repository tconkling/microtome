#
# microtome - Tim Conkling, 2012

from stringscanner import StringScanner
from spec import *

import re
import util

# token types
IDENTIFIER = re.compile(r'[a-zA-Z_]\w*')    # must start with a letter or _
ATTR_VALUE = re.compile(r'[\w\"]+')         # can contain " and '
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

        self.line_number = line_data.line_num
        self.line = (string.splitlines()[line_data.line_num])[line_data.col:]
        self.message = msg

        self.args = (self.message, self.line_number, self.line)

class Parser(object):
    '''parses a page from a string'''
    def __init__ (self, string):
        self._scanner = StringScanner(string)

    def parse (self):
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
        page_name = self.require_text(IDENTIFIER, "Expected page name")
        debug_print("found page_name: " + page_name)

        # superclass
        self.eat_whitespace()
        page_superclass = None
        if self.get_text("extends") is not None:
            self.eat_whitespace()
            page_superclass = self.require_text(IDENTIFIER, "Expected superclass name")
            debug_print("found superclass: " + page_superclass)

        # open-curly
        self.eat_whitespace()
        self.require_text(CURLY_OPEN)

        page_props = self.parse_props()

        # close-curly
        self.eat_whitespace()
        self.require_text(CURLY_CLOSE)

        return PageSpec(name = page_name, superclass = page_superclass, props = page_props, pos = page_pos)

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
        prop_pos = self._scanner.pos
        if not self.check_text(IDENTIFIER):
            return None

        # type
        prop_type = self.parse_type()
        debug_print("found prop type: " + prop_type.type.name)

        # name
        self.eat_whitespace()
        prop_name = self.require_text(IDENTIFIER, "Expected prop name")
        debug_print("found prop_name: " + prop_name)

        # attrs
        attrs = None
        self.eat_whitespace()
        if self.get_text(PAREN_OPEN):
            attrs = self.parse_attrs()
            self.eat_whitespace()
            self.require_text(PAREN_CLOSE)

        self.require_text(SEMICOLON, "expected semicolon");

        return PropSpec(type = prop_type, name = prop_name, attrs = attrs, pos = prop_pos)

    def parse_type (self):
        self.eat_whitespace()
        typename = self.require_text(IDENTIFIER, "Expected type identifier")

        # subtype
        subtype = None
        self.eat_whitespace()
        if self.get_text(ANGLE_OPEN):
            self.eat_whitespace()
            subtype = self.parse_type()
            self.eat_whitespace()
            self.require_text(ANGLE_CLOSE, "Expected '>'")
            debug_print("found subtype: " + subtype.type.name)

        # if this is not one of our base types, create a new one
        if typename in BASE_TYPES:
            theType = BASE_TYPES[typename]
        else:
            theType = Type(name = typename, is_primitive = False, has_subtype = (subtype != None))

        return TypeSpec(type = theType, subtype = subtype)

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
        attr_name = self.require_text(IDENTIFIER, "Expected attribute name")
        debug_print("found attr_name: " + attr_name)

        # optional value
        attr_value = None
        self.eat_whitespace()
        if self.get_text(EQUALS):
            self.eat_whitespace()
            attr_value = self.require_text(ATTR_VALUE)
            debug_print("found attr_value: " + attr_value)

        return AttrSpec(name = attr_name, value = attr_value, pos = attr_pos)

    def check_text (self, pattern):
        '''Returns the text that matches the given pattern if it exists at the current point
        in the stream, or None if it does not. Does not advance the stream pointer.'''
        return self._scanner.check(pattern)

    def get_text (self, pattern):
        '''Returns the text that matches the given pattern if it exists at the current point
        in the stream, or None if it does not.'''
        return self._scanner.scan(pattern)

    def require_text (self, pattern, msg = None):
        '''Returns the text that matches the given pattern if it exists at the current point
        in the stream, or raises a ParseError if it does not.'''
        value = self.get_text(pattern)
        if value is None:
            raise ParseError(self.string, self.pos, msg or "Expected " + str(pattern.pattern))
        return value

    def eat_whitespace (self):
        '''advances the stream to the first non-whitespace character'''
        self._scanner.scan(WHITESPACE)

if __name__ == "__main__":
    test_str = '''
        MyPage extends AnotherPage {
            bool foo;
            int bar;
            float baz (min = 3);
            string str (nullable, text="asdf");

            Tome<AnotherPage> theTome;
            PageRef<ThirdPage> theRef;
        }
        '''
    parser = Parser(test_str)
    page = parser.parse()

    print page

