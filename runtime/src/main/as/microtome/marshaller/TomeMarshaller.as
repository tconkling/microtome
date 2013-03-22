//
// microtome

package microtome.marshaller {

import microtome.MutablePage;
import microtome.MutableTome;
import microtome.Page;
import microtome.core.DataElement;
import microtome.core.LibraryManager;
import microtome.core.TypeInfo;

public class TomeMarshaller extends ObjectMarshallerBase
{
    override public function get valueClass () :Class {
        return MutableTome;
    }

    override public function readObject (data :DataElement, type :TypeInfo, mgr :LibraryManager) :* {
        return mgr.loadTome(data, type.subtype.clazz);
    }

    override public function resolveRefs (obj :*, type :TypeInfo, mgr :LibraryManager) :void {
        const tome :MutableTome = MutableTome(obj);
        const pageMarshaller :ObjectMarshaller =
            mgr.requireObjectMarshallerForClass(tome.pageClass);
        tome.forEach(function (page :Page) :void {
            pageMarshaller.resolveRefs(page, type.subtype, mgr);
        });
    }

    override public function cloneObject (data :Object, type :TypeInfo, mgr :LibraryManager) :Object {
        const tome :MutableTome = MutableTome(data);
        const pageMarshaller :ObjectMarshaller =
            mgr.requireObjectMarshallerForClass(tome.pageClass);
        const clone :MutableTome = new MutableTome(tome.name, tome.pageClass);

        tome.forEach(function (page :MutablePage) :void {
            clone.addPage(pageMarshaller.cloneData(page, type.subtype, mgr));
        });

        return clone;
    }
}
}
