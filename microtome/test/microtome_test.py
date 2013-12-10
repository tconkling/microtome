#
# microtome

import os.path
import logging

import xml.etree.ElementTree as ElementTree

from nose.tools import *

import microtome.codegen.spec as s
from microtome.codegen.parser import Parser
import microtome.xml_support as xml_support
import microtome.ctx
from microtome.library import Library
import microtome.test.MicrotomeTypes as MicrotomeTypes

CTX = microtome.ctx.create_ctx()
LOG = logging.getLogger(__name__)

def resource(name):
    return os.path.join(os.path.dirname(os.path.abspath(__file__)), "data", name)

def load_xml(lib, *filenames):
    CTX.load(lib, xml_support.readers_from_files(*[resource(name) for name in filenames]))
    return lib

def setup_tests():
    CTX.register_tome_classes(MicrotomeTypes.get_tome_classes())

def test_parser():
    test_input = '''
        namespace com.test;
        // comment 1
        Tome MyTome extends AnotherTome {
            bool foo;   // comment 2
            int bar;
            float baz (min = -3.0);
            string str (nullable, text="as df");

            Tome theTome;
            TomeRef<ThirdPage> theRef;
        }

        Tome Tome2 {
            string qwert;
        }
        '''
    tome_specs = Parser(test_input).parse()
    eq_(len(tome_specs), 2)
    tome_spec = tome_specs[0]
    eq_(tome_spec.name, "MyTome")
    eq_(tome_spec.namespace, "com.test")
    eq_(tome_spec.superclass, "com.test.AnotherTome")

    foo = tome_spec.props[0]
    eq_(foo.name, "foo")
    eq_(foo.type.name, s.BoolType)
    eq_(foo.type.subtype, None)

    baz = tome_spec.props[2]
    eq_(baz.annotations[0].name, "min")
    eq_(baz.annotations[0].value, -3)

    theTome = tome_spec.props[4]
    eq_(theTome.type.name, "Tome")
    eq_(theTome.type.subtype, None)

def test_primitives():
    lib = load_xml(Library(), "PrimitiveTest.xml")
    tome = lib.get("primitiveTest")
    eq_(tome.foo, True)
    eq_(tome.bar, 2)
    eq_(tome.baz, 3.1415)

def test_object():
    lib = load_xml(Library(), "ObjectTest.xml")
    eq_(lib.get("objectTest").foo, "foo")

def test_nested():
    lib = load_xml(Library(), "NestedTest.xml")
    nested = lib.get_tome_with_qualified_name("nestedTest.nested")
    assert_is_not_none(nested)
    eq_(nested.baz, 3.1415)

def test_list():
    lib = load_xml(Library(), "ListTest.xml")
    tome = lib.get("listTest")
    eq_(len(tome.kids), 2)
    eq_(tome.kids[1].bar, 666)

def test_ref():
    lib = load_xml(Library(), "TomeTest.xml", "RefTest.xml")
    ref = lib.get("refTest")
    eq_(ref.nested.baz, 3.1415)
    tomeTome = lib.get("tomeTest")
    eq_(len(tomeTome), 2)

def test_templates():
    lib = load_xml(Library(), "TemplateTest.xml")
    tome1 = lib.get("templateTest1")
    tome2 = lib.get("templateTest2")
    eq_(tome1.foo, True)
    eq_(tome2.baz, 666)
    eq_(tome2.bar, 2)

    nested = lib.get("templateTest4")
    assert_is_not_none(nested.nested)
    eq_(nested.nested.baz, 3.1415)
    eq_(len(nested.values()), 3)
    ok_("additionalTome1" in nested)
    ok_("additionalTome2" in nested)

    # ensure we didn't just do a shallow copy
    nestedTmpl = lib.get("templateTest3")
    assert_not_equal(nestedTmpl.get("additionalTome1"), nested.get("additionalTome1"))

def test_annotations():
    lib = load_xml(Library(), "AnnotationTest.xml")
    tome = lib.get("annotationTest")
    eq_(tome.foo, 4)
    eq_(tome.bar, 3)
    eq_(tome.primitives, None)

def test_generic():
    lib = load_xml(Library(), "GenericNestedTest.xml")
    tome = lib.get_tome_with_qualified_name("genericTest.generic")
    eq_(len(tome), 2)

    primitive = tome.get("primitive")
    eq_(primitive.foo, True)
    eq_(primitive.bar, 2)
    eq_(primitive.baz, 3.1415)

    anno = tome.get("annotations")
    eq_(anno.foo, 4)
    eq_(anno.bar, 3)
    eq_(anno.primitives, None)


def test_writer():
    # load everything
    lib = load_xml(Library(), "PrimitiveTest.xml", "ObjectTest.xml", "NestedTest.xml",
        "ListTest.xml", "TomeTest.xml", "RefTest.xml", "TemplateTest.xml", "AnnotationTest.xml",
        "GenericNestedTest.xml")

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
