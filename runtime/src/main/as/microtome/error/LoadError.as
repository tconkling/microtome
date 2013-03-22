//
// microtome

package microtome.error {

import microtome.core.DataElement;

public class LoadError extends MicrotomeErrorBase
{
    public function LoadError (badElement :DataElement, message :String, ...args) {
        super(message, addDataToArgs(badElement, args));
    }

    protected function addDataToArgs (badElement :DataElement, args :Array) :Array {
        if (badElement != null) {
            args.push("data", badElement.debugDescription);
        }
        return args;
    }
}
}
