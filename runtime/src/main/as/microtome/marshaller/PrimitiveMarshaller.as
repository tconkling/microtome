//
// microtome

package microtome.marshaller {
import microtome.prop.BoolProp;
import microtome.prop.IntProp;
import microtome.prop.NumberProp;

public interface PrimitiveMarshaller
{
    function validateBool (prop :BoolProp) :void;
    function validateInt (prop :IntProp) :void;
    function validateNumber (prop :NumberProp) :void;
}
}
