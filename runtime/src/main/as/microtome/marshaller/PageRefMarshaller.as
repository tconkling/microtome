//
// microtome

package microtome.marshaller {

import microtome.core.DataReader;
import microtome.core.MicrotomeMgr;
import microtome.core.PageRef;
import microtome.core.TypeInfo;
import microtome.error.LoadError;

public class PageRefMarshaller extends ObjectMarshallerBase
{
    override public function get valueClass () :Class {
        return PageRef;
    }

    override public function readObject (mgr :MicrotomeMgr, reader :DataReader, type :TypeInfo) :* {
        const pageName :String = reader.requireString("ref");
        if (pageName.length == 0) {
            throw new LoadError(reader.data, "invalid PageRef", "pageName", pageName);
        }
        return new PageRef(type.subtype.clazz, pageName);
    }

    override public function resolveRefs (mgr :MicrotomeMgr, obj :*, type :TypeInfo) :void {
        const ref :PageRef = PageRef(obj);
        ref.page = mgr.library.requirePageWithQualifiedName(ref.pageName, ref.pageClass);
    }

    override public function cloneObject (mgr :MicrotomeMgr, data :Object, type :TypeInfo) :Object {
        return PageRef(data).clone();
    }
}
}
