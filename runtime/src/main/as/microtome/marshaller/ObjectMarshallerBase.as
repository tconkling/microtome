//
// microtome

package microtome.marshaller {

import microtome.core.DataReader;
import microtome.core.MicrotomeMgr;
import microtome.core.TypeInfo;
import microtome.core.WritableObject;
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

    public function readObject (mgr :MicrotomeMgr, reader :DataReader, type :TypeInfo) :* {
        throw new Error("abstract");
    }

    public function writeObject (mgr :MicrotomeMgr, writer :WritableObject, obj :*, type :TypeInfo) :void {
        throw new Error("abstract");
    }

    public function resolveRefs (mgr :MicrotomeMgr, obj :*, type :TypeInfo) :void {
        // do nothing by default
    }

    public function cloneObject (mgr :MicrotomeMgr, data :Object, type :TypeInfo) :Object {
        throw new Error("abstract");
    }

    public function cloneData (mgr :MicrotomeMgr, data :Object, type :TypeInfo) :* {
        // handle null data
        return (data == null ? null : cloneObject(mgr, data, type));
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
