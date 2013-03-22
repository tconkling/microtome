//
// microtome

package microtome.marshaller {

import microtome.core.DataReader;
import microtome.core.MicrotomeItem;
import microtome.core.MicrotomeMgr;
import microtome.core.TypeInfo;
import microtome.core.WritableObject;

public class ListMarshaller extends ObjectMarshallerBase
{
    override public function get valueClass () :Class {
        return Array;
    }

    override public function readObject (mgr :MicrotomeMgr, reader :DataReader, type :TypeInfo) :* {
        const list :Array = [];
        const childMarshaller :ObjectMarshaller =
            mgr.requireObjectMarshallerForClass(type.subtype.clazz);
        for each (var childReader :DataReader in reader.children) {
            var child :* = childMarshaller.readObject(mgr, childReader, type.subtype);
            list.push(child);
        }

        return list;
    }

    override public function writeObject (mgr :MicrotomeMgr, writer :WritableObject, obj :*, type :TypeInfo) :void {
        const list :Array = obj as Array;
        const childMarshaller :ObjectMarshaller =
            mgr.requireObjectMarshallerForClass(type.subtype.clazz);
        for each (var child :Object in list) {
            var name :String = (child is MicrotomeItem ? MicrotomeItem(child).name : "item");
            childMarshaller.writeObject(mgr, writer.addChild(name), child, type.subtype);
        }
    }

    override public function resolveRefs (mgr :MicrotomeMgr, obj :*, type :TypeInfo) :void {
        const list :Array = obj as Array;
        const childMarshaller :ObjectMarshaller =
            mgr.requireObjectMarshallerForClass(type.subtype.clazz);
        for each (var child :* in list) {
            childMarshaller.resolveRefs(mgr, child, type.subtype);
        }
    }

    override public function cloneObject (mgr :MicrotomeMgr, data :Object, type :TypeInfo) :Object {
        const list :Array = (data as Array);
        const childMarshaller :ObjectMarshaller =
            mgr.requireObjectMarshallerForClass(type.subtype.clazz);
        const clone :Array = [];
        for each (var child :Object in list) {
            clone.push(childMarshaller.cloneData(mgr, child, type.subtype));
        }
        return clone;
    }
}
}
