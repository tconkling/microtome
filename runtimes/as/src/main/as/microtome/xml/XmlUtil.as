//
// microtome

package microtome.xml {

import microtome.core.ReadableObject;
import microtome.core.WritableObject;

public class XmlUtil
{
    public static function createReader (xml :XML) :ReadableObject {
        return new XmlElement(xml);
    }

    /** Creates ReadableObjects from a Vector or Array of XML objects */
    public static function createReaders (xmls :*) :Vector.<ReadableObject> {
        const data :Vector.<ReadableObject> = new <ReadableObject>[];
        for each (var xml :XML in xmls) {
            data.push(new XmlElement(xml));
        }
        return data;
    }

    /** Creates a WritableObject that will write to the given XML object */
    public static function createWriter (xml :XML) :WritableObject {
        return new XmlElement(xml);
    }
}
}
