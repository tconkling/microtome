//
// microtome

package microtome.marshaller {

import microtome.core.Annotation;
import microtome.core.DataReader;
import microtome.core.MicrotomeMgr;
import microtome.core.TomeRef;
import microtome.core.TypeInfo;
import microtome.core.WritableObject;
import microtome.error.LoadError;

public class TomeRefMarshaller extends ObjectMarshaller
{
    public function TomeRefMarshaller () {
        super(true);
    }

    override public function get valueClass () :Class {
        return TomeRef;
    }

    override public function readValue (mgr :MicrotomeMgr, reader :DataReader, name :String, type :TypeInfo) :* {
        const tomeName :String = reader.requireString(name);
        if (tomeName.length == 0) {
            throw new LoadError(reader.data, "invalid TomeRef", "tomeName", tomeName);
        }
        return new TomeRef(tomeName);
    }

    override public function readDefault (mgr :MicrotomeMgr, type :TypeInfo, anno :Annotation) :* {
        return new TomeRef(anno.stringValue(null));
    }

    override public function writeValue (mgr :MicrotomeMgr, writer :WritableObject, obj :*, name :String, type :TypeInfo) :void {
        writer.writeString(name, TomeRef(obj).tomeId);
    }

    override public function resolveRefs (mgr :MicrotomeMgr, obj :*, type :TypeInfo) :void {
        TomeRef(obj).resolve(mgr.library, type.subtype.clazz);
    }

    override public function cloneObject (mgr :MicrotomeMgr, data :Object, type :TypeInfo) :Object {
        return TomeRef(data).clone();
    }
}
}
