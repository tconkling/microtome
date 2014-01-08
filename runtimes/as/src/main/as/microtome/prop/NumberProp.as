//
// microtome

package microtome.prop {

import microtome.MutableTome;

public final class NumberProp extends Prop
{
    public function NumberProp (tome :MutableTome, spec :PropSpec) {
        super(tome, spec);
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
