#
# microtome

import logging
import os.path

import microtome.xml_support
import microtome.ctx
from microtome.library import Library
from primitive_page import PrimitivePage
from list_page import ListPage
from microtome.error import MicrotomeError

LOG = logging.getLogger("tests")

def resource(name):
    return os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "resources", name)

if __name__ == "__main__":
    logging.basicConfig(level=logging.DEBUG)
    try:
        lib = Library()
        ctx = microtome.ctx.create_ctx()
        ctx.register_page_classes([PrimitivePage, ListPage])
        readers = microtome.xml_support.readers_from_files(
            resource("PrimitiveTest.xml"),
            resource("ListTest.xml"))
        ctx.load(lib, readers)
        LOG.info(lib.get("primitiveTest").foo)
        LOG.info(len(lib.get("listTest").kids))
        LOG.info(lib.get("listTest").kids[1].bar)
    except MicrotomeError as e:
        print e.stacktrace
