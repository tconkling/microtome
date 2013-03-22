//
// microtome

package microtome.error {

import microtome.core.ReadableObject;

public class LoadError extends MicrotomeErrorBase
{
    public function LoadError (badElement :ReadableObject, message :String, ...args) {
        super(message, addDataToArgs(badElement, args));
    }

    protected function addDataToArgs (badElement :ReadableObject, args :Array) :Array {
        if (badElement != null) {
            args.push("data", badElement.debugDescription);
        }
        return args;
    }
}
}
