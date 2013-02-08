//
// microtome

package microtome.prop {

public /*abstract*/ class Prop
{
    public function Prop (spec :PropSpec) {
        _spec = spec;
    }

    public function get spec () :PropSpec {
        return _spec;
    }

    protected var _spec :PropSpec;
}
}
