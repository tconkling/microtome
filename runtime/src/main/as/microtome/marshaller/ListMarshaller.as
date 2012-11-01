//
// microtome

package microtome.marshaller {

import microtome.DataElement;
import microtome.DataReader;
import microtome.Library;
import microtome.ObjectMarshaller;
import microtome.TypeInfo;

public class ListMarshaller extends ObjectMarshallerBase
{
    override public function get valueClass () :Class {
        return Array;
    }

    override public function loadObject (data :DataElement, type :TypeInfo, library :Library):* {
        var list :Array = [];
        var childMarshaller :ObjectMarshaller =
            library.requireObjectMarshallerForClass(type.subtype.clazz);
        for each (var childData :DataElement in DataReader.withData(data).children) {
            var child :* = childMarshaller.loadObject(childData, type.subtype, library);
            list.push(child);
        }

        return list;
    }

    override public function resolveRefs (obj :*, type :TypeInfo, library :Library) :void {
        var list :Array = obj as Array;
        var childMarshaller :ObjectMarshaller =
            library.requireObjectMarshallerForClass(type.subtype.clazz);
        for each (var child :* in list) {
            childMarshaller.resolveRefs(child, type.subtype, library);
        }
    }
}
}
