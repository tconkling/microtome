//
// microtome

package microtome.prop {

import flash.utils.Dictionary;

import microtome.core.Annotation;
import microtome.core.TypeInfo;

public class PropSpec
{
    public var name :String;
    public var valueType :TypeInfo;

    public function PropSpec (name :String, annos :Object, valueClasses :Array) {
        this.name = name;
        _annotations = (annos != null ? new Dictionary() : EMPTY_DICT);
        if (annos != null) {
            for (var key :String in annos) {
                _annotations[key] = new PropAnnotation(annos[key]);
            }
        }
        this.valueType = (valueClasses != null ? TypeInfo.fromClasses(valueClasses) : null);
    }

    public function hasAnnotation (name :String) :Boolean {
        return (name in _annotations);
    }

    public function getAnnotation (name :String) :Annotation {
        var anno :Annotation = _annotations[name];
        if (anno != null) {
            return anno;
        }
        if (NULL_ANNO == null) {
            NULL_ANNO = new PropAnnotation(null);
        }
        return NULL_ANNO;
    }

    protected var _annotations :Dictionary;

    protected static const EMPTY_DICT :Dictionary = new Dictionary();
    protected static var NULL_ANNO :Annotation;
}
}

import microtome.core.Annotation;

class PropAnnotation implements Annotation
{
    public function PropAnnotation (value :Object) {
        _value = value;
    }

    public function boolValue (defaultVal :Boolean) :Boolean {
        return (_value is Boolean ? _value : defaultVal);
    }

    public function intValue (defaultVal :int) :int {
        return (_value is int ? _value : defaultVal);
    }

    public function numberValue (defaultVal :Number) :Number {
        return (_value is Number ? _value : defaultVal);
    }

    public function stringValue (defaultVal :String) :String {
        return (_value is String ? _value : defaultVal);
    }

    protected var _value :*;
}

