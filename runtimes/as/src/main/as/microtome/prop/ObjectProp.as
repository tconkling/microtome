//
// microtome

package microtome.prop {

import microtome.MutableTome;

public final class ObjectProp extends Prop
{
    public function ObjectProp (tome :MutableTome, spec :PropSpec) {
        super(tome, spec);
    }

    override public function get value () :* {
        return _value;
    }

    override public function set value (val :*) :void {
        if (_value == val) {
            return;
        }

        if (_value is MutableTome) {
            _tome.removeChild(MutableTome(_value));
        }
        _value = val;
        if (_value is MutableTome) {
            _tome.addChild(MutableTome(_value));
        }
    }

    protected var _value :Object;
}
}
