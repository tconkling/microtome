//
// microtome-test

package microtome.test {

import flash.display.Sprite;
import flash.utils.ByteArray;

import microtome.Library;
import microtome.Microtome;
import microtome.MicrotomeCtx;
import microtome.Tome;
import microtome.xml.XmlUtil;

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

    protected function loadXml (...classes) :void {
        const xmlDocs :Vector.<XML> = new <XML>[];
        for each (var clazz :Class in classes) {
            var ba :ByteArray = new clazz();
            xmlDocs.push(new XML(ba.readUTFBytes(ba.length)));
        }

        _ctx.load(_library, XmlUtil.createReaders(xmlDocs));
    }

    protected function testPrimitives () :void {
        loadXml(PRIMITIVE_TEST_XML);

        var page :PrimitivePage = _library.getItem("primitiveTest");
        assert(page != null);
        assertEquals(page.foo, true);
        assertEquals(page.bar, 2);
        assertEqualsWithAccuracy(page.baz, 3.1415, EPSILON);
        _library.removeAllItems();
    }

    protected function testObjects () :void {
        loadXml(OBJECT_TEST_XML);

        var page :ObjectPage = _library.getItem("objectTest");
        assertEquals(page.foo, "foo");
        _library.removeAllItems();
    }

    protected function testTome () :void {
        loadXml(TOME_TEST_XML);

        var tome :Tome = _library.getItem("tomeTest");
        assertEquals(tome.length, 2);
        _library.removeAllItems();
    }

    protected function testNested () :void {
        loadXml(NESTED_TEST_XML);

        var page :NestedPage = _library.getItem("nestedTest");
        assertEquals(page.nested.foo, true);
        assertEquals(page.nested.bar, 2);
        assertEqualsWithAccuracy(page.nested.baz, 3.1415, EPSILON);
        _library.removeAllItems();
    }

    protected function testRefs () :void {
        loadXml(REF_TEST_XML, TOME_TEST_XML);

        var page :RefPage = _library.getItem("refTest");
        assert(page.nested != null);
        assertEquals(page.nested.foo, true);
        assertEquals(page.nested.bar, 2);
        assertEqualsWithAccuracy(page.nested.baz, 3.1415, EPSILON);
        _library.removeAllItems();
    }

    protected function testTemplates () :void {
        loadXml(TEMPLATE_TEST_XML);

        var page :PrimitivePage = _library.getItem("templateTest1");
        assertEquals(page.foo, true);
        assertEquals(page.bar, 2);
        assertEqualsWithAccuracy(page.baz, 3.1415, EPSILON);

        page = _library.getItem("templateTest2");
        assertEquals(page.bar, 2);
        assertEqualsWithAccuracy(page.baz, 666.0, EPSILON);

        _library.removeAllItems();
    }

    protected function testAnnotations () :void {
        loadXml(ANNOTATION_TEST_XML);

        var page :AnnotationPage = _library.getItem("annotationTest");
        assertEquals(page.foo, 4);
        assertEquals(page.bar, 3);
        assertEquals(page.primitives, null);

        _library.removeAllItems();
    }

    protected const _library :Library = new Library();
    protected const _ctx :MicrotomeCtx = Microtome.createCtx();

    [Embed(source="../../../../../../microtome/test/data/PrimitiveTest.xml", mimeType="application/octet-stream")]
    private static const PRIMITIVE_TEST_XML :Class;

    [Embed(source="../../../../../../microtome/test/data/ObjectTest.xml", mimeType="application/octet-stream")]
    private static const OBJECT_TEST_XML :Class;

    [Embed(source="../../../../../../microtome/test/data/TomeTest.xml", mimeType="application/octet-stream")]
    private static const TOME_TEST_XML :Class;

    [Embed(source="../../../../../../microtome/test/data/NestedTest.xml", mimeType="application/octet-stream")]
    private static const NESTED_TEST_XML :Class;

    [Embed(source="../../../../../../microtome/test/data/RefTest.xml", mimeType="application/octet-stream")]
    private static const REF_TEST_XML :Class;

    [Embed(source="../../../../../../microtome/test/data/TemplateTest.xml", mimeType="application/octet-stream")]
    private static const TEMPLATE_TEST_XML :Class;

    [Embed(source="../../../../../../microtome/test/data/AnnotationTest.xml", mimeType="application/octet-stream")]
    private static const ANNOTATION_TEST_XML :Class;

    protected static const EPSILON :Number = 0.0001;
}
}
