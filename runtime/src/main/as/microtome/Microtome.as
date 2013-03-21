//
// microtome

package microtome {
import microtome.core.LibraryManager;

public class Microtome
{
    public static function createCtx (library :Library) :MicrotomeCtx {
        return new LibraryManager(library);
    }
}
}
