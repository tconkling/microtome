//
// microtome

package microtome.error {

import microtome.core.DataElement;

public class LoadError extends Error
{
    public function LoadError (message :String, badElement :DataElement = null) {
        super(createMessage(message, badElement), 0);
    }

    protected static function createMessage (message :String, badElement :DataElement) :String {
        if (badElement != null) {
            message += " data:\n" + badElement.description;
        }
        return message;
    }
}
}
