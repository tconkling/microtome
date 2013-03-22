//
// microtome

package microtome.marshaller {

import microtome.core.DataReader;
import microtome.core.MicrotomeMgr;
import microtome.core.TypeInfo;

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
        const clone :Array = [];
        return clone;
    }
}
}
