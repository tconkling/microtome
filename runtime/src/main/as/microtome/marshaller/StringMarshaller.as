//
// microtome

package microtome.marshaller {

import microtome.core.DataReader;
import microtome.core.MicrotomeMgr;
import microtome.core.TypeInfo;

public class StringMarshaller extends ObjectMarshallerBase
{
    override public function get valueClass () :Class {
        return String;
    }

    override public function readObject (mgr :MicrotomeMgr, reader :DataReader, type :TypeInfo) :* {
        return reader.requireString("value");
    }

    override public function cloneObject (mgr :MicrotomeMgr, data :Object, type :TypeInfo) :Object {
        // Strings don't need cloning
        return data;
    }
}
}
