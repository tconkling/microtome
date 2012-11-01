//
// microtome

package microtome.marshaller {

import microtome.DataElement;
import microtome.Library;
import microtome.ObjectMarshaller;
import microtome.ObjectProp;
import microtome.Util;
import microtome.ValidationError;
import microtome.TypeInfo;

public class ObjectMarshallerBase
    implements ObjectMarshaller
{
    public function get valueClass () :Class {
        throw new Error("abstract");
    }

    public function get handlesSubclasses () :Boolean {
        return false;
    }

    public function loadObject (data :DataElement, type :TypeInfo, library :Library) :* {
        throw new Error("abstract");
    }

    public function resolveRefs (obj :*, type :TypeInfo, library :Library) :void {
        // do nothing by default
    }

    public function validatePropValue (prop :ObjectProp) :void {
        if (!prop.nullable && prop.value == null) {
            throw new ValidationError(prop, "null value for non-nullable prop");
        } else if (prop.value != null && !(prop.value is this.valueClass)) {
            throw new ValidationError(prop, "incompatible value type [required=" +
                Util.getClassName(this.valueClass) + ", actual=" +
                Util.getClassName(prop.value) + "]");
        }
    }
}
}
