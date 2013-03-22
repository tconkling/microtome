//
// microtome

package microtome.xml {

import microtome.core.ReadableObject;

public class XmlUtil
{
    /** Creates ReadableObjects from a Vector of XML objects */
    public static function createReaders (xmlDocs :Vector.<XML>) :Vector.<ReadableObject> {
        const data :Vector.<ReadableObject> = new <ReadableObject>[];
        for each (var xml :XML in xmlDocs) {
            data.push(new XmlElement(xml));
        }
        return data;
    }
}
}
