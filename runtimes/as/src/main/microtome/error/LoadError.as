//
// microtome

package microtome.error {

import microtome.core.ReadableObject;

public class LoadError extends MicrotomeErrorBase
{
    public function LoadError (badElement :ReadableObject, message :String, ...args) {
        super(message, args);
        if (badElement != null) {
            this.message += "\ndata: " + badElement.debugDescription;
        }
    }
}
}
