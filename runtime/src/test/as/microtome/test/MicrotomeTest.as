//
// microtome-test

package microtome.test {

import flash.display.Sprite;
import flash.utils.ByteArray;

import microtome.Tome;
import microtome.xml.XmlLibrary;

public class MicrotomeTest extends Sprite
{
    public function MicrotomeTest() {
        _library.registerPageClasses(new <Class>[
            PrimitivePage,
            NestedPage,
            RefPage ]);

        testPrimitives();
        testTome();
        testNested();
        testRefs();
        testTemplates();

        trace("All tests passed");
    }

    protected function testPrimitives () :void {
        _library.loadXmlDocs(new <XML>[ newXml(PRIMITIVE_TEST_XML) ]);

        var page :PrimitivePage = _library.getItem("primitiveTest");
        assert(page != null);
        assertEquals(page.foo, true);
        assertEquals(page.bar, 2);
        assertEqualsWithAccuracy(page.baz, 3.1415, EPSILON);
        _library.removeAllItems();
    }

    protected function testTome () :void {
        _library.loadXmlDocs(new <XML>[ newXml(TOME_TEST_XML) ]);

        var tome :Tome = _library.getItem("tomeTest");
        assertEquals(tome.size, 2);
        _library.removeAllItems();
    }

    protected function testNested () :void {
        _library.loadXmlDocs(new <XML>[ newXml(NESTED_TEST_XML) ]);

        var page :NestedPage = _library.getItem("nestedTest");
        assertEquals(page.nested.foo, true);
        assertEquals(page.nested.bar, 2);
        assertEqualsWithAccuracy(page.nested.baz, 3.1415, EPSILON);
        _library.removeAllItems();
    }

    protected function testRefs () :void {
        _library.loadXmlDocs(new <XML>[ newXml(REF_TEST_XML), newXml(TOME_TEST_XML) ]);

        var page :RefPage = _library.getItem("refTest");
        assert(page.nested != null);
        assertEquals(page.nested.foo, true);
        assertEquals(page.nested.bar, 2);
        assertEqualsWithAccuracy(page.nested.baz, 3.1415, EPSILON);
        _library.removeAllItems();
    }

    protected function testTemplates () :void {
        _library.loadXmlDocs(new <XML>[ newXml(TEMPLATE_TEST_XML) ]);

        var page :PrimitivePage = _library.getItem("test1");
        assertEquals(page.foo, true);
        assertEquals(page.bar, 2);
        assertEqualsWithAccuracy(page.baz, 3.1415, EPSILON);

        page = _library.getItem("test2");
        assertEqualsWithAccuracy(page.baz, 666.0, EPSILON);

        _library.removeAllItems();
    }

    protected static function newXml (clazz :Class) :XML {
        var ba :ByteArray = new clazz;
        return new XML(ba.readUTFBytes(ba.length));
    }

    protected var _library :XmlLibrary = new XmlLibrary();

    [Embed(source="../../../resources/PrimitiveTest.xml", mimeType="application/octet-stream")]
    private static const PRIMITIVE_TEST_XML :Class;

    [Embed(source="../../../resources/TomeTest.xml", mimeType="application/octet-stream")]
    private static const TOME_TEST_XML :Class;

    [Embed(source="../../../resources/NestedTest.xml", mimeType="application/octet-stream")]
    private static const NESTED_TEST_XML :Class;

    [Embed(source="../../../resources/RefTest.xml", mimeType="application/octet-stream")]
    private static const REF_TEST_XML :Class;

    [Embed(source="../../../resources/TemplateTest.xml", mimeType="application/octet-stream")]
    private static const TEMPLATE_TEST_XML :Class;

    protected static const EPSILON :Number = 0.0001;
}
}
