#
# microtome

import logging
import os.path

import microtome.xml_support as xml_support
import microtome.ctx
from microtome.library import Library
from microtome.error import MicrotomeError

import microtome.test.MicrotomePages as MicrotomePages

LOG = logging.getLogger("tests")
CTX = microtome.ctx.create_ctx()
LIB = Library()

def resource(name):
    return os.path.join(os.path.dirname(os.path.abspath(__file__)), "data", name)

def setup_tests():
    logging.basicConfig(level=logging.DEBUG)
    CTX.register_page_classes(MicrotomePages.get_page_classes())

if __name__ == "__main__":
    try:
        readers = xml_support.readers_from_files(
            resource("AnnotationTest.xml"),
            resource("ListTest.xml"),
            # resource("NestedTest.xml"),
            # resource("ObjectTest.xml"),
            resource("PrimitiveTest.xml"),
            resource("RefTest.xml"),
            resource("TemplateTest.xml"),
            resource("TomeTest.xml"))
        CTX.load(LIB, readers)
        LOG.info(LIB.get("primitiveTest").foo)
        LOG.info(len(LIB.get("listTest").kids))
        LOG.info(LIB.get("listTest").kids[1].bar)
        LOG.info(LIB.get("annotationTest").primitives)
        LOG.info(LIB.get("annotationTest").bar)
        LOG.info(LIB.get("refTest").nested.baz)
        LOG.info(LIB.get("templateTest2").bar)
        LOG.info(LIB.get("templateTest2").baz)
    except MicrotomeError as e:
        print e.stacktrace
