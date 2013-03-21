//
// microtome-test

package microtome.test {

import flash.display.Sprite;
import flash.utils.ByteArray;

import microtome.Library;
import microtome.Microtome;
import microtome.MicrotomeCtx;
import microtome.Tome;
import microtome.xml.MicrotomeXml;

public class MicrotomeTest extends Sprite
{
    public function MicrotomeTest() {
        _ctx.registerPageClasses(MicrotomePages.pageClasses);

        testPrimitives();
        testObjects();
        testTome();
        testNested();
        testRefs();
        testTemplates();
        testAnnotations();

        trace("All tests passed");
    }

    protected function testPrimitives () :void {
        MicrotomeXml.loadXmlDocs(_ctx, new <XML>[ newXml(PRIMITIVE_TEST_XML) ]);

        var page :PrimitivePage = _library.getItem("primitiveTest");
        assert(page != null);
        assertEquals(page.foo, true);
        assertEquals(page.bar, 2);
        assertEqualsWithAccuracy(page.baz, 3.1415, EPSILON);
        _library.removeAllItems();
    }

    protected function testObjects () :void {
        MicrotomeXml.loadXmlDocs(_ctx, new <XML>[ newXml(OBJECT_TEST_XML) ]);

        var page :ObjectPage = _library.getItem("objectTest");
        assertEquals(page.foo, "foo");
        _library.removeAllItems();
    }

    protected function testTome () :void {
        MicrotomeXml.loadXmlDocs(_ctx, new <XML>[ newXml(TOME_TEST_XML) ]);

        var tome :Tome = _library.getItem("tomeTest");
        assertEquals(tome.size, 2);
        _library.removeAllItems();
    }

    protected function testNested () :void {
        MicrotomeXml.loadXmlDocs(_ctx, new <XML>[ newXml(NESTED_TEST_XML) ]);

        var page :NestedPage = _library.getItem("nestedTest");
        assertEquals(page.nested.foo, true);
        assertEquals(page.nested.bar, 2);
        assertEqualsWithAccuracy(page.nested.baz, 3.1415, EPSILON);
        _library.removeAllItems();
    }

    protected function testRefs () :void {
        MicrotomeXml.loadXmlDocs(_ctx, new <XML>[ newXml(REF_TEST_XML), newXml(TOME_TEST_XML) ]);

        var page :RefPage = _library.getItem("refTest");
        assert(page.nested != null);
        assertEquals(page.nested.foo, true);
        assertEquals(page.nested.bar, 2);
        assertEqualsWithAccuracy(page.nested.baz, 3.1415, EPSILON);
        _library.removeAllItems();
    }

    protected function testTemplates () :void {
        MicrotomeXml.loadXmlDocs(_ctx, new <XML>[ newXml(TEMPLATE_TEST_XML) ]);

        var page :PrimitivePage = _library.getItem("test1");
        assertEquals(page.foo, true);
        assertEquals(page.bar, 2);
        assertEqualsWithAccuracy(page.baz, 3.1415, EPSILON);

        page = _library.getItem("test2");
        assertEqualsWithAccuracy(page.baz, 666.0, EPSILON);

        _library.removeAllItems();
    }

    protected function testAnnotations () :void {
        MicrotomeXml.loadXmlDocs(_ctx, new <XML>[ newXml(ANNOTATION_TEST_XML) ]);

        var page :AnnotationPage = _library.getItem("test");
        assertEquals(page.foo, 4);
        assertEquals(page.bar, 3);
        assertEquals(page.primitives, null);

        _library.removeAllItems();
    }

    protected static function newXml (clazz :Class) :XML {
        var ba :ByteArray = new clazz;
        return new XML(ba.readUTFBytes(ba.length));
    }

    protected var _library :Library = new Library();
    protected var _ctx :MicrotomeCtx = Microtome.createCtx(_library);

    [Embed(source="../../../resources/PrimitiveTest.xml", mimeType="application/octet-stream")]
    private static const PRIMITIVE_TEST_XML :Class;

    [Embed(source="../../../resources/ObjectTest.xml", mimeType="application/octet-stream")]
    private static const OBJECT_TEST_XML :Class;

    [Embed(source="../../../resources/TomeTest.xml", mimeType="application/octet-stream")]
    private static const TOME_TEST_XML :Class;

    [Embed(source="../../../resources/NestedTest.xml", mimeType="application/octet-stream")]
    private static const NESTED_TEST_XML :Class;

    [Embed(source="../../../resources/RefTest.xml", mimeType="application/octet-stream")]
    private static const REF_TEST_XML :Class;

    [Embed(source="../../../resources/TemplateTest.xml", mimeType="application/octet-stream")]
    private static const TEMPLATE_TEST_XML :Class;

    [Embed(source="../../../resources/AnnotationTest.xml", mimeType="application/octet-stream")]
    private static const ANNOTATION_TEST_XML :Class;

    protected static const EPSILON :Number = 0.0001;
}
}
