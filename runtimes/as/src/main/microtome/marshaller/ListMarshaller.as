//
// microtome

package microtome.marshaller {

import microtome.core.DataReader;
import microtome.core.MicrotomeItem;
import microtome.core.MicrotomeMgr;
import microtome.core.TypeInfo;
import microtome.core.WritableObject;

public class ListMarshaller extends ObjectMarshaller
{
    public function ListMarshaller () {
        super(false);
    }

    override public function get valueClass () :Class {
        return Array;
    }

    override public function getValueWriter (parentWriter :WritableObject,  name :String) :WritableObject {
        return parentWriter.addChild(name, true);
    }

    override public function readValue (mgr :MicrotomeMgr, reader :DataReader, name :String, type :TypeInfo) :* {
        const list :Array = [];
        const childMarshaller :DataMarshaller =
            mgr.requireDataMarshaller(type.subtype.clazz);
        for each (var childReader :DataReader in reader.children) {
            var child :* = childMarshaller.readValue(mgr, childReader, childReader.name, type.subtype);
            list.push(child);
        }

        return list;
    }

    override public function writeValue (mgr :MicrotomeMgr, writer :WritableObject, obj :*, name :String, type :TypeInfo) :void {
        const list :Array = obj as Array;
        const childMarshaller :DataMarshaller = mgr.requireDataMarshaller(type.subtype.clazz);
        for each (var child :Object in list) {
            var name :String = (child is MicrotomeItem ? MicrotomeItem(child).name : "item");
            childMarshaller.writeValue(mgr, childMarshaller.getValueWriter(writer, name), child, name, type.subtype);
        }
    }

    override public function resolveRefs (mgr :MicrotomeMgr, obj :*, type :TypeInfo) :void {
        const list :Array = obj as Array;
        const childMarshaller :DataMarshaller =
            mgr.requireDataMarshaller(type.subtype.clazz);
        for each (var child :* in list) {
            childMarshaller.resolveRefs(mgr, child, type.subtype);
        }
    }

    override public function cloneObject (mgr :MicrotomeMgr, data :Object, type :TypeInfo) :Object {
        const list :Array = (data as Array);
        const childMarshaller :DataMarshaller =
            mgr.requireDataMarshaller(type.subtype.clazz);
        const clone :Array = [];
        for each (var child :Object in list) {
            clone.push(childMarshaller.cloneData(mgr, child, type.subtype));
        }
        return clone;
    }
}
}
