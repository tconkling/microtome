//
// microtome

package microtome.marshaller {

import microtome.core.Annotatable;
import microtome.core.DataReader;
import microtome.core.Defs;
import microtome.core.MicrotomeMgr;
import microtome.core.TypeInfo;
import microtome.core.WritableObject;

public class StringMarshaller extends ObjectMarshaller
{
    public function StringMarshaller () {
        super(true);
    }

    override public function get valueClass () :Class {
        return String;
    }

    override public function readValue (mgr :MicrotomeMgr, reader :DataReader, name :String, type :TypeInfo) :* {
        return reader.requireString(name);
    }

    override public function readDefault (mgr :MicrotomeMgr, type :TypeInfo, anno :Annotatable) :* {
        return anno.stringAnnotation(Defs.DEFAULT_ANNOTATION, "");
    }

    override public function writeValue (mgr :MicrotomeMgr, writer :WritableObject, obj :*, name :String, type :TypeInfo) :void {
        writer.writeString(name, obj as String);
    }

    override public function cloneObject (mgr :MicrotomeMgr, data :Object, type :TypeInfo) :Object {
        // Strings don't need cloning
        return data;
    }
}
}
