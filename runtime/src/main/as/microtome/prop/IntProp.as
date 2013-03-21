//
// microtome

package microtome.prop {

import microtome.MutablePage;
import microtome.core.TypeInfo;

public final class IntProp extends Prop
{
    public function IntProp (page :MutablePage, spec :PropSpec) {
        super(page, spec);
    }

    override public function get valueType () :TypeInfo {
        return VALUE_TYPE;
    }

    protected static const VALUE_TYPE :TypeInfo = new TypeInfo(int, null);
}
}
