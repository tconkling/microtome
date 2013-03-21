//
// microtome

package microtome.marshaller {

import microtome.core.DataElement;
import microtome.core.DataReader;
import microtome.core.LibraryManager;
import microtome.core.PageRef;
import microtome.core.TypeInfo;
import microtome.error.LoadError;

public class PageRefMarshaller extends ObjectMarshallerBase
{
    override public function get valueClass () :Class {
        return PageRef;
    }

    override public function loadObject (data :DataElement, type :TypeInfo, mgr :LibraryManager) :* {
        const pageName :String = DataReader.withData(data).requireAttribute("ref");
        if (pageName.length == 0) {
            throw new LoadError(data, "invalid PageRef", "pageName", pageName);
        }
        return new PageRef(type.subtype.clazz, pageName);
    }

    override public function resolveRefs (obj :*, type :TypeInfo, loader :LibraryManager) :void {
        const ref :PageRef = PageRef(obj);
        ref.page = loader.library.requirePageWithQualifiedName(ref.pageName, ref.pageClass);
    }

    override public function cloneObject (data :Object, mgr :LibraryManager) :Object {
        return PageRef(data).clone();
    }
}
}
