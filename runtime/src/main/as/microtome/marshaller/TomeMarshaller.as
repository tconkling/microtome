//
// microtome

package microtome.marshaller {

import microtome.MutablePage;
import microtome.MutableTome;
import microtome.Page;
import microtome.core.DataReader;
import microtome.core.MicrotomeMgr;
import microtome.core.TypeInfo;
import microtome.core.WritableObject;

public class TomeMarshaller extends ObjectMarshallerBase
{
    override public function get valueClass () :Class {
        return MutableTome;
    }

    override public function readObject (mgr :MicrotomeMgr, reader :DataReader, type :TypeInfo) :* {
        return mgr.loadTome(reader, type.subtype.clazz);
    }

    override public function writeObject (mgr :MicrotomeMgr, writer :WritableObject, obj :*, type :TypeInfo) :void {
        mgr.saveTome(writer, MutableTome(obj));
    }

    override public function resolveRefs (mgr :MicrotomeMgr, obj :*, type :TypeInfo) :void {
        const tome :MutableTome = MutableTome(obj);
        const pageMarshaller :ObjectMarshaller =
            mgr.requireObjectMarshallerForClass(tome.pageClass);
        tome.forEach(function (page :Page) :void {
            pageMarshaller.resolveRefs(mgr, page, type.subtype);
        });
    }

    override public function cloneObject (mgr :MicrotomeMgr, data :Object, type :TypeInfo) :Object {
        const tome :MutableTome = MutableTome(data);
        const pageMarshaller :ObjectMarshaller =
            mgr.requireObjectMarshallerForClass(tome.pageClass);
        const clone :MutableTome = new MutableTome(tome.name, tome.pageClass);

        tome.forEach(function (page :MutablePage) :void {
            clone.addPage(pageMarshaller.cloneData(mgr, page, type.subtype));
        });

        return clone;
    }
}
}
