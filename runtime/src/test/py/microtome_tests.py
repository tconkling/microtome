#
# microtome

import os.path

import microtome.xml_support
import microtome.ctx
from microtome.library import Library
from primitive_page import PrimitivePage
from microtome.error import MicrotomeError

def resource(name):
    return os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "resources", name)

if __name__ == "__main__":
    try:
        lib = Library()
        ctx = microtome.ctx.create_ctx()
        ctx.register_page_classes([PrimitivePage])
        readers = microtome.xml_support.readers_from_files(resource("PrimitiveTest.xml"))
        ctx.load(lib, readers)
        print lib.get("primitiveTest").foo
    except MicrotomeError as e:
        print e.stacktrace
