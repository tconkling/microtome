//
// microtome

package microtome.prop {

import microtome.MutablePage;
import microtome.core.TypeInfo;

public final class NumberProp extends Prop
{
    public function NumberProp (page :MutablePage, spec :PropSpec) {
        super(page, spec);
    }

    override public function get valueType () :TypeInfo {
        return VALUE_TYPE;
    }

    protected static const VALUE_TYPE :TypeInfo = new TypeInfo(Number, null);
}
}
