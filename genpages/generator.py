#
# microtome - Tim Conkling, 2012

from spec import *

class Generator:
    def __init__ (self, page):
        self._page = page

    def generate (self):
        return ""

    @property
    def int_name (self): return "int"

    @property
    def float_name (self): return "float"

    @property
    def bool_name (self): return "bool"

if __name__ == "__main__":
    page = Page(name = "test", superclass = None, props = [], pos = 0)
    generator = Generator(page)
    out = generator.generate()
    print out
