#
# microtome - Tim Conkling, 2012

'''
Usage:
import parser
page_spec = parser.parse(some_string)
'''

import re
import logging
import util
import spec as s
from stringscanner import StringScanner

# token types
IDENTIFIER = re.compile(r'[a-zA-Z_]\w*')    # must start with a letter or _
ANNOTATION_VALUE = re.compile(r'[\w\"]+')         # can contain " and '
CURLY_OPEN = re.compile(r'\{')
CURLY_CLOSE = re.compile(r'\}')
PAREN_OPEN = re.compile(r'\(')
PAREN_CLOSE = re.compile(r'\)')
ANGLE_OPEN = re.compile(r'<')
ANGLE_CLOSE = re.compile(r'>')
SEMICOLON = re.compile(r';')
EQUALS = re.compile(r'=')
COMMA = re.compile(r',')

WHITESPACE = re.compile(r'((\s)|(#.*$))+', re.MULTILINE)

LOG = logging.getLogger("parser")

def parse (string):
    '''parses a page from a string'''
    return Parser(string).parse()

class ParseError(Exception):
    '''Problem that occurred during parsing'''
    def __init__ (self, string, pos, msg):
        line_data = util.line_data_at_index(string, pos)

        self.line_number = line_data.line_num
        self.line = (string.splitlines()[line_data.line_num])[line_data.col:]
        self.message = msg
        self.filename = None

    def __str__ (self):
        return 'File "%s", line %d, "%s": %s' % (self.filename, self.line_number, self.line, self.message)

class Parser(object):
    '''parses a page from a string'''
    def __init__ (self, string):
        self._scanner = StringScanner(string)

    def parse (self):
        '''parse the page and returns a PageSpec token'''
        # parse
        page = self._parse_page()
        # check semantics
        self._validate_page(page)
        return page

    @property
    def string (self):
        '''return the string passed the parser'''
        return self._scanner.string

    @property
    def pos (self):
        '''return the current scan position in the string'''
        return  self._scanner.pos

    def _validate_page (self, page):
        '''perform semantic validation on a PageSpec'''
        # check for duplicate property names
        prop_names = set()
        for prop in page.props:
            if prop.name in prop_names:
                raise ParseError(self.string, prop.pos, "Duplicate property name: '" + prop.name + "'")
            prop_names.add(prop.name)

    def _parse_page (self):
        '''parse a PageSpec'''
        # name
        self._eat_whitespace()
        page_pos = self._scanner.pos
        page_name = self._require_text(IDENTIFIER, "Expected page name")
        LOG.debug("found page_name: " + page_name)

        # superclass
        self._eat_whitespace()
        page_superclass = None
        if self._get_text("extends") is not None:
            self._eat_whitespace()
            page_superclass = self._require_text(IDENTIFIER, "Expected superclass name")
            LOG.debug("found superclass: " + page_superclass)

        # open-curly
        self._eat_whitespace()
        self._require_text(CURLY_OPEN)

        page_props = self._parse_props()

        # close-curly
        self._eat_whitespace()
        self._require_text(CURLY_CLOSE)

        return s.PageSpec(name = page_name, superclass = page_superclass, props = page_props, pos = page_pos)

    def _parse_props (self):
        '''parse a list of PropSpecs'''
        props = []
        while True:
            prop = self._parse_prop()
            if not prop:
                break
            props.append(prop)
        return props

    def _parse_prop (self):
        '''parse a single PropSpec'''
        self._eat_whitespace()
        prop_pos = self._scanner.pos
        if not self._check_text(IDENTIFIER):
            return None

        # type
        prop_type = self._parse_type()
        LOG.debug("found prop type: " + prop_type.name)

        # name
        self._eat_whitespace()
        prop_name = self._require_text(IDENTIFIER, "Expected prop name")
        LOG.debug("found prop_name: " + prop_name)

        # annotations
        annotations = None
        self._eat_whitespace()
        if self._get_text(PAREN_OPEN):
            annotations = self._parse_annotations()
            self._eat_whitespace()
            self._require_text(PAREN_CLOSE)

        self._require_text(SEMICOLON, "expected semicolon")

        return s.PropSpec(type = prop_type, name = prop_name, annotations = annotations or [], pos = prop_pos)

    def _parse_type (self, is_subtype = False):
        '''parse a TypeSpec'''
        self._eat_whitespace()
        typename = self._require_text(IDENTIFIER, "Expected type identifier")

        if not is_subtype and not typename in s.ALL_TYPES:
            LOG.info("Found custom type: '%s'" % typename);

        # subtype
        subtype = None
        self._eat_whitespace()
        if self._get_text(ANGLE_OPEN):
            self._eat_whitespace()
            subtype = self._parse_type(True)
            self._eat_whitespace()
            self._require_text(ANGLE_CLOSE, "Expected '>'")
            LOG.debug("found subtype: " + subtype.name)

        if not is_subtype:
            if typename in s.PARAMETERIZED_TYPES and subtype == None:
                raise ParseError(self.string, self.pos, "Expected parameterized type for '%s'" % typename)
            elif not typename in s.PARAMETERIZED_TYPES and subtype != None:
                raise ParseError(self.string, self.pos, "'%s' is not parameterized" % typename)

        return s.TypeSpec(name = typename, subtype = subtype)

    def _parse_annotations (self):
        '''parse a list of AnnotationSpecs'''
        annotations = []
        while True:
            annotations.append(self._parse_annotation())
            self._eat_whitespace()
            if not self._get_text(COMMA):
                break
        return annotations

    def _parse_annotation (self):
        '''parse a single AnnotationSpec'''
        # name
        self._eat_whitespace()
        anno_pos = self._scanner.pos
        anno_name = self._require_text(IDENTIFIER, "Expected annotation name")
        LOG.debug("found anno_name: " + anno_name)

        # optional value
        anno_value = None
        self._eat_whitespace()
        if self._get_text(EQUALS):
            self._eat_whitespace()
            # determine the type. annotations can be bools, floats, or strings
            text = self._get_text(ANNOTATION_VALUE)
            anno_value = get_number(text)
            if anno_value == None:
                anno_value = get_bool(text)
            if anno_value == None:
                anno_value = get_quoted_string(text)
            if anno_value == None:
                raise ParseError(self.string, self.pos, "Expected a bool, a number, or a quoted string")
        else:
            # if no value is specified, we default to True (this is for flag-like annotations,
            # like 'nullable')
            anno_value = True

        return s.AnnotationSpec(name = anno_name, value = anno_value, pos = anno_pos)

    def _check_text (self, pattern):
        '''Returns the text that matches the given pattern if it exists at the current point
        in the stream, or None if it does not. Does not advance the stream pointer.'''
        return self._scanner.check(pattern)

    def _get_text (self, pattern):
        '''Returns the text that matches the given pattern if it exists at the current point
        in the stream, or None if it does not.'''
        return self._scanner.scan(pattern)

    def _require_text (self, pattern, msg = None):
        '''Returns the text that matches the given pattern if it exists at the current point
        in the stream, or raises a ParseError if it does not.'''
        value = self._get_text(pattern)
        if value is None:
            raise ParseError(self.string, self.pos, msg or "Expected " + str(pattern.pattern))
        return value

    def _eat_whitespace (self):
        '''advances the stream to the first non-whitespace character'''
        self._scanner.scan(WHITESPACE)

def get_number (s):
    '''returns the float represented by the string, or None if the string can't be converted'''
    try:
        return float(s)
    except ValueError:
        return None

def get_bool (s):
    '''returns the bool represented by the string, or None if the string can't be converted'''
    if s == "true":
        return True
    elif s == "false":
        return False
    else:
        return None

def get_quoted_string (s):
    '''returns the quoted string represented by the string, or None if the string can't be
    converted'''
    if (s.startswith('"') and s.endswith('"')) or (s.startswith("'") and s.endswith("'")):
        return s[1:len(s) - 1]
    else:
        return None

if __name__ == "__main__":
    logging.basicConfig(level = logging.INFO)
    TEST_STR = '''
        # comment 1
        MyPage extends AnotherPage {
            bool foo;   # comment 2
            int bar;
            float baz (min = 3);
            string str (nullable, text="asdf");

            Tome<AnotherPage> theTome;
            PageRef<ThirdPage> theRef;
        }
        '''
    print Parser(TEST_STR).parse()

