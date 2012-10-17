#
# microtome - Tim Conkling, 2012

import pystache
import spec as s

BASE_PAGE_CLASS = "MTMutablePage"
BOOL_TYPENAME = "BOOL"
STRING_TYPENAME = "NSString"
LIST_TYPENAME = "NSArray"

LIBRARY_HEADER = "MicrotomePages.h"
LIBRARY_CLASS = "MicrotomePages.m"

def generate_library (page_names, header_text = ""):
    '''Returns a list of (filename, filecontents) tuples representing the generated files to
    be written to disk'''
    stache = pystache.Renderer(search_dirs = "templates/objc")

    library_view = { "page_names": sorted(page_names), "header": header_text }

    header_contents = stache.render(stache.load_template(LIBRARY_HEADER), library_view)
    class_contents = stache.render(stache.load_template(LIBRARY_CLASS), library_view)

    return [ (LIBRARY_HEADER, header_contents), (LIBRARY_CLASS, class_contents) ]

def generate_page (page_spec, header_text = ""):
    '''Returns a list of (filename, filecontents) tuples representing the generated files to
    be written to disk'''
    page_view = PageView(page_spec, header_text)
    stache = pystache.Renderer(search_dirs = "templates/objc")

    header_name = page_view.header_filename()
    header_contents = stache.render(stache.load_template("page_header"), page_view)

    class_name = page_view.class_filename()
    class_contents = stache.render(stache.load_template("page_class"), page_view)

    return [ (header_name, header_contents), (class_name, class_contents) ]

def capitalize (string):
    '''capitalizes the first letter of the string, without lower-casing any of the others'''
    return string[0].capitalize() + string[1:]

def get_typename (the_type, pointer_type = True):
    if the_type == s.BoolType:
        typename = BOOL_TYPENAME
    elif the_type == s.StringType:
        typename = STRING_TYPENAME
    elif the_type == s.ListType:
        typename = LIST_TYPENAME
    else:
        typename = the_type

    if not the_type in s.PRIMITIVE_TYPES and pointer_type:
        typename += "*"

    return typename

def to_bool (val):
    return "YES" if val else "NO"

class AttrView(object):
    def __init__ (self, attr):
        self.attr = attr

class TypeView(object):
    def __init__ (self, type):
        self.type = type

    def is_primitive (self):
        return self.type.name in s.PRIMITIVE_TYPES

    def typename (self):
        if self.type.name == s.PageRefType or self.type.name == s.PageType:
            return get_typename(self.type.subtype.name)
        else:
            return get_typename(self.type.name)

class PropView(object):
    def __init__ (self, prop):
        self.prop = prop
        self.type = TypeView(prop.type)
        self.attr_dict = {}
        for attr in self.prop.attrs:
            self.attr_dict[attr.name] = attr.value

    def typename (self):
        if self.type.is_primitive():
            return "MT" + capitalize(self.prop.type.name) + "Prop"
        else:
            return "MTObjectProp"

    def name (self):
        return self.prop.name
    def nullable (self):
        return to_bool(self.attr_dict.get("nullable"))

class PageView(object):
    def __init__ (self, page, header_text):
        self.page = page
        self.header = header_text

    def name (self):
        return self.page.name
    def superclass (self):
        return self.page.superclass or BASE_PAGE_CLASS
    def props (self):
        return [ PropView(prop) for prop in self.page.props ]
    def header_imports (self):
        return self.superclass()
    def external_class_names (self):
        return sorted(set([ prop.type.subtype.name for prop in self.page.props if prop.type.subtype ]))
    def class_imports (self):
        return [ self.name() ] + self.external_class_names()
    def forward_decls (self):
        return self.external_class_names()
    def header_filename (self):
        return self.name() + ".h"
    def class_filename (self):
        return self.name() + ".m"

if __name__ == "__main__":

    ANOTHER_PAGE_TYPE = s.TypeSpec(name="AnotherPage", subtype = None)

    PAGE = s.PageSpec(name = "TestPage",
        superclass = None,
        props = [
            s.PropSpec(type = s.TypeSpec(s.BoolType, None), name = "foo", attrs = [], pos = 0),
            s.PropSpec(type = s.TypeSpec(s.PageRefType, ANOTHER_PAGE_TYPE), name = "bar", attrs = [], pos = 0)
        ],
        pos = 0)

    print generate_page(PAGE)

