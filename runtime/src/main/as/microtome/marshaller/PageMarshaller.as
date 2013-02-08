//
// microtome

package microtome.marshaller {

import microtome.Library;
import microtome.Page;
import microtome.core.DataElement;
import microtome.core.TypeInfo;
import microtome.prop.ObjectProp;
import microtome.prop.Prop;

public class PageMarshaller extends ObjectMarshallerBase
{
    override public function get valueClass () :Class {
        return Page;
    }

    override public function get handlesSubclasses () :Boolean {
        return true;
    }

    override public function loadObject (data :DataElement, type :TypeInfo, library :Library):* {
        return library.loadPage(data, type.clazz);
    }

    override public function resolveRefs (obj :*, type :TypeInfo, library :Library) :void {
        var page :Page = Page(obj);
        for each (var prop :Prop in page.props) {
            var objectProp :ObjectProp = (prop as ObjectProp);
            if (objectProp != null && objectProp.value != null) {
                var propMarshaller :ObjectMarshaller =
                    library.requireObjectMarshallerForClass(objectProp.spec.valueType.clazz);
                propMarshaller.resolveRefs(objectProp.value, objectProp.spec.valueType, library);
            }
        }
    }
}
}
