//
// microtome-test

package microtome.test {

import flash.display.Sprite;
import flash.utils.ByteArray;

import microtome.Library;
import microtome.Microtome;
import microtome.MicrotomeCtx;
import microtome.Tome;
import microtome.error.MicrotomeError;
import microtome.xml.XmlUtil;

public class MicrotomeTest extends Sprite
{
    public function MicrotomeTest() {
        _ctx.registerTomeClasses(MicrotomeTypes.tomeClasses);

        testPrimitives();
        testObjects();
        testNested();
        testRefs();
        testTemplates();
        testAnnotations();
        testGeneric();
        testFailures();

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

        var tome :PrimitiveTome = _library.getTome("primitiveTest");
        assert(tome != null);
        assertEquals(tome.foo, true);
        assertEquals(tome.bar, 2);
        assertEqualsWithAccuracy(tome.baz, 3.1415, EPSILON);
        _library.removeAllTomes();
    }

    protected function testObjects () :void {
        loadXml(OBJECT_TEST_XML);

        var tome :ObjectTome = _library.getTome("objectTest");
        assertEquals(tome.foo, "foo");
        _library.removeAllTomes();
    }

    protected function testNested () :void {
        loadXml(NESTED_TEST_XML);

        var tome :NestedTome = _library.getTome("nestedTest");
        assertEquals(tome.nested.foo, true);
        assertEquals(tome.nested.bar, 2);
        assertEqualsWithAccuracy(tome.nested.baz, 3.1415, EPSILON);
        _library.removeAllTomes();
    }

    protected function testRefs () :void {
        loadXml(REF_TEST_XML, TOME_TEST_XML);

        var tome :RefTome = _library.getTome("refTest");
        assert(tome.nested != null);
        assertEquals(tome.nested.foo, true);
        assertEquals(tome.nested.bar, 2);
        assertEqualsWithAccuracy(tome.nested.baz, 3.1415, EPSILON);
        _library.removeAllTomes();
    }

    protected function testTemplates () :void {
        loadXml(TEMPLATE_TEST_XML);

        var tome :PrimitiveTome = _library.getTome("templateTest1");
        assertEquals(tome.foo, true);
        assertEquals(tome.bar, 2);
        assertEqualsWithAccuracy(tome.baz, 3.1415, EPSILON);

        tome = _library.getTome("templateTest2");
        assertEquals(tome.bar, 2);
        assertEqualsWithAccuracy(tome.baz, 666.0, EPSILON);

        var nested :NestedTome = _library.getTome("templateTest4");
        assert(nested.nested != null);
        assertEqualsWithAccuracy(nested.nested.baz, 3.1415, EPSILON);
        assertEquals(nested.children.length, 3);
        assert(nested.hasChild("additionalTome1"));
        assert(nested.hasChild("additionalTome2"));

        // ensure we didn't just do a shallow copy
        var nestedTmpl :NestedTome = _library.getTome("templateTest3");
        assert(nestedTmpl.requireChild("additionalTome1") != nested.requireChild("additionalTome1"));

        _library.removeAllTomes();
    }

    protected function testAnnotations () :void {
        loadXml(ANNOTATION_TEST_XML);

        var tome :AnnotationTome = _library.getTome("annotationTest");
        assertEquals(tome.foo, 4);
        assertEquals(tome.bar, 3);
        assertEquals(tome.primitives, null);

        _library.removeAllTomes();
    }

    protected function testGeneric () :void {
        loadXml(GENERIC_NESTED_TEST_XML);

        var tome :Tome = _library.getTome("genericTest.generic");
        assertEquals(tome.children.length, 2);

        var primitive :PrimitiveTome = tome.getChild("primitive");
        assertEquals(primitive.foo, true);
        assertEquals(primitive.bar, 2);
        assertEqualsWithAccuracy(primitive.baz, 3.1415, EPSILON);

        var anno :AnnotationTome = tome.getChild("annotations");
        assertEquals(anno.foo, 4);
        assertEquals(anno.bar, 3);
        assertEquals(anno.primitives, null);

        _library.removeAllTomes();
    }

    protected function testFailures () :void {
        assertThrows(function () :void {
            loadXml(DUPLICATE_NAME_FAILURE_XML);
        }, MicrotomeError, "Duplicate tome names should not be allowed");
        _library.removeAllTomes();
    }

    protected const _library :Library = new Library();
    protected const _ctx :MicrotomeCtx = Microtome.createCtx();

    [Embed(source="../../../../../../../microtome/test/data/PrimitiveTest.xml", mimeType="application/octet-stream")]
    private static const PRIMITIVE_TEST_XML :Class;

    [Embed(source="../../../../../../../microtome/test/data/ObjectTest.xml", mimeType="application/octet-stream")]
    private static const OBJECT_TEST_XML :Class;

    [Embed(source="../../../../../../../microtome/test/data/TomeTest.xml", mimeType="application/octet-stream")]
    private static const TOME_TEST_XML :Class;

    [Embed(source="../../../../../../../microtome/test/data/NestedTest.xml", mimeType="application/octet-stream")]
    private static const NESTED_TEST_XML :Class;

    [Embed(source="../../../../../../../microtome/test/data/RefTest.xml", mimeType="application/octet-stream")]
    private static const REF_TEST_XML :Class;

    [Embed(source="../../../../../../../microtome/test/data/TemplateTest.xml", mimeType="application/octet-stream")]
    private static const TEMPLATE_TEST_XML :Class;

    [Embed(source="../../../../../../../microtome/test/data/AnnotationTest.xml", mimeType="application/octet-stream")]
    private static const ANNOTATION_TEST_XML :Class;

    [Embed(source="../../../../../../../microtome/test/data/GenericNestedTest.xml", mimeType="application/octet-stream")]
    private static const GENERIC_NESTED_TEST_XML :Class;

    [Embed(source="../../../../../../../microtome/test/data/DuplicateNameFailure.xml", mimeType="application/octet-stream")]
    private static const DUPLICATE_NAME_FAILURE_XML :Class;

    protected static const EPSILON :Number = 0.0001;
}
}
