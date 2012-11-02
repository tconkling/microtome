#
# microtome - Tim Conkling, 2012

import pystache
import numbers
import util
import spec as s

BASE_PAGE_CLASS = "microtome.MutablePage"

AS3_TYPENAMES = {
    s.BoolType: "Boolean",
    s.IntType: "int",
    s.FloatType: "Number",
    s.StringType: "String",
    s.ListType: "Array"
}

PRIMITIVE_PROPNAMES = {
    s.BoolType: "microtome.BoolProp",
    s.IntType: "microtome.IntProp",
    s.FloatType: "microtome.NumberProp"
}

OBJECT_PROPNAME = "microtome.ObjectProp"

LIBRARY_CLASS = "MicrotomePages.as"
TEMPLATES_DIR = util.abspath("templates/as")

# stuff we always import
BASE_IMPORTS = set(["microtome.PropSpec"])
# stuff we never import
DISCARD_IMPORTS = set(AS3_TYPENAMES.itervalues())

def generate_library (page_names, header_text = ""):
    '''Returns a list of (filename, filecontents) tuples representing the generated files to
    be written to disk'''

    # "escape" param disables html-escaping
    stache = pystache.Renderer(search_dirs = TEMPLATES_DIR, escape = lambda u: u)

    library_view = { "page_names": sorted(page_names), "header": header_text }

    class_contents = stache.render(stache.load_template(LIBRARY_CLASS), library_view)

    return [ (LIBRARY_CLASS, class_contents) ]

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
    if the_type in AS3_TYPENAMES:
        return AS3_TYPENAMES[the_type]
    else:
        return the_type

def get_prop_typename (the_type):
    '''returns the prop typename for the given typename'''
    if the_type in PRIMITIVE_PROPNAMES:
        return PRIMITIVE_PROPNAMES[the_type]
    else:
        return OBJECT_PROPNAME

def strip_package (typename):
    '''com.microtome.Foo -> Foo'''
    idx = typename.rfind(".")
    return typename[idx+1:] if idx >= 0 else typename

def get_package (typename):
    '''com.microtome.Foo -> com.microtome'''
    idx = typename.rfind(".")
    return typename[:idx] if idx >= 0 else ""

def to_bool (val):
    return "true" if val else "false"

class TypeView(object):
    def __init__ (self, type):
        self.type = type;

    def is_primitive (self):
        return self.type.name in s.PRIMITIVE_TYPES

    def name (self):
        return strip_package(self.qualified_name())

    def qualified_name (self):
        if self.type.name == s.PageRefType:
            return get_as3_typename(self.type.subtype.name)
        else:
            return get_as3_typename(self.type.name)

class AnnotationView(object):
    def __init__ (self, annotation):
        self.annotation = annotation

    def name (self):
        return self.annotation.name

    def value (self):
        # bools are Numbers, so do the bool check first
        if isinstance(self.annotation.value, bool):
            return to_bool(self.annotation.value)
        elif isinstance(self.annotation.value, numbers.Number):
            return self.annotation.value
        else:
            return '"' + self.annotation.value + '"'

class PropView(object):
    def __init__ (self, prop):
        self.prop = prop;
        self.value_type = TypeView(prop.type)
        self.annotations = [ AnnotationView(a) for a in prop.annotations ]

    def typename (self):
        return strip_package(self.qualified_typename())

    def qualified_typename (self):
        return get_prop_typename(self.prop.type.name)

    def name (self):
        return self.prop.name

    def has_annos (self):
        return len(self.annotations) > 0

class PageView(object):
    def __init__ (self, page, header_text):
        self.page = page
        self.header = header_text
        self.props = [ PropView(prop) for prop in self.page.props ]

    def name (self):
        return self.page.name

    def superclass (self):
        return strip_package(self.qualified_superclass())

    def qualified_superclass (self):
        return self.page.superclass or BASE_PAGE_CLASS

    def namespace (self):
        return self.page.namespace

    def class_filename (self):
        return self.name() + ".as"

    def same_namespace (self, typename):
        return self.namespace() == get_package(typename)

    def imports (self):
        # prop classes
        imp_list = [ prop.qualified_typename() for prop in self.props ]
        # prop value classes
        imp_list += [ prop.value_type.qualified_name() for prop in self.props ]
        # our own superclass
        imp_list.append(self.qualified_superclass())

        # strip out anything in our namespace
        imp_list = [ imp for imp in imp_list if not self.same_namespace(imp) ]

        # remove the imports we never want; add the imports we always want
        imports = set(imp_list) - DISCARD_IMPORTS | BASE_IMPORTS

        return sorted(imports)

if __name__ == "__main__":
    ANOTHER_PAGE_TYPE = s.TypeSpec(name="com.microtome.test.AnotherPage", subtype = None)

    PAGE = s.PageSpec(name = "TestPage",
        namespace = "com.microtome.test",
        superclass = None,
        props = [
            s.PropSpec(type = s.TypeSpec(s.BoolType, None), name = "foo", annotations = [
                s.AnnotationSpec(name="default", value="test", pos=0),
                s.AnnotationSpec(name="nullable", value=True, pos=0)
            ], pos = 0),
            s.PropSpec(type = s.TypeSpec(s.PageRefType, ANOTHER_PAGE_TYPE), name = "bar", annotations = [], pos = 0)
        ],
        pos = 0)

    for filename, file_contents in generate_page(PAGE):
        print filename + ":\n"
        print file_contents
