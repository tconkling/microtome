#
# microtome - Tim Conkling, 2012

'''
Usage:
import parser
page_specs = parser.parse_document(some_string)
'''

import re
import logging
import util
import spec as s
from stringscanner import StringScanner

# token types
QUOTED_STRING = re.compile(r'"([^"\\]*(\\.[^"\\]*)*)"')
NAMESPACE = re.compile(r'[a-zA-Z]+(\.[a-zA-Z]+)*')  # letters separated by .s
TYPENAME = re.compile(r'[a-zA-Z]\w*')               # must start with a letter
IDENTIFIER = re.compile(r'[a-zA-Z_]\w*')            # must start with a letter or _
ANNOTATION_VALUE = re.compile("([\w\.\-]+|{0})".format(QUOTED_STRING.pattern))
CURLY_OPEN = re.compile(r'\{')
CURLY_CLOSE = re.compile(r'\}')
PAREN_OPEN = re.compile(r'\(')
PAREN_CLOSE = re.compile(r'\)')
ANGLE_OPEN = re.compile(r'<')
ANGLE_CLOSE = re.compile(r'>')
SEMICOLON = re.compile(r';')
EQUALS = re.compile(r'=')
COMMA = re.compile(r',')
QUALIFIED_TYPENAME = re.compile("({0})?{1}".format(NAMESPACE.pattern, TYPENAME.pattern))

WHITESPACE_AND_COMMENTS = re.compile(r'(\s*(//.*$)?)+', re.MULTILINE)

LOG = logging.getLogger("parser")


def parse_document(string):
    '''parses a microtome document from a string'''
    return Parser(string).parse()


class ParseError(Exception):
    '''Problem that occurred during parsing'''
    def __init__(self, string, pos, msg):
        line_data = util.line_data_at_index(string, pos)

        self.line_number = line_data.line_num
        self.column = line_data.col
        self.line = string.splitlines()[line_data.line_num]
        self.message = msg
        self.filename = None

    def __str__(self):
        return 'File "%s", line %d: %s' % (self.filename, self.line_number + 1, self.message)


class Parser(object):
    '''parses a microtome document from a string'''
    def __init__(self, string):
        self._scanner = StringScanner(string)

    def parse(self):
        '''parse the document and return a list of PageSpec tokens'''
        # parse
        self._namespace = self.parse_namespace()
        pages = self.parse_pages()
        # validate
        for page in pages:
            self.validate_page(page)
        return pages

    @property
    def namespace(self):
        '''returns the documents's parsed namespace'''
        return self._namespace

    @property
    def string(self):
        '''return the string passed the parser'''
        return self._scanner.string

    @property
    def pos(self):
        '''return the current scan position in the string'''
        return self._scanner.pos

    def validate_page(self, page):
        '''perform semantic validation on a PageSpec'''
        # check for duplicate property names
        prop_names = set()
        for prop in page.props:
            lc_name = prop.name.lower()
            if lc_name in s.RESERVED_NAMES:
                raise ParseError(self.string, prop.pos, "Illegal use of reserved property name '%s'" % prop.name)
            elif lc_name in prop_names:
                raise ParseError(self.string, prop.pos, "Duplicate property name '%s'" % prop.name)
            prop_names.add(lc_name)

    def parse_namespace(self):
        # namespace is optional
        namespace = ""
        self.eat_whitespace()
        if self.get_text("namespace") is not None:
            self.eat_whitespace()
            namespace = self.require_text(NAMESPACE, "Expected namespace")
            self.require_text(SEMICOLON, "invalid namespace (expected ';')")
            LOG.debug("found namespace: %s" % namespace)
        return namespace

    def parse_pages(self):
        pages = []
        while True:
            self.eat_whitespace()
            page = self.parse_page()
            if page is None:
                break
            pages.append(page)
        return pages

    def parse_page(self):
        '''parse a PageSpec'''

        # name
        self.eat_whitespace()
        page_pos = self._scanner.pos
        page_name = self.get_text(TYPENAME)
        if page_name is None:
            return None

        LOG.debug("found page_name: " + page_name)

        # superclass
        self.eat_whitespace()
        page_superclass = None
        if self.get_text("extends") is not None:
            self.eat_whitespace()
            page_superclass = self.parse_qualified_typename("Expected superclass name")
            LOG.debug("found superclass: " + page_superclass)

        # open-curly
        self.eat_whitespace()
        self.require_text(CURLY_OPEN, "expected '{'")

        page_props = self.parse_props()

        # close-curly
        self.eat_whitespace()
        self.require_text(CURLY_CLOSE, "expected '}'")

        return s.PageSpec(name=page_name,
                          superclass=page_superclass,
                          namespace=self.namespace,
                          props=page_props,
                          pos=page_pos)

    def parse_props(self):
        '''parse a list of PropSpecs'''
        props = []
        while True:
            prop = self.parse_prop()
            if not prop:
                break
            props.append(prop)
        return props

    def parse_prop(self):
        '''parse a single PropSpec'''
        self.eat_whitespace()
        prop_pos = self._scanner.pos
        if not self.check_text(QUALIFIED_TYPENAME):
            return None

        # type
        prop_type = self.parse_prop_type()
        LOG.debug("found prop type: " + prop_type.name)

        # name
        self.eat_whitespace()
        prop_name = self.require_text(IDENTIFIER, "Expected prop name")
        LOG.debug("found prop_name: " + prop_name)

        # annotations
        annotations = None
        self.eat_whitespace()
        if self.get_text(PAREN_OPEN):
            annotations = self.parse_annotations()
            self.eat_whitespace()
            self.require_text(PAREN_CLOSE, "expected ')'")

        self.require_text(SEMICOLON, "expected semicolon")

        return s.PropSpec(type=prop_type, name=prop_name, annotations=annotations or [], pos=prop_pos)

    def parse_prop_type(self, is_subtype=False):
        '''parse a TypeSpec'''
        self.eat_whitespace()
        typename = self.require_text(QUALIFIED_TYPENAME, "Expected type identifier")

        if not typename in s.ALL_TYPES:
            typename = self.make_qualified_typename(typename)
            LOG.debug("Found custom type: '%s'" % typename)

        # subtype
        subtype = None
        self.eat_whitespace()
        if self.get_text(ANGLE_OPEN):
            self.eat_whitespace()
            subtype = self.parse_prop_type(True)
            self.eat_whitespace()
            self.require_text(ANGLE_CLOSE, "Expected '>'")
            LOG.debug("found subtype: " + subtype.name)

        if not is_subtype:
            if typename in s.PARAMETERIZED_TYPES and subtype is None:
                raise ParseError(self.string, self.pos, "Expected parameterized type for '%s'" % typename)
            elif not typename in s.PARAMETERIZED_TYPES and subtype is not None:
                raise ParseError(self.string, self.pos, "'%s' is not a parameterized type" % typename)

        return s.TypeSpec(name=typename, subtype=subtype)

    def parse_qualified_typename(self, errText=None):
        '''Parses a namespace-qualified typename. If the the namespace is omitted, the page's
        namespace is assumed'''
        return self.make_qualified_typename(self.require_text(QUALIFIED_TYPENAME, errText))

    def make_qualified_typename(self, typename):
        if util.get_namespace(typename) == "" and self.namespace != "":
            return self.namespace + "." + typename
        else:
            return typename

    def parse_annotations(self):
        '''parse a list of AnnotationSpecs'''
        annotations = []
        while True:
            annotations.append(self.parse_annotation())
            self.eat_whitespace()
            if not self.get_text(COMMA):
                break
        return annotations

    def parse_annotation(self):
        '''parse a single AnnotationSpec'''
        # name
        self.eat_whitespace()
        anno_pos = self._scanner.pos
        anno_name = self.require_text(IDENTIFIER, "Expected annotation name")
        LOG.debug("found anno_name: " + anno_name)

        # optional value
        anno_value = None
        self.eat_whitespace()
        if self.get_text(EQUALS):
            self.eat_whitespace()
            # determine the type. annotations can be bools, floats, or strings
            text = self.get_text(ANNOTATION_VALUE)
            anno_value = get_number(text)
            if anno_value is None:
                anno_value = get_bool(text)
            if anno_value is None:
                anno_value = get_quoted_string(text)
            if anno_value is None:
                raise ParseError(self.string, self.pos, "Expected a bool, a number, or a quoted string")
        else:
            # if no value is specified, we default to True (this is for flag-like annotations,
            # like 'nullable')
            anno_value = True

        return s.AnnotationSpec(name=anno_name, value=anno_value, pos=anno_pos)

    def check_text(self, pattern):
        '''Returns the text that matches the given pattern if it exists at the current point
        in the stream, or None if it does not. Does not advance the stream pointer.'''
        return self._scanner.check(pattern)

    def get_text(self, pattern):
        '''Returns the text that matches the given pattern if it exists at the current point
        in the stream, or None if it does not.'''
        return self._scanner.scan(pattern)

    def require_text(self, pattern, msg=None):
        '''Returns the text that matches the given pattern if it exists at the current point
        in the stream, or raises a ParseError if it does not.'''
        value = self.get_text(pattern)
        if value is None:
            raise ParseError(self.string, self.pos, msg or "Expected " + str(pattern.pattern))
        return value

    def eat_whitespace(self):
        '''advances the stream to the first non-whitespace character'''
        self._scanner.scan(WHITESPACE_AND_COMMENTS)


def get_number(s):
    '''returns the float represented by the string, or None if the string can't be converted'''
    try:
        return float(s)
    except ValueError:
        return None


def get_bool(s):
    '''returns the bool represented by the string, or None if the string can't be converted'''
    if s == "true":
        return True
    elif s == "false":
        return False
    else:
        return None


def get_quoted_string(s):
    '''returns the quoted string represented by the string, or None if the string can't be
    converted'''
    if QUOTED_STRING.match(s) is not None:
        return s[1:len(s) - 1]
    else:
        return None


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    TEST_STR = '''
        namespace com.test;
        // comment 1
        MyPage extends AnotherPage {
            bool foo;   // comment 2
            int bar;
            float baz (min = -3.0);
            string str (nullable, text="as df");

            Tome<AnotherPage> theTome;
            PageRef<ThirdPage> theRef;
        }
        '''
    print Parser(TEST_STR).parse()
