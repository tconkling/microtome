//
// microtome

package microtome.marshaller {

import microtome.core.DataReader;
import microtome.core.MicrotomeMgr;
import microtome.core.PageRef;
import microtome.core.TypeInfo;
import microtome.core.WritableObject;
import microtome.error.LoadError;

public class PageRefMarshaller extends ObjectMarshallerBase
{
    override public function get valueClass () :Class {
        return PageRef;
    }

    override public function readObject (mgr :MicrotomeMgr, reader :DataReader, type :TypeInfo) :* {
        const pageName :String = reader.requireString(REF);
        if (pageName.length == 0) {
            throw new LoadError(reader.data, "invalid PageRef", "pageName", pageName);
        }
        return new PageRef(pageName);
    }

    override public function writeObject (mgr :MicrotomeMgr, writer :WritableObject, obj :*, type :TypeInfo) :void {
        writer.writeString(REF, PageRef(obj).pageName);
    }

    override public function resolveRefs (mgr :MicrotomeMgr, obj :*, type :TypeInfo) :void {
        PageRef(obj).resolve(mgr.library, type.subtype.clazz);
    }

    override public function cloneObject (mgr :MicrotomeMgr, data :Object, type :TypeInfo) :Object {
        return PageRef(data).clone();
    }

    protected static const REF :String = "ref";
}
}
