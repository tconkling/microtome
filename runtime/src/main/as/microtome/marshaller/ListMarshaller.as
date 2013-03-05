//
// microtome

package microtome.marshaller {

import microtome.LibraryLoader;
import microtome.core.DataElement;
import microtome.core.DataReader;
import microtome.core.LibraryItem;
import microtome.core.TypeInfo;

public class ListMarshaller extends ObjectMarshallerBase
{
    override public function get valueClass () :Class {
        return Array;
    }

    override public function loadObject (parent :LibraryItem, data :DataElement, type :TypeInfo, loader :LibraryLoader):* {
        var list :Array = [];
        var childMarshaller :ObjectMarshaller =
            loader.requireObjectMarshallerForClass(type.subtype.clazz);
        for each (var childData :DataElement in DataReader.withData(data).children) {
            var child :* = childMarshaller.loadObject(null, childData, type.subtype, loader);
            list.push(child);
        }

        return list;
    }

    override public function resolveRefs (obj :*, type :TypeInfo, loader :LibraryLoader) :void {
        var list :Array = obj as Array;
        var childMarshaller :ObjectMarshaller =
            loader.requireObjectMarshallerForClass(type.subtype.clazz);
        for each (var child :* in list) {
            childMarshaller.resolveRefs(child, type.subtype, loader);
        }
    }
}
}
