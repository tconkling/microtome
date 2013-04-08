//
// microtome

package microtome.prop {

import microtome.MutablePage;

public final class BoolProp extends Prop
{
    public function BoolProp (page :MutablePage, spec :PropSpec) {
        super(page, spec);
    }

    override public function get value () :* {
        return _value;
    }

    override public function set value (val :*) :void {
        _value = val;
    }

    protected var _value :Boolean;
}
}
