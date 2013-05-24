#
# microtome - Tim Conkling, 2012

import pystache
import itertools
import numbers

import microtome.codegen.spec as s
import microtome.codegen.util as util

BASE_PAGE_CLASS = "MTPage"

OBJC_TYPENAMES = {
    s.BoolType: "BOOL",
    s.IntType: "int",
    s.FloatType: "float",
    s.StringType: "NSString",
    s.ListType: "NSArray",
    s.PageRefType: "MTPageRef",
    s.TomeType: "MTMutableTome"
}

PRIMITIVE_PROPNAMES = {
    s.BoolType: "MTBoolProp",
    s.IntType: "MTIntProp",
    s.FloatType: "MTFloatProp"
}

OBJECT_PROPNAME = "MTObjectProp"

LIBRARY_HEADER = "MicrotomePages.h"
LIBRARY_CLASS = "MicrotomePages.m"

TEMPLATES_DIR = util.abspath("templates/objc")

# stuff we always import
BASE_IMPORTS = set(["microtome"])
# stuff we don't need to import/forward-declare (built-in types)
DISCARD_IMPORTS = set([name for name in OBJC_TYPENAMES.values() if not name.startswith("MT")])


def comment_prefix():
    return "//"

def generate_library(lib):
    '''Returns a list of (filename, filecontents) tuples representing the generated files to
    be written to disk'''

    # "escape" param disables html-escaping
    stache = pystache.Renderer(search_dirs=TEMPLATES_DIR, escape=lambda u: u)

    library_view = {"page_names": sorted(set([spec.name for spec in lib.pages])), "header": lib.header_text}

    header_contents = stache.render(stache.load_template(LIBRARY_HEADER), library_view)
    class_contents = stache.render(stache.load_template(LIBRARY_CLASS), library_view)

    return [(LIBRARY_HEADER, header_contents), (LIBRARY_CLASS, class_contents)]


def generate_page(lib, page_spec):
    '''Returns a list of (filename, filecontents) tuples representing the generated files to
    be written to disk'''
    page_view = PageView(page_spec, lib.header_text)

    # "escape" param disables html-escaping
    stache = pystache.Renderer(search_dirs=TEMPLATES_DIR, escape=lambda u: u)

    header_name = page_view.header_filename()
    header_contents = stache.render(stache.load_template("objc_header"), page_view)

    class_name = page_view.class_filename()
    class_contents = stache.render(stache.load_template("objc_class"), page_view)

    return [(header_name, header_contents), (class_name, class_contents)]


def capitalize(string):
    '''capitalizes the first letter of the string, without lower-casing any of the others'''
    return string[0].capitalize() + string[1:]


def get_objc_typename(the_type, pointer_type=True):
    '''converts a microtome typename to an objective-c typename'''
    if the_type in OBJC_TYPENAMES:
        typename = OBJC_TYPENAMES[the_type]
    else:
        typename = the_type

    if not the_type in s.PRIMITIVE_TYPES and pointer_type:
        typename += "*"

    return util.strip_namespace(typename)


def to_boxed(val):
    return "@%s" % val


def to_bool(val):
    return "YES" if val else "NO"


def to_nsstring(val):
    return '@"%s"' % val


class AttrView(object):
    def __init__(self, attr):
        self.attr = attr


class TypeView(object):
    def __init__(self, type):
        self.type = type

    def is_primitive(self):
        return self.type.name in s.PRIMITIVE_TYPES

    def is_pageref(self):
        return self.type.name == s.PageRefType

    def name(self):
        return self._get_name(True)

    def name_no_pointer(self):
        return self._get_name(False)

    def all_typenames(self):
        return [get_objc_typename(name, False) for name in s.type_spec_to_list(self.type)]

    def _get_name(self, pointer_type):
        if self.type.name == s.PageRefType:
            return get_objc_typename(self.type.subtype.name, pointer_type)
        else:
            return get_objc_typename(self.type.name, pointer_type)


class AnnotationView(object):
    def __init__(self, annotation):
        self.annotation = annotation

    def name(self):
        return self.annotation.name

    def value(self):
        # bools are Numbers, so do the bool check first
        if isinstance(self.annotation.value, bool):
            return to_boxed(to_bool(self.annotation.value))
        elif isinstance(self.annotation.value, numbers.Number):
            return to_boxed(self.annotation.value)
        else:
            return to_nsstring(self.annotation.value)


class PropView(object):
    def __init__(self, prop):
        self.prop = prop
        self.value_type = TypeView(prop.type)
        self.annotations = [AnnotationView(a) for a in prop.annotations]

    def typename(self):
        if self.prop.type.name in PRIMITIVE_PROPNAMES:
            return PRIMITIVE_PROPNAMES[self.prop.type.name]
        else:
            return OBJECT_PROPNAME

    def name(self):
        return self.prop.name

    def has_annos(self):
        return len(self.annotations) > 0


class PageView(object):
    def __init__(self, page, header_text):
        self.page = page
        self.header = header_text
        self.props = [PropView(prop) for prop in self.page.props]

    def class_imports(self):
        # generate our list of external classnames referenced by this page:
        # create a set of all types used by our props, and then remove stuff
        typename_lists = [p.value_type.all_typenames() for p in self.props]

        # remove the imports we never want; add the imports we always want
        all_typenames = set(itertools.chain.from_iterable(typename_lists)) - DISCARD_IMPORTS | BASE_IMPORTS
        return [self.name()] + sorted(all_typenames)

    def forward_decls(self):
        decls = [p.value_type.name_no_pointer() for p in self.props]
        return sorted(set(decls) - DISCARD_IMPORTS)

    def name(self):
        return self.page.name

    def superclass(self):
        return self.page.superclass or BASE_PAGE_CLASS

    def header_imports(self):
        return self.superclass()

    def header_filename(self):
        return self.name() + ".h"

    def class_filename(self):
        return self.name() + ".m"


if __name__ == "__main__":
    ANOTHER_PAGE_TYPE = s.TypeSpec(name="com.microtome.test.AnotherPage", subtype=None)
    NAMESPACE = "com.microtome.test"
    PAGE=s.PageSpec(name = "TestPage",
        namespace=NAMESPACE,
        superclass=None,
        props=[
            s.PropSpec(type = s.TypeSpec(s.BoolType, None), name="foo", annotations=[
                s.AnnotationSpec(name="default", value="test", pos=0),
                s.AnnotationSpec(name="nullable", value=True, pos=0)
            ], pos=0),
            s.PropSpec(type = s.TypeSpec(s.PageRefType, ANOTHER_PAGE_TYPE), name = "bar", annotations = [], pos = 0)
        ],
        pos = 0)

    LIB = s.LibrarySpec(namespace = NAMESPACE, header_text="", pages = [ PAGE ])
    for filename, file_contents in generate_page(LIB, PAGE):
        print filename + ":"
        print file_contents
