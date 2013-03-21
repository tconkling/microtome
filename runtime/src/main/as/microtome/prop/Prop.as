//
// microtome

package microtome.prop {
import microtome.MutablePage;
import microtome.core.TypeInfo;

public /*abstract*/ class Prop
{
    public function Prop (page :MutablePage, spec :PropSpec) {
        _page = page;
        _spec = spec;
    }

    public function get value () :* {
        return _value;
    }

    public function set value (val :*) :void {
        _value = val;
    }

    public function get valueType () :TypeInfo {
        throw new Error("abstract");
    }

    public final function get name () :String {
        return _spec.name;
    }

    public final function hasAnnotation (name :String) :Boolean {
        return (name in _spec.annotations);
    }

    public final function boolAnnotation (name :String, defaultVal :Boolean) :Boolean {
        var val :* = _spec.annotations[name];
        return (val is Boolean ? val : defaultVal);
    }

    public final function intAnnotation (name :String, defaultVal :int) :int {
        var val :* = _spec.annotations[name];
        return (val is int ? val : defaultVal);
    }

    public final function numberAnnotation (name :String, defaultVal :Number) :Number {
        var val :* = _spec.annotations[name];
        return (val is Number ? val : defaultVal);
    }

    public final function stringAnnotation (name :String, defaultVal :String) :String {
        var val :* = _spec.annotations[name];
        return (val is String ? val : defaultVal);
    }


    protected var _value :Object;

    protected var _page :MutablePage;
    protected var _spec :PropSpec;
}
}
