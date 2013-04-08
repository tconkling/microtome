//
// microtome

package microtome.prop {

import microtome.MutablePage;
import microtome.core.Annotatable;
import microtome.core.Defs;
import microtome.core.TypeInfo;

public /*abstract*/ class Prop
    implements Annotatable
{
    public function Prop (page :MutablePage, spec :PropSpec) {
        _page = page;
        _spec = spec;
    }

    public function get value () :* {
        throw new Error("abstract");
    }

    public function set value (val :*) :void {
        throw new Error("abstract");
    }

    public final function get valueType () :TypeInfo {
        return _spec.valueType;
    }

    public final function get nullable () :Boolean {
        return boolAnnotation(Defs.NULLABLE_ANNOTATION, false);
    }

    public final function get hasDefault () :Boolean {
        return hasAnnotation(Defs.DEFAULT_ANNOTATION);
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

    protected var _page :MutablePage;
    protected var _spec :PropSpec;
}
}
