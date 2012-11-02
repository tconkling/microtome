//
// microtome

package microtome.marshaller {

import microtome.DataElement;
import microtome.Library;
import microtome.PageRef;
import microtome.TypeInfo;

public class PageRefMarshaller extends ObjectMarshallerBase
{
    override public function get valueClass () :Class {
        return PageRef;
    }

    override public function loadObject (data :DataElement, type :TypeInfo, library :Library):* {
        return new PageRef(type.subtype.clazz, data.value);
    }

    override public function resolveRefs (obj :*, type :TypeInfo, library :Library) :void {
        var ref :PageRef = PageRef(obj);
        ref.page = library.requirePageWithQualifiedName(ref.pageName, ref.pageClass);
    }
}
}
