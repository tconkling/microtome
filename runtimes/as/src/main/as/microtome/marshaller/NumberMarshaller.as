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
import microtome.prop.NumberProp;
import microtome.prop.Prop;

public class NumberMarshaller extends PrimitiveMarshaller
{
    public function NumberMarshaller () {
        super(Number);
    }

    override public function validateProp (p :Prop) :void {
        const prop :NumberProp = NumberProp(p);
        const min :Number = prop.annotation(Defs.MIN_ANNOTATION).numberValue(Number.NEGATIVE_INFINITY);
        if (prop.value < min) {
            throw new ValidationError(prop, "value too small (" + prop.value + " < " + min + ")");
        }
        const max :Number = prop.annotation(Defs.MAX_ANNOTATION).numberValue(Number.POSITIVE_INFINITY);
        if (prop.value > max) {
            throw new ValidationError(prop, "value too large (" + prop.value + " > " + max + ")");
        }
    }

    override public function readValue (mgr :MicrotomeMgr, reader :DataReader, name :String, type :TypeInfo) :* {
        return reader.requireNumber(name);
    }

    override public function readDefault (mgr :MicrotomeMgr, type :TypeInfo, anno :Annotation) :* {
        return anno.numberValue(0);
    }

    override public function writeValue (mgr :MicrotomeMgr, writer :WritableObject, val :*, name :String, type :TypeInfo) :void {
        writer.writeNumber(name, val);
    }
}
}

