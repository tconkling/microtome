//
// microtome

package microtome {

public class TypeInfo
{
    public static function fromClasses (classes :Array) :TypeInfo {
        var last :TypeInfo = null;
        for (var ii :int = classes.length - 1; ii >= 0; --ii) {
            var clazz :Class = classes[ii];
            last = new TypeInfo(clazz, last);
        }
        return null;
    }

    public function TypeInfo (clazz :Class, subtype :TypeInfo) {
        _clazz = clazz;
        _subtype = subtype;
    }

    public function get clazz () :Class {
        return _clazz;
    }

    public function get subtype () :TypeInfo {
        return _subtype;
    }

    protected var _clazz :Class;
    protected var _subtype :TypeInfo;
}
}
