package microtome.json {

import microtome.core.ReadableObject;
import microtome.core.WritableObject;

public class JsonArray extends JsonElement
    implements ReadableObject, WritableObject
{
    public function JsonArray (name :String, obj :Array) {
        super(name, obj);
    }

    public function get children () :Vector.<ReadableObject> {
        var children :Vector.<ReadableObject> = new <ReadableObject>[];
        array.forEach(function (child :Object, ..._) :void {
            children.push(child is Array ?
                new JsonArray(null, child as Array) : new JsonObject(null, child));
        });
        return children;
    }

    public function hasValue (name :String) :Boolean {
        return false;
    }

    public function getBool (name :String) :Boolean {
        requireType(Boolean);
        return array[_readHead++] as Boolean;
    }

    public function getInt (name :String) :int {
        requireType(int);
        return array[_readHead++] as int;
    }

    public function getNumber (name :String) :Number {
        requireType(Number);
        return array[_readHead++] as Number;
    }

    public function getString (name :String) :String {
        // coerce any primitive value into a string
        if (!isPrimitive()) {
            throw new Error("Complex value at readHead");
        }
        return String(array[_readHead++]);
    }

    public function addChild (name :String, isList :Boolean = false) :WritableObject {
        return isList ? new JsonArray(null, []) : new JsonObject(null, {});
    }

    public function writeBool (name :String, val :Boolean) :void {
        array.push(val);
    }

    public function writeInt (name :String, val :int) :void {
        array.push(val);
    }

    public function writeNumber (name :String, val :Number) :void {
        array.push(val);
    }

    public function writeString (name :String, val :String) :void {
        array.push(val);
    }

    protected function get array () :Array {
        return _value as Array;
    }

    protected function requireType (type :Class) :void {
        if (!(array[_readHead] is type)) {
            throw new Error("Type is not correct [" + name + ", " + array[name] + "]");
        }
    }

    protected function isPrimitive () :Boolean {
        return array[_readHead] is Boolean || array[_readHead] is Number ||
            array[_readHead] is String;
    }

    // used to track primitive reads from this array.
    protected var _readHead :int = 0;
}
}
