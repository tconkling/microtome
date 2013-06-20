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
        return JSON.stringify(debug, 2);
    }

    protected var _name :String;
    protected var _value :Object;
}
}
