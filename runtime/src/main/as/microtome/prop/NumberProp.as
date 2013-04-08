//
// microtome

package microtome.prop {

import microtome.MutablePage;

public final class NumberProp extends Prop
{
    public function NumberProp (page :MutablePage, spec :PropSpec) {
        super(page, spec);
    }

    override public function get value () :* {
        return _value;
    }

    override public function set value (val :*) :void {
        _value = val;
    }

    protected var _value :Number;
}
}
