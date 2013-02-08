//
// microtome

package microtome.prop {

import flash.utils.Dictionary;

import microtome.core.Defs;
import microtome.core.TypeInfo;

public class PropSpec
{
    public var name :String;
    public var annotations :Dictionary;
    public var valueType :TypeInfo;

    public function PropSpec (name :String, annos :Object, valueClasses :Array) {
        this.name = name;
        this.annotations = (annos != null ? new Dictionary() : EMPTY_DICT);
        if (annos != null) {
            for (var key :String in annos) {
                this.annotations[key] = annos[key];
            }
        }
        this.valueType = (valueClasses != null ? TypeInfo.fromClasses(valueClasses) : null);
    }

    public function hasAnnotation (name :String) :Boolean {
        return (name in annotations);
    }

    public function get nullable () :Boolean {
        return boolAnnotation(Defs.NULLABLE_ATTR, false);
    }

    public function boolAnnotation (name :String, defaultVal :Boolean) :Boolean {
        var val :* = annotations[name];
        return (val is Boolean ? val : defaultVal);
    }

    public function intAnnotation (name :String, defaultVal :int) :int {
        var val :* = annotations[name];
        return (val is int ? val : defaultVal);
    }

    public function numberAnnotation (name :String, defaultVal :Number) :Number {
        var val :* = annotations[name];
        return (val is Number ? val : defaultVal);
    }

    public function stringAnnotation (name :String, defaultVal :String) :String {
        var val :* = annotations[name];
        return (val is String ? val : defaultVal);
    }

    protected static const EMPTY_DICT :Dictionary = new Dictionary();
}
}
