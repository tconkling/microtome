#
# microtome

import os.path

from nose.tools import eq_

import microtome.codegen.spec as s
from microtome.codegen.parser import Parser
import microtome.xml_support as xml_support
import microtome.ctx
from microtome.library import Library
import microtome.test.MicrotomePages as MicrotomePages

CTX = microtome.ctx.create_ctx()
LIB = Library()

def resource(name):
    return os.path.join(os.path.dirname(os.path.abspath(__file__)), "data", name)

def load_xml(*filenames):
    CTX.load(LIB, xml_support.readers_from_files(*[resource(name) for name in filenames]))

def setup_tests():
    CTX.register_page_classes(MicrotomePages.get_page_classes())

def test_parser():
    test_input = '''
        namespace com.test;
        // comment 1
        MyPage extends AnotherPage {
            bool foo;   // comment 2
            int bar;
            float baz (min = -3.0);
            string str (nullable, text="as df");

            Tome<AnotherPage> theTome;
            PageRef<ThirdPage> theRef;
        }
        '''
    page_specs = Parser(test_input).parse()
    eq_(len(page_specs), 1)
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
    load_xml("PrimitiveTest.xml")
    page = LIB.get("primitiveTest")
    eq_(page.foo, True)
    eq_(page.bar, 2)
    eq_(page.baz, 3.1415)

def test_object():
    load_xml("ObjectTest.xml")
    eq_(LIB.get("objectTest").foo, "foo")

def test_nested():
    load_xml("NestedTest.xml")
    eq_(LIB.get("nestedTest").nested.baz, 3.1415)

def test_list():
    load_xml("ListTest.xml")
    page = LIB.get("listTest")
    eq_(len(page.kids), 2)
    eq_(page.kids[1].bar, 666)

def test_ref():
    load_xml("TomeTest.xml", "RefTest.xml")
    tome = LIB.get("tomeTest")
    ref = LIB.get("refTest")
    eq_(len(tome), 2)
    eq_(ref.nested.baz, 3.1415)

def test_templates():
    load_xml("TemplateTest.xml")
    page1 = LIB.get("templateTest1")
    page2 = LIB.get("templateTest2")
    eq_(page1.foo, True)
    eq_(page2.baz, 666)
    eq_(page2.bar, 2)

def test_annotations():
    load_xml("AnnotationTest.xml")
    page = LIB.get("annotationTest")
    eq_(page.foo, 4)
    eq_(page.bar, 3)
    eq_(page.primitives, None)
