//
// microtome

package microtome.marshaller {

import microtome.LibraryLoader;
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

    override public function loadObject (parent :LibraryItem, data :DataElement, type :TypeInfo, loader :LibraryLoader) :* {
        return loader.loadTome(parent, data, type.subtype.clazz);
    }

    override public function resolveRefs (obj :*, type :TypeInfo, loader :LibraryLoader) :void {
        var tome :MutableTome = MutableTome(obj);
        var pageMarshaller :ObjectMarshaller =
            loader.requireObjectMarshallerForClass(tome.pageClass);
        tome.forEach(function (page :Page) :void {
            pageMarshaller.resolveRefs(page, type.subtype, loader);
        });
    }
}
}
