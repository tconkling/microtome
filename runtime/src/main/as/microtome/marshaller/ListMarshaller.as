//
// microtome

package microtome.marshaller {

import microtome.core.DataElement;
import microtome.core.DataReader;
import microtome.core.LibraryManager;
import microtome.core.TypeInfo;

public class ListMarshaller extends ObjectMarshallerBase
{
    override public function get valueClass () :Class {
        return Array;
    }

    override public function readObject (data :DataElement, type :TypeInfo, loader :LibraryManager):* {
        const list :Array = [];
        const childMarshaller :ObjectMarshaller =
            loader.requireObjectMarshallerForClass(type.subtype.clazz);
        for each (var childData :DataElement in DataReader.withData(data).children) {
            var child :* = childMarshaller.readObject(childData, type.subtype, loader);
            list.push(child);
        }

        return list;
    }

    override public function resolveRefs (obj :*, type :TypeInfo, loader :LibraryManager) :void {
        const list :Array = obj as Array;
        const childMarshaller :ObjectMarshaller =
            loader.requireObjectMarshallerForClass(type.subtype.clazz);
        for each (var child :* in list) {
            childMarshaller.resolveRefs(child, type.subtype, loader);
        }
    }

    override public function cloneObject (data :Object, type :TypeInfo, mgr :LibraryManager) :Object {
        const list :Array = (data as Array);
        const clone :Array = [];
        return clone;
    }
}
}
