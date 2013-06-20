//
// microtome

package microtome.xml {

import microtome.core.ReadableObject;
import microtome.core.WritableObject;

public class XmlUtil
{
    /** Creates ReadableObjects from a Vector of XML objects */
    public static function createReaders (xmlDocs :Vector.<XML>) :Vector.<ReadableObject> {
        const data :Vector.<ReadableObject> = new <ReadableObject>[];
        for each (var xml :XML in xmlDocs) {
            data.push(new XmlElement(xml, false));
        }
        return data;
    }

    /** Creates a WritableObject that will write to the given XML object */
    public static function createWriter (xml :XML) :WritableObject {
        return new XmlElement(xml, false);
    }
}
}
