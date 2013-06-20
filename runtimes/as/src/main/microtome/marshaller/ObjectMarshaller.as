//
// microtome

package microtome.marshaller {

import microtome.core.Annotation;
import microtome.core.DataReader;
import microtome.core.MicrotomeMgr;
import microtome.core.TypeInfo;
import microtome.core.WritableObject;
import microtome.error.ValidationError;
import microtome.prop.ObjectProp;
import microtome.prop.Prop;
import microtome.util.ClassUtil;

public class ObjectMarshaller
    implements DataMarshaller
{
    /**
     * @param isSimple true if this marshaller represents a "simple" data type.
     * A simple type is one that can be parsed from a single value.
     * Generally, composite objects are likely to be non-simple (though, for example, a Tuple
     * object could be made simple if you were to parse it from a comma-delimited string).
     */
    public function ObjectMarshaller (isSimple :Boolean) {
        _isSimple = isSimple;
    }

    public function get valueClass () :Class {
        throw new Error("abstract");
    }

    public function get handlesSubclasses () :Boolean {
        return false;
    }

    public function canReadValue (reader :DataReader, name :String) :Boolean {
        return _isSimple ? reader.hasValue(name) : reader.hasChild(name);
    }

    public function getValueReader (parentReader :DataReader, name :String) :DataReader {
        return _isSimple ? parentReader : parentReader.requireChild(name);
    }

    public function getValueWriter (parentWriter :WritableObject, name :String) :WritableObject {
        return _isSimple ? parentWriter : parentWriter.addChild(name);
    }

    public function readValue (mgr :MicrotomeMgr, reader :DataReader, name :String, type :TypeInfo) :* {
        throw new Error("abstract");
    }

    public function readDefault (mgr :MicrotomeMgr, type :TypeInfo, anno :Annotation) :* {
        throw new Error("abstract");
    }

    public function writeValue (mgr :MicrotomeMgr, writer :WritableObject, obj :*, name :String, type :TypeInfo) :void {
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

    protected var _isSimple :Boolean;
}
}
