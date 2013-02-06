//
// microtome

package microtome.error {

import microtome.prop.Prop;

public class ValidationError extends Error
{
    public function ValidationError (prop :Prop, message :String) {
        super(getMessage(prop, message), 0);
    }

    protected static function getMessage (prop :Prop, message :String) :String {
        return "Error validating '" + prop.name + "': " + message;
    }
}
}
