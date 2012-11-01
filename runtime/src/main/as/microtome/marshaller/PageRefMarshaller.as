//
// microtome

package microtome.marshaller {

import microtome.DataElement;
import microtome.Library;
import microtome.MutablePageRef;
import microtome.TypeInfo;

public class PageRefMarshaller extends ObjectMarshallerBase
{
    override public function get valueClass () :Class {
        return MutablePageRef;
    }

    override public function loadObject (data :DataElement, type :TypeInfo, library :Library):* {
        return new MutablePageRef(type.subtype.clazz, data.value);
    }

    override public function resolveRefs (obj :*, type :TypeInfo, library :Library) :void {
        var ref :MutablePageRef = MutablePageRef(obj);
        ref.page = library.requirePageWithQualifiedName(ref.pageName, ref.pageClass);
    }
}
}
