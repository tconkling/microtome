//
// microtome

package microtome {

import microtome.core.LibraryManager;

public class Microtome
{
    public static function createCtx () :MicrotomeCtx {
        return new LibraryManager();
    }
}
}
