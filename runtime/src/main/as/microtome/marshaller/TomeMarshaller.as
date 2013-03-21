//
// microtome

package microtome.marshaller {

import microtome.Page;
import microtome.core.DataElement;
import microtome.core.LibraryManager;
import microtome.MutableTome;
import microtome.core.TypeInfo;

public class TomeMarshaller extends ObjectMarshallerBase
{
    override public function get valueClass () :Class {
        return MutableTome;
    }

    override public function loadObject (data :DataElement, type :TypeInfo, mgr :LibraryManager) :* {
        return mgr.loadTome(data, type.subtype.clazz);
    }

    override public function resolveRefs (obj :*, type :TypeInfo, loader :LibraryManager) :void {
        const tome :MutableTome = MutableTome(obj);
        const pageMarshaller :ObjectMarshaller =
            loader.requireObjectMarshallerForClass(tome.pageClass);
        tome.forEach(function (page :Page) :void {
            pageMarshaller.resolveRefs(page, type.subtype, loader);
        });
    }
}
}
