//
// microtome-test

package microtome.test {

import flash.display.Sprite;
import flash.events.Event;
import flash.utils.ByteArray;

import microtome.Tome;
import microtome.xml.XmlLibrary;

public class MicrotomeTest extends Sprite
{
    public function MicrotomeTest() {
        addEventListener(Event.ADDED_TO_STAGE, function (..._) :void {
            _library.registerPageClasses(
                PrimitivePage,
                NestedPage,
                RefPage);

            testPrimitives();
            testTome();
            testNested();
            testRefs();
        });
    }

    protected function testPrimitives () :void {
        _library.loadXmlDocs([ newXml(PRIMITIVE_TEST_XML) ]);

        var page :PrimitivePage = _library["primitiveTest"];
        assert(page != null);
        assertEquals(page.foo, true);
        assertEquals(page.bar, 2);
        assertEqualsWithAccuracy(page.baz, 3.1415, EPSILON);
        _library.removeAllItems();
    }

    protected function testTome () :void {
        _library.loadXmlDocs([ newXml(TOME_TEST_XML) ]);

        var tome :Tome = _library["tomeTest"];
        assertEquals(tome.size, 2);
        _library.removeAllItems();
    }

    protected function testNested () :void {
        _library.loadXmlDocs([ newXml(NESTED_TEST_XML) ]);

        var page :NestedPage = _library["nestedTest"];
        assertEquals(page.nested.foo, true);
        assertEquals(page.nested.bar, 2);
        assertEqualsWithAccuracy(page.nested.baz, 3.1415, EPSILON);
        _library.removeAllItems();
    }

    protected function testRefs () :void {
        _library.loadXmlDocs([ newXml(REF_TEST_XML), newXml(TOME_TEST_XML) ]);

        var page :RefPage = _library["refTest"];
        assert(page.nested != null);
        assertEquals(page.nested.foo, true);
        assertEquals(page.nested.bar, 2);
        assertEqualsWithAccuracy(page.nested.baz, 3.1415, EPSILON);
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

    protected static const EPSILON :Number = 0.0001;
}
}
