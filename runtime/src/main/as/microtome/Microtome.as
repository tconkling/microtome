//
// microtome

package microtome {

import microtome.core.MicrotomeMgr;

public class Microtome
{
    public static function createCtx () :MicrotomeCtx {
        return new MicrotomeMgr();
    }
}
}
