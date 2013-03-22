//
// microtome

package microtome.marshaller {

import microtome.core.DataReader;
import microtome.core.MicrotomeMgr;
import microtome.core.TypeInfo;
import microtome.core.WritableObject;

public class StringMarshaller extends ObjectMarshallerBase
{
    override public function get valueClass () :Class {
        return String;
    }

    override public function readObject (mgr :MicrotomeMgr, reader :DataReader, type :TypeInfo) :* {
        return reader.requireString(VALUE);
    }

    override public function writeObject (mgr :MicrotomeMgr, writer :WritableObject, obj :*, type :TypeInfo) :void {
        writer.writeString(VALUE, obj as String);
    }

    override public function cloneObject (mgr :MicrotomeMgr, data :Object, type :TypeInfo) :Object {
        // Strings don't need cloning
        return data;
    }

    protected static const VALUE :String = "value";
}
}
