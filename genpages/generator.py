#
# microtome - Tim Conkling, 2012

import pystache
from spec import *

BASE_PAGE_CLASS = "MTMutablePage"

def get_typename (typespec):
    theType = typespec.type
    typename = theType.name
    if theType == BoolType:
        typename = "BOOL"
    elif theType == StringType:
        typename = "NSString"

    if not theType.is_primitive:
        typename += "*"

    return typename

class SpecDelegate(object):
    def __init__ (self, delegate):
        self._delegate = delegate

    def __getattr__ (self, name):
        return getattr(self._delegate, name)

class PropView(SpecDelegate):
    def __init__ (self, prop):
        SpecDelegate.__init__(self, prop)
        self.prop = prop

    def declared_type (self): return get_typename(self.prop.type)
    def actual_type (self): return self.declared_type()

class PageView(SpecDelegate):
    def __init__ (self, page):
        SpecDelegate.__init__(self, page)
        self.page = page

    def superclass (self): return page.superclass or BASE_PAGE_CLASS
    def props (self): return [ PropView(prop) for prop in self.page.props ]
    def header_imports (self): return { "name": self.superclass() }

class Generator(object):
    def __init__ (self, page):
        self._page = page

    def generate (self):
        page_view = PageView(self._page)
        stache = pystache.Renderer()
        header_file = stache.render(HEADER_TEMPLATE, page_view)
        class_file = stache.render(CLASS_TEMPLATE, page_view)
        return header_file + "\n\n" + class_file

HEADER_TEMPLATE = '''{{header}}
{{#header_imports}}
#import "{{name}}.h"
{{/header_imports}}

{{#header_declarations}}
{{/header_declarations}}

@interface {{name}} : {{superclass}}

{{#props}}
@property (nonatomic,readonly) {{declared_type}} {{name}};
{{/props}}

@end'''

CLASS_TEMPLATE = '''{{header}}
{{#class_imports}}
#import "{{name}}.h"
{{/class_imports}}

@implementation {{name}} {
@protected
{{#props}}
    MTMutable{{actual_type}} _{{name}};
{{/props}}
}
@end'''

if __name__ == "__main__":

    page = PageSpec(name = "TestPage",
        superclass = None,
        props = [
            PropSpec(type = TypeSpec(BoolType, None), name = "foo", attrs = None, pos = 0),
            PropSpec(type = TypeSpec(PageRefType, None), name = "bar", attrs = None, pos = 0)
        ],
        pos = 0)

    generator = Generator(page)
    out = generator.generate()
    print out
