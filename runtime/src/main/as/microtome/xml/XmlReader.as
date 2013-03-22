//
// microtome

package microtome.xml {

import microtome.core.DataElement;

public class XmlReader
{
    public static function xmlToDataElements (xmlDocs :Vector.<XML>) :Vector.<DataElement> {
        const data :Vector.<DataElement> = new <DataElement>[];
        for each (var xml :XML in xmlDocs) {
            data.push(new XmlDataElement(xml));
        }
        return data;
    }
}
}
