//
// microtome

package microtome.error {

import microtome.prop.Prop;

public class ValidationError extends MicrotomeError
{
    public function ValidationError (prop :Prop, message :String) {
        super(getMessage(prop, message));
    }

    protected static function getMessage (prop :Prop, message :String) :String {
        return "Error validating '" + prop.name + "': " + message;
    }
}
}
