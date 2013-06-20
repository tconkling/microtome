package microtome.json {

import microtome.core.ReadableObject;

/** Only used for JsonArray.get children() */
public class JsonPrimitive extends JsonElement
    implements ReadableObject
{
    public function JsonPrimitive (value :Object) {
        super(null, value);
    }

    public function get children () :Vector.<ReadableObject> {
        return new <ReadableObject>[];
    }

    public function hasValue (name :String) :Boolean {
        return name == null;
    }

    public function getBool (name :String) :Boolean {
        requireType(_value, Boolean);
        return _value as Boolean;
    }

    public function getInt (name :String) :int {
        requireType(_value, int);
        return _value as int;
    }

    public function getNumber (name :String) :Number {
        requireType(_value, Number);
        return _value as Number;
    }

    public function getString (name :String) :String {
        return String(_value);
    }
}
}
