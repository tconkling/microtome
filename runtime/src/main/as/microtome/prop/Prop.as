//
// microtome

package microtome.prop {

import microtome.MutablePage;
import microtome.core.Annotation;
import microtome.core.Defs;
import microtome.core.TypeInfo;

public /*abstract*/ class Prop
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
        return annotation(Defs.NULLABLE_ANNOTATION).boolValue(false);
    }

    public final function get hasDefault () :Boolean {
        return hasAnnotation(Defs.DEFAULT_ANNOTATION);
    }

    public final function get name () :String {
        return _spec.name;
    }

    public final function hasAnnotation (name :String) :Boolean {
        return _spec.hasAnnotation(name);
    }

    public final function annotation (name :String) :Annotation {
        return _spec.getAnnotation(name);
    }

    protected var _page :MutablePage;
    protected var _spec :PropSpec;
}
}
