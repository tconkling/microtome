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

def generate_page (page_spec, package, header_text = ""):
    '''Returns a list of (filename, filecontents) tuples representing the generated files to
    be written to disk'''
    page_view = PageView(page_spec, package, header_text)

     # "escape" param disables html-escaping
    stache = pystache.Renderer(search_dirs = TEMPLATES_DIR, escape = lambda u: u)

    class_name = page_view.class_filename()
    class_contents = stache.render(stache.load_template("as_class"), page_view)

    return [ (class_name, class_contents) ]

class PageView(object):
    def __init__ (self, page, package, header_text):
        self.page = page
        self.header = header_text
        self.package = ".".join(package)

    def name (self):
        return self.page.name
    def class_filename (self):
        return self.name() + ".as"

if __name__ == "__main__":
    ANOTHER_PAGE_TYPE = s.TypeSpec(name="AnotherPage", subtype = None)

    PAGE = s.PageSpec(name = "TestPage",
        superclass = None,
        props = [
            s.PropSpec(type = s.TypeSpec(s.BoolType, None), name = "foo", annotations = [
                s.AnnotationSpec(name="default", value="test", pos=0)
            ], pos = 0),
            s.PropSpec(type = s.TypeSpec(s.PageRefType, ANOTHER_PAGE_TYPE), name = "bar", annotations = [], pos = 0)
        ],
        pos = 0)

    PACKAGE = [ "com", "microtome", "test" ]

    for filename, file_contents in generate_page(PAGE, PACKAGE):
        print filename + ":\n"
        print file_contents
