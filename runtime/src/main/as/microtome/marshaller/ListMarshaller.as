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

    override public function loadObject (data :DataElement, type :TypeInfo, loader :LibraryManager):* {
        const list :Array = [];
        const childMarshaller :ObjectMarshaller =
            loader.requireObjectMarshallerForClass(type.subtype.clazz);
        for each (var childData :DataElement in DataReader.withData(data).children) {
            var child :* = childMarshaller.loadObject(childData, type.subtype, loader);
            list.push(child);
        }

        return list;
    }

    override public function resolveRefs (obj :*, type :TypeInfo, loader :LibraryManager) :void {
        var list :Array = obj as Array;
        var childMarshaller :ObjectMarshaller =
            loader.requireObjectMarshallerForClass(type.subtype.clazz);
        for each (var child :* in list) {
            childMarshaller.resolveRefs(child, type.subtype, loader);
        }
    }
}
}
