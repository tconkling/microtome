#
# microtome - Tim Conkling, 2012

import pystache
from spec import *

class AttrWrapper(object):
    def __init__ (self, delegate):
        self._delegate = delegate

    def __getattr__ (self, name):
        return getattr(self._delegate, name)

class PropView(AttrWrapper):
    def __init__ (self, prop):
        AttrWrapper.__init__(self, prop)
        self.prop = prop

    def type (self):
        type = self.prop.type
        if type == "bool":
            return "BOOL"
        else: return type


class PageView(AttrWrapper):
    def __init__ (self, page):
        AttrWrapper.__init__(self, page)
        self.page = page

    def props (self):
        return [PropView(prop) for prop in self.page.props]

    def superclass (self): return page.superclass or "MTMutablePage"


class Generator(object):
    def __init__ (self, page):
        self._view = PageView(page)

    def generate (self):
        return ""

class ObjCGenerator(Generator):
    def generate (self):
        stache = pystache.Renderer()
        return stache.render(OBJC_HEADER_TEMPLATE, self._view)

OBJC_HEADER_TEMPLATE = '''
{{header}}

@interface {{name}} : {{superclass}}

{{#props}}
@property (nonatomic,readonly) {{type}} {{name}};
{{/props}}

@end
'''

if __name__ == "__main__":

    page = Page(name = "TestPage",
        superclass = None,
        props = [
            Prop(type = "bool", subtype = None, name = "foo", attrs = None, pos = 0),
            Prop(type = "PageRef", subtype = "MyPage", name = "bar", attrs = None, pos = 0)
        ],
        pos = 0)

    generator = ObjCGenerator(page)
    out = generator.generate()
    print out
