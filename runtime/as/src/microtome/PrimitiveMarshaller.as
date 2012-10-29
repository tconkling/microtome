//
// microtome

package microtome {

public interface PrimitiveMarshaller
{
    function validateBool (prop :BoolProp) :void;
    function validateInt (prop :IntProp) :void;
    function validateNumber (prop :NumberProp) :void;
}
}
