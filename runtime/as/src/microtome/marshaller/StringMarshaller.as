//
// microtome

package microtome.marshaller {

import microtome.DataElement;
import microtome.Library;
import microtome.ValueType;

public class StringMarshaller extends ObjectMarshallerBase
{
    override public function get valueType () :Class {
        return String;
    }

    override public function loadObject (data :DataElement, type:ValueType, library:Library):* {
        var val :String = data.value;
        // handle the empty string
        if (val == null) {
            val = "";
        }
        return val;
    }
}
}
