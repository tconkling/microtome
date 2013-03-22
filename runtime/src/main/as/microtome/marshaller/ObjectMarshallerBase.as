//
// microtome

package microtome.marshaller {

import microtome.core.DataElement;
import microtome.core.LibraryManager;
import microtome.core.TypeInfo;
import microtome.error.ValidationError;
import microtome.prop.ObjectProp;
import microtome.prop.Prop;
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

    public function readObject (data :DataElement, type :TypeInfo, loader :LibraryManager) :* {
        throw new Error("abstract");
    }

    public function resolveRefs (obj :*, type :TypeInfo, mgr :LibraryManager) :void {
        // do nothing by default
    }

    public function cloneObject (data :Object, type :TypeInfo, mgr :LibraryManager) :Object {
        throw new Error("abstract");
    }

    public function cloneData (data :Object, type :TypeInfo, mgr :LibraryManager) :* {
        // handle null data
        return (data == null ? null : cloneObject(data, type, mgr));
    }

    public function validateProp (p :Prop) :void {
        var prop :ObjectProp = ObjectProp(p);

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
