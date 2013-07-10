#
# microtome

import os.path
import logging

import xml.etree.ElementTree as ElementTree

from nose.tools import eq_, assert_is_not_none

import microtome.codegen.spec as s
from microtome.codegen.parser import Parser
import microtome.xml_support as xml_support
import microtome.ctx
from microtome.library import Library
import microtome.test.MicrotomePages as MicrotomePages
from microtome.test.PrimitivePage import PrimitivePage

CTX = microtome.ctx.create_ctx()
LOG = logging.getLogger(__name__)

def resource(name):
    return os.path.join(os.path.dirname(os.path.abspath(__file__)), "data", name)

def load_xml(lib, *filenames):
    CTX.load(lib, xml_support.readers_from_files(*[resource(name) for name in filenames]))
    return lib

def setup_tests():
    CTX.register_page_classes(MicrotomePages.get_page_classes())

def test_parser():
    test_input = '''
        namespace com.test;
        // comment 1
        page MyPage extends AnotherPage {
            bool foo;   // comment 2
            int bar;
            float baz (min = -3.0);
            string str (nullable, text="as df");

            Tome<AnotherPage> theTome;
            PageRef<ThirdPage> theRef;
        }

        page Page2 {
            string qwert;
        }
        '''
    page_specs = Parser(test_input).parse()
    eq_(len(page_specs), 2)
    page_spec = page_specs[0]
    eq_(page_spec.name, "MyPage")
    eq_(page_spec.namespace, "com.test")
    eq_(page_spec.superclass, "com.test.AnotherPage")

    foo = page_spec.props[0]
    eq_(foo.name, "foo")
    eq_(foo.type.name, s.BoolType)
    eq_(foo.type.subtype, None)

    baz = page_spec.props[2]
    eq_(baz.annotations[0].name, "min")
    eq_(baz.annotations[0].value, -3)

    theTome = page_spec.props[4]
    eq_(theTome.type.name, "Tome")
    eq_(theTome.type.subtype.name, "com.test.AnotherPage")

def test_primitives():
    lib = load_xml(Library(), "PrimitiveTest.xml")
    page = lib.get("primitiveTest")
    eq_(page.foo, True)
    eq_(page.bar, 2)
    eq_(page.baz, 3.1415)

def test_object():
    lib = load_xml(Library(), "ObjectTest.xml")
    eq_(lib.get("objectTest").foo, "foo")

def test_nested():
    lib = load_xml(Library(), "NestedTest.xml")
    nested = lib.get_item_with_qualified_name("nestedTest.nested")
    assert_is_not_none(nested)
    eq_(nested.baz, 3.1415)

def test_list():
    lib = load_xml(Library(), "ListTest.xml")
    page = lib.get("listTest")
    eq_(len(page.kids), 2)
    eq_(page.kids[1].bar, 666)

def test_ref():
    lib = load_xml(Library(), "TomeTest.xml", "RefTest.xml")
    tome = lib.get("tomeTest")
    ref = lib.get("refTest")
    eq_(len(tome), 2)
    eq_(ref.nested.baz, 3.1415)

def test_templates():
    lib = load_xml(Library(), "TemplateTest.xml")
    page1 = lib.get("templateTest1")
    page2 = lib.get("templateTest2")
    eq_(page1.foo, True)
    eq_(page2.baz, 666)
    eq_(page2.bar, 2)

def test_annotations():
    lib = load_xml(Library(), "AnnotationTest.xml")
    page = lib.get("annotationTest")
    eq_(page.foo, 4)
    eq_(page.bar, 3)
    eq_(page.primitives, None)

def test_writer():
    # load everything
    lib = load_xml(Library(), "PrimitiveTest.xml", "ObjectTest.xml", "NestedTest.xml",
        "ListTest.xml", "TomeTest.xml", "RefTest.xml", "TemplateTest.xml", "AnnotationTest.xml")

    # write it all back
    xmls = []
    for item in lib.values():
        xml = ElementTree.Element("microtome")
        CTX.write(item, xml_support.create_writer(xml))
        xmls.append(xml)

    # and load it again
    readers = xml_support.readers_from_xml_strings(*[ElementTree.tostring(xml) for xml in xmls])
    lib = Library()
    CTX.load(lib, readers)
