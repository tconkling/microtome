//
// microtome

package microtome.json {

public /* abstract */ class JsonElement
{
    public function JsonElement (name :String, value :Object) {
        _name = name;
        _value = value;
    }

    public function get name () :String {
        return _name;
    }

    public function get debugDescription () :String {
        var debug :Object = {};
        debug[_name] = _value;
        return JSON.stringify(debug, null, 2);
    }

    protected function requireType (value :Object, type :Class) :void {
        if (!(value is type)) {
            throw new Error("Type is not correct [" + type + ", " +
                JSON.stringify(value, null, 2) + "]");
        }
    }

    protected function isPrimitive (value :Object) :Boolean {
        return value is Boolean || value is Number || value is String;
    }

    protected var _name :String;
    protected var _value :Object;
}
}
