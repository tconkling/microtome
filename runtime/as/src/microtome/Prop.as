//
// microtome

package microtome {

public /*abstract*/ class Prop
{
    public function Prop (spec :PropSpec) {
        _spec = spec;
    }

    public function get name () :String {
        return _spec.name;
    }

    public function hasAnnotation (name :String) :Boolean {
        return (name in _spec.annotations);
    }

    public function boolAnnotation (name :String, defaultVal :Boolean) :Boolean {
        var val :* = _spec.annotations[name];
        return (val is Boolean ? val : defaultVal);
    }

    public function intAnnotation (name :String, defaultVal :int) :int {
        var val :* = _spec.annotations[name];
        return (val is int ? val : defaultVal);
    }

    public function numberAnnotation (name :String, defaultVal :Number) :Number {
        var val :* = _spec.annotations[name];
        return (val is Number ? val : defaultVal);
    }

    public function stringAnnotation (name :String, defaultVal :String) :String {
        var val :* = _spec.annotations[name];
        return (val is String ? val : defaultVal);
    }

    protected var _spec :PropSpec;
}
}
