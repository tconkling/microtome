//
// microtome

package microtome.prop {

import microtome.MutableTome;

public final class BoolProp extends Prop
{
    public function BoolProp (tome :MutableTome, spec :PropSpec) {
        super(tome, spec);
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
