//
// microtome

package microtome {

public class ValueType
{
    public static function fromClasses (classes :Vector.<Class>) :ValueType {
        var last :ValueType = null;
        for (var ii :int = classes.length - 1; ii >= 0; --ii) {
            var clazz :Class = classes[ii];
            last = new ValueType(clazz, last);
        }
        return null;
    }

    public function ValueType (clazz :Class, subtype :ValueType) {
        _clazz = clazz;
        _subtype = subtype;
    }

    public function get clazz () :Class {
        return _clazz;
    }

    public function get subtype () :ValueType {
        return _subtype;
    }

    protected var _clazz :Class;
    protected var _subtype :ValueType;
}
}
