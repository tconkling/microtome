//
// microtome-test

package microtome.test {

import flash.display.Sprite;
import flash.events.Event;
import flash.utils.ByteArray;

import microtome.xml.XmlLibrary;

public class MicrotomeTest extends Sprite
{
    public function MicrotomeTest() {
        addEventListener(Event.ADDED_TO_STAGE, function (..._) :void {
            _library.registerPageClasses(PrimitivePage);
            testPrimitives();
        });
    }

    protected function testPrimitives () :void {
        _library.loadXmlDocs([ newXml(PRIMITIVE_TEST_XML) ]);
        var page :PrimitivePage = _library["primitiveTest"];
        assert(page != null);
        assert(page.foo == true);
        assert(page.bar == 2);
    }

    protected static function newXml (clazz :Class) :XML {
        var ba :ByteArray = new clazz;
        return new XML(ba.readUTFBytes(ba.length));
    }

    protected var _library :XmlLibrary = new XmlLibrary();

    [Embed(source="../../../resources/PrimitiveTest.xml", mimeType="application/octet-stream")]
    private static const PRIMITIVE_TEST_XML :Class;
}
}
