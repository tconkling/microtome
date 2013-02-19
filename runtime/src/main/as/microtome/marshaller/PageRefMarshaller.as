//
// microtome

package microtome.marshaller {

import microtome.Library;
import microtome.core.DataElement;
import microtome.core.DataReader;
import microtome.core.PageRef;
import microtome.core.TypeInfo;
import microtome.error.LoadError;

public class PageRefMarshaller extends ObjectMarshallerBase
{
    override public function get valueClass () :Class {
        return PageRef;
    }

    override public function loadObject (data :DataElement, type :TypeInfo, library :Library):* {
        var pageName :String = DataReader.withData(data).requireAttribute("ref");
        if (pageName.length == 0) {
            throw new LoadError(data, "invalid PageRef", "pageName", pageName);
        }
        return new PageRef(type.subtype.clazz, pageName);
    }

    override public function resolveRefs (obj :*, type :TypeInfo, library :Library) :void {
        var ref :PageRef = PageRef(obj);
        ref.page = library.requirePageWithQualifiedName(ref.pageName, ref.pageClass);
    }
}
}
