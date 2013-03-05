//
// microtome

package microtome.marshaller {

import microtome.Library;
import microtome.MutableTome;
import microtome.Page;
import microtome.core.DataElement;
import microtome.core.LibraryItem;
import microtome.core.TypeInfo;

public class TomeMarshaller extends ObjectMarshallerBase
{
    override public function get valueClass () :Class {
        return MutableTome;
    }

    override public function loadObject (parent :LibraryItem, data :DataElement, type :TypeInfo, library :Library) :* {
        return library.loadTome(parent, data, type.subtype.clazz);
    }

    override public function resolveRefs (obj :*, type :TypeInfo, library :Library) :void {
        var tome :MutableTome = MutableTome(obj);
        var pageMarshaller :ObjectMarshaller =
            library.requireObjectMarshallerForClass(tome.pageClass);
        tome.forEach(function (page :Page) :void {
            pageMarshaller.resolveRefs(page, type.subtype, library);
        });
    }
}
}
