//
// microtome-test

package microtome.test {

import flash.display.Sprite;
import flash.utils.ByteArray;

import microtome.Library;
import microtome.Microtome;
import microtome.MicrotomeCtx;
import microtome.Tome;
import microtome.json.JsonUtil;
import microtome.xml.XmlUtil;

public class MicrotomeTest extends Sprite
{
    public function MicrotomeTest() {
        _ctx.registerPageClasses(MicrotomePages.pageClasses);

        for each (var test :String in ["XML", "JSON"]) {
            trace("Testing format [" + test + "]");
            _library.removeAllItems();
            _test = test;

            testPrimitives();
            testObjects();
            testTome();
            testNested();
            testRefs();
            testTemplates();
            testAnnotations();
        }

        trace("All tests passed");
    }

    protected function load (...classes) :void {
        if (_test == "XML") {
            const xmlDocs :Vector.<XML> = new <XML>[];
            for each (var clazz :String in classes) {
                var ba :ByteArray = new MicrotomeTest[clazz + "_XML"]();
                xmlDocs.push(new XML(ba.readUTFBytes(ba.length)));
            }
            _ctx.load(_library, XmlUtil.createReaders(xmlDocs));

        } else if (_test == "JSON") {
            const jsons :Vector.<Object> = new <Object>[];
            for each (clazz in classes) {
                ba = new MicrotomeTest[clazz + "_JSON"]();
                jsons.push(JSON.parse(ba.readUTFBytes(ba.length)));
            }
            _ctx.load(_library, JsonUtil.createReaders(jsons));
        }
    }

    protected function testPrimitives () :void {
        load("PRIMITIVE_TEST");

        var page :PrimitivePage = _library.getItem("primitiveTest");
        assert(page != null);
        assertEquals(page.foo, true);
        assertEquals(page.bar, 2);
        assertEqualsWithAccuracy(page.baz, 3.1415, EPSILON);
        _library.removeAllItems();
    }

    protected function testObjects () :void {
        load("OBJECT_TEST");

        var page :ObjectPage = _library.getItem("objectTest");
        assertEquals(page.foo, "foo");
        _library.removeAllItems();
    }

    protected function testTome () :void {
        load("TOME_TEST");

        var tome :Tome = _library.getItem("tomeTest");
        assertEquals(tome.length, 2);
        _library.removeAllItems();
    }

    protected function testNested () :void {
        load("NESTED_TEST");

        var page :NestedPage = _library.getItem("nestedTest");
        assertEquals(page.nested.foo, true);
        assertEquals(page.nested.bar, 2);
        assertEqualsWithAccuracy(page.nested.baz, 3.1415, EPSILON);
        _library.removeAllItems();
    }

    protected function testRefs () :void {
        load("REF_TEST", "TOME_TEST");

        var page :RefPage = _library.getItem("refTest");
        assert(page.nested != null);
        assertEquals(page.nested.foo, true);
        assertEquals(page.nested.bar, 2);
        assertEqualsWithAccuracy(page.nested.baz, 3.1415, EPSILON);
        _library.removeAllItems();
    }

    protected function testTemplates () :void {
        load("TEMPLATE_TEST");

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
        load("ANNOTATION_TEST");

        var page :AnnotationPage = _library.getItem("annotationTest");
        assertEquals(page.foo, 4);
        assertEquals(page.bar, 3);
        assertEquals(page.primitives, null);

        _library.removeAllItems();
    }

    protected const _library :Library = new Library();
    protected const _ctx :MicrotomeCtx = Microtome.createCtx();

    protected var _test :String;

    [Embed(source="../../../../../../microtome/test/data/PrimitiveTest.xml", mimeType="application/octet-stream")]
    private static const PRIMITIVE_TEST_XML :Class;
    [Embed(source="../../../../../../microtome/test/data/PrimitiveTest.json", mimeType="application/octet-stream")]
    private static const PRIMITIVE_TEST_JSON :Class;

    [Embed(source="../../../../../../microtome/test/data/ObjectTest.xml", mimeType="application/octet-stream")]
    private static const OBJECT_TEST_XML :Class;
    [Embed(source="../../../../../../microtome/test/data/ObjectTest.json", mimeType="application/octet-stream")]
    private static const OBJECT_TEST_JSON :Class;

    [Embed(source="../../../../../../microtome/test/data/TomeTest.xml", mimeType="application/octet-stream")]
    private static const TOME_TEST_XML :Class;
    [Embed(source="../../../../../../microtome/test/data/TomeTest.json", mimeType="application/octet-stream")]
    private static const TOME_TEST_JSON :Class;

    [Embed(source="../../../../../../microtome/test/data/NestedTest.xml", mimeType="application/octet-stream")]
    private static const NESTED_TEST_XML :Class;
    [Embed(source="../../../../../../microtome/test/data/NestedTest.json", mimeType="application/octet-stream")]
    private static const NESTED_TEST_JSON :Class;

    [Embed(source="../../../../../../microtome/test/data/RefTest.xml", mimeType="application/octet-stream")]
    private static const REF_TEST_XML :Class;
    [Embed(source="../../../../../../microtome/test/data/RefTest.json", mimeType="application/octet-stream")]
    private static const REF_TEST_JSON :Class;

    [Embed(source="../../../../../../microtome/test/data/TemplateTest.xml", mimeType="application/octet-stream")]
    private static const TEMPLATE_TEST_XML :Class;
    [Embed(source="../../../../../../microtome/test/data/TemplateTest.json", mimeType="application/octet-stream")]
    private static const TEMPLATE_TEST_JSON :Class;

    [Embed(source="../../../../../../microtome/test/data/AnnotationTest.xml", mimeType="application/octet-stream")]
    private static const ANNOTATION_TEST_XML :Class;
    [Embed(source="../../../../../../microtome/test/data/AnnotationTest.json", mimeType="application/octet-stream")]
    private static const ANNOTATION_TEST_JSON :Class;

    protected static const EPSILON :Number = 0.0001;
}
}
