package microtome.json {

import microtome.core.ReadableObject;
import microtome.core.WritableObject;

public class JsonObject extends JsonElement
    implements ReadableObject, WritableObject
{
    public function JsonObject (name :String, value :Object) {
        super(name, value);
    }

    public function get children () :Vector.<ReadableObject> {
        var children :Vector.<ReadableObject> = new <ReadableObject>[];
        for (var prop :String in _value) {
            if (!_value.hasOwnProperty(prop) || _value[prop] == null) {
                continue;
            }
            if (!isPrimitive(_value[prop])) {
                var child :Object = _value[prop];
                children.push(child is Array ?
                    new JsonArray(prop, child as Array) :
                    new JsonObject(prop, child));
            }
        }
        return children;
    }

    public function hasValue (name :String) :Boolean {
        return _value.hasOwnProperty(name) && _value[name] != null && isPrimitive(_value[name]);
    }

    public function getBool (name :String) :Boolean {
        requireType(_value[name], Boolean);
        return _value[name] as Boolean;
    }

    public function getInt (name :String) :int {
        requireType(_value[name], int);
        return _value[name] as int;
    }

    public function getNumber (name :String) :Number {
        requireType(_value[name], Number);
        return _value[name] as Number;
    }

    public function getString (name :String) :String {
        // coerce any primitive value into a string
        if (!isPrimitive(_value[name])) {
            throw new Error("Complex value [" + name + "]");
        }
        return String(_value[name]);
    }

    public function addChild (name :String, isList :Boolean = false) :WritableObject {
        return isList ?
            _value[name] = new JsonArray(name, []) :
            _value[name] = new JsonObject(name, {});
    }

    public function writeBool (name :String, val :Boolean) :void {
        _value[name] = val;
    }

    public function writeInt (name :String, val :int) :void {
        _value[name] = val;
    }

    public function writeNumber (name :String, val :Number) :void {
        _value[name] = val;
    }

    public function writeString (name :String, val :String) :void {
        _value[name] = val;
    }
}
}
