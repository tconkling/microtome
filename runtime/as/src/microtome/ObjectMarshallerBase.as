//
// microtome

package microtome {

public class ObjectMarshallerBase
    implements ObjectMarshaller
{
    public function get valueType () :Class {
        throw new Error("abstract");
    }

    public function get handlesSubclasses () :Boolean {
        return false;
    }

    public function loadObject (data :DataElement, type :ValueType, library :Library) :* {
        throw new Error("abstract");
    }

    public function resolveRefs (obj :*, type :ValueType, library :Library) :void {
        // do nothing by default
    }

    public function validatePropValue (prop :ObjectProp) :void {
        if (!prop.nullable && prop.value == null) {
            throw new ValidationError(prop, "null value for non-nullable prop");
        } else if (prop.value != null && !(prop.value is this.valueType)) {
            throw new ValidationError(prop, "incompatible value type [required=" +
                Util.getClassName(this.valueType) + ", actual=" +
                Util.getClassName(prop.value) + "]");
        }

    }
}
}
