//
// microtome

package microtome.marshaller {

import microtome.core.Annotation;
import microtome.core.DataReader;
import microtome.core.MicrotomeMgr;
import microtome.core.TypeInfo;
import microtome.core.WritableObject;
import microtome.prop.Prop;

public /*abstract*/ class PrimitiveMarshaller
    implements DataMarshaller
{
    public function PrimitiveMarshaller (valueClazz :Class) {
        _valueClazz = valueClazz;
    }

    public final function get valueClass () :Class {
        return _valueClazz;
    }

    public final function get handlesSubclasses () :Boolean {
        return false;
    }

    public final function canReadValue (reader :DataReader, name :String) :Boolean {
        return reader.hasValue(name);
    }

    public final function getValueReader (parentReader :DataReader, name :String) :DataReader {
        return parentReader;
    }

    public final function getValueWriter (parentWriter :WritableObject, name :String) :WritableObject {
        return parentWriter;
    }

    public final function resolveRefs (mgr :MicrotomeMgr, val :*, type :TypeInfo) :void {
        // primitives don't store refs
    }

    public final function cloneData (mgr :MicrotomeMgr, data :Object, type :TypeInfo) :* {
        // primitives don't need cloning
        return data;
    }

    public function validateProp (prop :Prop) :void {
        throw new Error("abstract");
    }

    public function readValue (mgr :MicrotomeMgr, reader :DataReader, name :String, type :TypeInfo) :* {
        throw new Error("abstract");
    }

    public function readDefault (mgr :MicrotomeMgr, type :TypeInfo, anno :Annotation) :* {
        throw new Error("abstract");
    }

    public function writeValue (mgr :MicrotomeMgr, writer :WritableObject, val :*, name :String, type :TypeInfo) :void {
        throw new Error("abstract");
    }

    protected var _valueClazz :Class;
}
}
