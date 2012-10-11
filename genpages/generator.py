#
# microtome - Tim Conkling, 2012

import pystache
from spec import *

BASE_PAGE_CLASS = "MTMutablePage"
BOOL_TYPENAME = "BOOL"
STRING_TYPENAME = "NSString"

def capitalize (str):
    '''capitalizes the first letter of the string, without lower-casing any of the others'''
    return str[0].capitalize() + str[1:]

def get_typename (the_type, pointer_type = True):
    if the_type == BoolType: typename = BOOL_TYPENAME
    elif the_type == StringType: typename = STRING_TYPENAME
    else: typename = the_type.name

    if not the_type.is_primitive and pointer_type: typename += "*"

    return typename

def get_propname (the_type):
    if the_type.name in BASE_TYPES: return "MTMutable" + capitalize(the_type.name) + "Prop"
    else: return "MTMutablePageProp"

class SpecDelegate(object):
    def __init__ (self, delegate):
        self._delegate = delegate

    def __getattr__ (self, name):
        return getattr(self._delegate, name)

class PropView(SpecDelegate):
    def __init__ (self, prop):
        SpecDelegate.__init__(self, prop)
        self.prop = prop

    def exposed_type (self):
        type_spec = self.prop.type
        if type_spec.type == PageRefType:
            return get_typename(type_spec.subtype)
        else:
            return get_typename(type_spec.type)

    def actual_type (self):
        type_spec = self.prop.type
        return get_propname(type_spec.type)

class PageView(SpecDelegate):
    def __init__ (self, page):
        SpecDelegate.__init__(self, page)
        self.page = page

    def superclass (self): return page.superclass or BASE_PAGE_CLASS
    def props (self): return [ PropView(prop) for prop in self.page.props ]
    def header_imports (self): return { "name": self.superclass() }
    def class_imports (self): return { "name": self.name }

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
@property (nonatomic,readonly) {{exposed_type}} {{name}};
{{/props}}

@end'''

CLASS_TEMPLATE = '''{{header}}
{{#class_imports}}
#import "{{name}}.h"
{{/class_imports}}

@implementation {{name}} {
@protected
{{#props}}
    {{actual_type}}* _{{name}};
{{/props}}
}

{{#props}}
- ({{exposed_type}}){{name}} { return _{{name}}.value; }
{{/props}}

- (NSArray*)props { return MT_PROPS({{#props}}_{{name}}, {{/props}}); }

- (id)init {
    if ((self = [super init])) {
    {{#props}}
        _{{name}} = [[{{actual_type}} alloc] initWithName:@"{{name}}" parent:self];
    {{/props}}
    }
    return self;
}
@end'''

if __name__ == "__main__":

    another_page_type = Type(name="AnotherPage", is_primitive = False, has_subtype = False)

    page = PageSpec(name = "TestPage",
        superclass = None,
        props = [
            PropSpec(type = TypeSpec(BoolType, None), name = "foo", attrs = None, pos = 0),
            PropSpec(type = TypeSpec(PageRefType, another_page_type), name = "bar", attrs = None, pos = 0)
        ],
        pos = 0)

    generator = Generator(page)
    out = generator.generate()
    print out
