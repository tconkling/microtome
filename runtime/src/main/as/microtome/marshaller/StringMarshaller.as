//
// microtome

package microtome.marshaller {

import microtome.DataElement;
import microtome.Library;
import microtome.TypeInfo;

public class StringMarshaller extends ObjectMarshallerBase
{
    override public function get valueClass () :Class {
        return String;
    }

    override public function loadObject (data :DataElement, type:TypeInfo, library:Library):* {
        var val :String = data.value;
        // handle the empty string
        if (val == null) {
            val = "";
        }
        return val;
    }
}
}
