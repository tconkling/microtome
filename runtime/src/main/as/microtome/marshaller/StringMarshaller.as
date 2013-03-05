//
// microtome

package microtome.marshaller {

import microtome.LibraryLoader;
import microtome.core.DataElement;
import microtome.core.DataReader;
import microtome.core.LibraryItem;
import microtome.core.TypeInfo;

public class StringMarshaller extends ObjectMarshallerBase
{
    override public function get valueClass () :Class {
        return String;
    }

    override public function loadObject (parent :LibraryItem, data :DataElement, type :TypeInfo,
        loader :LibraryLoader) :* {

        return DataReader.withData(data).requireAttribute("value");
    }
}
}
