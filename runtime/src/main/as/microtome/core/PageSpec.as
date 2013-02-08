//
// microtome

package microtome.core {

import microtome.Page;
import microtome.prop.PropSpec;

public class PageSpec
{
    public function get props () :Vector.<PropSpec> {
        return EMPTY_VEC;
    }

    public function getValue (page :Page, name :String) :* {
        throw new Error("No such prop '" + name + "'");
    }

    public function setValue (page :Page, name :String, val :*) :void {
        throw new Error("No such prop '" + name + "'");
    }

    protected static const EMPTY_VEC :Vector.<PropSpec> = new Vector.<PropSpec>(0, true);
}
}
