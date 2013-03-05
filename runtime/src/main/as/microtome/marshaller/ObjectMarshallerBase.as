//
// microtome

package microtome.marshaller {

import microtome.LibraryLoader;
import microtome.core.DataElement;
import microtome.core.LibraryItem;
import microtome.core.TypeInfo;
import microtome.error.ValidationError;
import microtome.prop.ObjectProp;
import microtome.util.ClassUtil;

public class ObjectMarshallerBase
    implements ObjectMarshaller
{
    public function get valueClass () :Class {
        throw new Error("abstract");
    }

    public function get handlesSubclasses () :Boolean {
        return false;
    }

    public function loadObject (parent :LibraryItem, data :DataElement, type :TypeInfo, loader :LibraryLoader) :* {
        throw new Error("abstract");
    }

    public function resolveRefs (obj :*, type :TypeInfo, loader :LibraryLoader) :void {
        // do nothing by default
    }

    public function validatePropValue (prop :ObjectProp) :void {
        if (!prop.nullable && prop.value == null) {
            throw new ValidationError(prop, "null value for non-nullable prop");
        } else if (prop.value != null && !(prop.value is this.valueClass)) {
            throw new ValidationError(prop, "incompatible value type [required=" +
                ClassUtil.getClassName(this.valueClass) + ", actual=" +
                ClassUtil.getClassName(prop.value) + "]");
        }
    }
}
}
