//
// microtome

package microtome.marshaller {

import microtome.Library;
import microtome.core.DataElement;
import microtome.core.DataReader;
import microtome.core.TypeInfo;

public class StringMarshaller extends ObjectMarshallerBase
{
    override public function get valueClass () :Class {
        return String;
    }

    override public function loadObject (data :DataElement, type:TypeInfo, library:Library):* {
        return DataReader.withData(data).requireAttribute("value");
    }
}
}
