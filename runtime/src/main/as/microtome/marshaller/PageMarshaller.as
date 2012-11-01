//
// microtome

package microtome.marshaller {

import microtome.DataElement;
import microtome.Library;
import microtome.MutablePage;
import microtome.ObjectMarshaller;
import microtome.ObjectProp;
import microtome.Prop;
import microtome.TypeInfo;

public class PageMarshaller extends ObjectMarshallerBase
{
    override public function get valueClass () :Class {
        return MutablePage;
    }

    override public function get handlesSubclasses () :Boolean {
        return true;
    }

    override public function loadObject (data :DataElement, type :TypeInfo, library :Library):* {
        return library.loadPage(data, type.clazz);
    }

    override public function resolveRefs (obj :*, type :TypeInfo, library :Library) :void {
        var page :MutablePage = MutablePage(obj);
        for each (var prop :Prop in page.props) {
            var objectProp :ObjectProp = (prop as ObjectProp);
            if (objectProp != null && objectProp.value != null) {
                var propMarshaller :ObjectMarshaller =
                    library.requireObjectMarshallerForClass(objectProp.valueType.clazz);
                propMarshaller.resolveRefs(objectProp.value, objectProp.valueType, library);
            }
        }
    }
}
}
