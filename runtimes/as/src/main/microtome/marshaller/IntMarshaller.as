//
// microtome

package microtome.marshaller {

import microtome.core.Annotation;
import microtome.core.DataReader;
import microtome.core.Defs;
import microtome.core.MicrotomeMgr;
import microtome.core.TypeInfo;
import microtome.core.WritableObject;
import microtome.error.ValidationError;
import microtome.prop.IntProp;
import microtome.prop.Prop;

public class IntMarshaller extends PrimitiveMarshaller
{
    public function IntMarshaller () {
        super(int);
    }

    override public function validateProp (p :Prop) :void {
        const prop :IntProp = IntProp(p);
        const min :int = prop.annotation(Defs.MIN_ANNOTATION).intValue(int.MIN_VALUE);
        if (prop.value < min) {
            throw new ValidationError(prop, "value too small (" + prop.value + " < " + min + ")");
        }
        const max :int = prop.annotation(Defs.MAX_ANNOTATION).intValue(int.MAX_VALUE);
        if (prop.value > max) {
            throw new ValidationError(prop, "value too large (" + prop.value + " > " + max + ")");
        }
    }

    override public function readValue (mgr :MicrotomeMgr, reader :DataReader, name :String, type :TypeInfo) :* {
        return reader.requireInt(name);
    }

    override public function readDefault (mgr :MicrotomeMgr, type :TypeInfo, anno :Annotation) :* {
        return anno.intValue(0);
    }

    override public function writeValue (mgr :MicrotomeMgr, writer :WritableObject, val :*, name :String, type :TypeInfo) :void {
        writer.writeInt(name, val);
    }
}
}
