//
// microtome

package microtome.marshaller {

import microtome.core.Defs;
import microtome.core.MicrotomeMgr;
import microtome.core.TypeInfo;
import microtome.error.ValidationError;
import microtome.prop.BoolProp;
import microtome.prop.IntProp;
import microtome.prop.NumberProp;
import microtome.prop.Prop;

public class PrimitiveMarshaller
    implements DataMarshaller
{
    public function validateProp (prop :Prop) :void {
        if (prop is BoolProp) {
            validateBool(BoolProp(prop));
        } else if (prop is IntProp) {
            validateInt(IntProp(prop));
        } else if (prop is NumberProp) {
            validateNumber(NumberProp(prop));
        } else {
            throw new ValidationError(prop, "Unrecognized primitive prop");
        }
    }

    public function cloneData (mgr :MicrotomeMgr, data :Object, type :TypeInfo) :* {
        // primitives don't need cloning
        return data;
    }

    public function validateBool (prop :BoolProp) :void {
        // do nothing
    }

    public function validateInt (prop :IntProp) :void {
        const min :int = prop.intAnnotation(Defs.MIN_ANNOTATION, int.MIN_VALUE);
        if (prop.value < min) {
            throw new ValidationError(prop, "value too small (" + prop.value + " < " + min + ")");
        }
        const max :int = prop.intAnnotation(Defs.MAX_ANNOTATION, int.MAX_VALUE);
        if (prop.value > max) {
            throw new ValidationError(prop, "value too large (" + prop.value + " > " + max + ")");
        }
    }

    public function validateNumber (prop :NumberProp) :void {
        const min :Number = prop.numberAnnotation(Defs.MIN_ANNOTATION, Number.NEGATIVE_INFINITY);
        if (prop.value < min) {
            throw new ValidationError(prop, "value too small (" + prop.value + " < " + min + ")");
        }
        const max :Number = prop.numberAnnotation(Defs.MAX_ANNOTATION, Number.POSITIVE_INFINITY);
        if (prop.value > max) {
            throw new ValidationError(prop, "value too large (" + prop.value + " > " + max + ")");
        }
    }
}
}
