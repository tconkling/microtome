//
// microtome

package microtome.marshaller {

import microtome.core.Defs;
import microtome.error.ValidationError;
import microtome.prop.BoolProp;
import microtome.prop.IntProp;
import microtome.prop.NumberProp;

public class DefaultPrimitiveMarshaller
    implements PrimitiveMarshaller
{
    public function validateBool (prop :BoolProp) :void {
        // do nothing
    }

    public function validateInt (prop :IntProp) :void {
        var min :int = prop.intAnnotation(Defs.MIN_ATTR, int.MIN_VALUE);
        if (prop.value < min) {
            throw new ValidationError(prop, "value too small (" + prop.value + " < " + min + ")");
        }
        var max :int = prop.intAnnotation(Defs.MAX_ATTR, int.MAX_VALUE);
        if (prop.value > max) {
            throw new ValidationError(prop, "value too large (" + prop.value + " > " + max + ")");
        }
    }

    public function validateNumber (prop :NumberProp) :void {
        var min :Number = prop.numberAnnotation(Defs.MIN_ATTR, Number.MIN_VALUE);
        if (prop.value < min) {
            throw new ValidationError(prop, "value too small (" + prop.value + " < " + min + ")");
        }
        var max :Number = prop.numberAnnotation(Defs.MAX_ATTR, Number.MAX_VALUE);
        if (prop.value > max) {
            throw new ValidationError(prop, "value too large (" + prop.value + " > " + max + ")");
        }
    }
}
}
