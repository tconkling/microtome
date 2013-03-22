//
// microtome

package microtome.marshaller {

import microtome.core.DataElement;
import microtome.core.DataReader;
import microtome.core.LibraryManager;
import microtome.core.TypeInfo;

public class StringMarshaller extends ObjectMarshallerBase
{
    override public function get valueClass () :Class {
        return String;
    }

    override public function readObject (data :DataElement, type :TypeInfo, mgr :LibraryManager) :* {
        return DataReader.withData(data).requireAttribute("value");
    }

    override public function cloneObject (data :Object, type :TypeInfo, mgr :LibraryManager) :Object {
        // Strings don't need cloning
        return data;
    }
}
}
