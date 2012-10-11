#
# microtome - Tim Conkling, 2012

import pystache
from spec import *

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

    def type (self): return get_typename(self.prop.type)

class PageView(SpecDelegate):
    def __init__ (self, page):
        SpecDelegate.__init__(self, page)
        self.page = page

    def superclass (self): return page.superclass or "MTMutablePage"
    def props (self): return [ PropView(prop) for prop in self.page.props ]
    def imports (self): return { "name": self.superclass() }

class Generator(object):
    def __init__ (self, page):
        self._page = page

    def generate (self):
        return pystache.Renderer().render(OBJC_HEADER_TEMPLATE, PageView(self._page))

OBJC_HEADER_TEMPLATE = '''
{{header}}

{{#imports}}
#import "{{name}}.h"
{{/imports}}

{{#declarations}}
{{/declarations}}

@interface {{name}} : {{superclass}}

{{#props}}
@property (nonatomic,readonly) {{type}} {{name}};
{{/props}}

@end
'''

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
