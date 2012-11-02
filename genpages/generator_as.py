#
# microtome - Tim Conkling, 2012

import pystache
import util
import spec as s

BASE_PAGE_CLASS = "MutablePage"
BOOL_NAME = "Boolean"
INT_NAME = "int"
FLOAT_NAME = "Number"
STRING_NAME = "String"
LIST_NAME = "Array"

TEMPLATES_DIR = util.abspath("templates/as")

def generate_page (page_spec, header_text = ""):
    '''Returns a list of (filename, filecontents) tuples representing the generated files to
    be written to disk'''
    page_view = PageView(page_spec, header_text)

     # "escape" param disables html-escaping
    stache = pystache.Renderer(search_dirs = TEMPLATES_DIR, escape = lambda u: u)

    class_name = page_view.class_filename()
    class_contents = stache.render(stache.load_template("as_class"), page_view)

    return [ (class_name, class_contents) ]

def get_as3_typename (the_type):
    '''converts a microtome typename to an actionscript typename'''
    if the_type == s.BoolType:
        return BOOL_NAME
    elif the_type == s.IntType:
        return INT_NAME
    elif the_type == s.FloatType:
        return FLOAT_NAME
    elif the_type == s.StringType:
        return STRING_NAME
    elif the_type == s.ListType:
        return LIST_NAME
    else:
        return the_type

def get_prop_typename (the_type):
    '''returns the prop typename for the given typename'''
    if the_type == s.BoolType:
        return "BoolProp"
    elif the_type == s.IntType:
        return "IntProp"
    elif the_type == s.FloatType:
        return "NumberProp"
    else:
        return "ObjectProp"

class TypeView(object):
    def __init__ (self, type):
        self.type = type;

    def is_primitive (self):
        return self.type.name in s.PRIMITIVE_TYPES

    def name (self):
        if self.type.name == s.PageRefType:
            return get_as3_typename(self.type.subtype.name)
        else:
            return get_as3_typename(self.type.name)


class PropView(object):
    def __init__ (self, prop):
        self.prop = prop;
        self.value_type = TypeView(prop.type)
        self.annotations = None

    def typename (self):
        return get_prop_typename(self.prop.type.name)

    def name (self):
        return self.prop.name

class PageView(object):
    def __init__ (self, page, header_text):
        self.page = page
        self.header = header_text
        self.props = [ PropView(prop) for prop in self.page.props ]

    def name (self):
        return self.page.name

    def superclass (self):
        return self.page.superclass or BASE_PAGE_CLASS

    def package (self):
        return self.page.package

    def class_filename (self):
        return self.name() + ".as"

if __name__ == "__main__":
    ANOTHER_PAGE_TYPE = s.TypeSpec(name="AnotherPage", subtype = None)

    PAGE = s.PageSpec(name = "TestPage",
        package = "com.microtome.test",
        superclass = None,
        props = [
            s.PropSpec(type = s.TypeSpec(s.BoolType, None), name = "foo", annotations = [
                s.AnnotationSpec(name="default", value="test", pos=0)
            ], pos = 0),
            s.PropSpec(type = s.TypeSpec(s.PageRefType, ANOTHER_PAGE_TYPE), name = "bar", annotations = [], pos = 0)
        ],
        pos = 0)

    for filename, file_contents in generate_page(PAGE):
        print filename + ":\n"
        print file_contents
