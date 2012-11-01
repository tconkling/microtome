//
// microtome

package microtome {

public class DefaultPrimitiveMarshaller
    implements PrimitiveMarshaller
{
    public function validateBool (prop :BoolProp) :void {
        // do nothing
    }

    public function validateInt (prop :IntProp) :void {
        var min :int = prop.intAnnotation(Defs.MIN, int.MIN_VALUE);
        if (prop.value < min) {
            throw new ValidationError(prop, "value too small (" + prop.value + " < " + min + ")");
        }
        var max :int = prop.intAnnotation(Defs.MAX, int.MAX_VALUE);
        if (prop.value > max) {
            throw new ValidationError(prop, "value too large (" + prop.value + " > " + max + ")");
        }
    }

    public function validateNumber (prop :NumberProp) :void {
        var min :Number = prop.intAnnotation(Defs.MIN, Number.MIN_VALUE);
        if (prop.value < min) {
            throw new ValidationError(prop, "value too small (" + prop.value + " < " + min + ")");
        }
        var max :Number = prop.intAnnotation(Defs.MAX, Number.MAX_VALUE);
        if (prop.value > max) {
            throw new ValidationError(prop, "value too large (" + prop.value + " > " + max + ")");
        }
    }
}
}
