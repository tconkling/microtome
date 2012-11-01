//
// microtome

package microtome.marshaller {

import microtome.DataElement;
import microtome.Library;
import microtome.MutableTome;
import microtome.ObjectMarshaller;
import microtome.Page;
import microtome.TypeInfo;

public class TomeMarshaller extends ObjectMarshallerBase
{
    override public function get valueClass () :Class {
        return MutableTome;
    }

    override public function loadObject (data :DataElement, type :TypeInfo, library :Library) :* {
        return library.loadTome(data, type.subtype.clazz);
    }

    override public function resolveRefs (obj :*, type :TypeInfo, library :Library) :void {
        var tome :MutableTome = MutableTome(obj);
        var pageMarshaller :ObjectMarshaller =
            library.requireObjectMarshallerForClass(tome.pageClass);
        for each (var page :Page in tome.pages) {
            pageMarshaller.resolveRefs(page, type.subtype, library);
        }
    }
}
}
