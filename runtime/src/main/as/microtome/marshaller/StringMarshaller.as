//
// microtome

package microtome.marshaller {

import microtome.core.DataElement;
import microtome.Library;
import microtome.core.TypeInfo;

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
