//
// microtome

package microtome {
import flash.utils.Dictionary;

public class DataReader
    implements DataElement
{
    public static function withData (data :DataElement) :DataReader {
        return (data is DataReader ? DataReader(data) : new DataReader(data));
    }

    public function get children () :Array {
        return getAllChildren();
    }

    public function childNamed (name :String) :DataElement {
        if (_childrenByName == null) {
            _childrenByName = new Dictionary();
            for each (var child :DataElement in this.children) {
                _childrenByName[child.name] = child;
            }
        }
        return _childrenByName[name];
    }

    public function requireValue () :String {
        var val :String = _data.value;
        if (val == null) {
            throw new LoadError("Element is empty", _data);
        }
        return val;
    }

    public function requireAttribute (name :String) :String {
        var attr :String = attributeNamed(name);
        if (attr == null) {
            throw new LoadError("Missing required attribute '" + name + "'", _data);
        }
        return attr;
    }

    public function requireBoolAttribute (name :String) :Boolean {
        var attr :String = requireAttribute(name).toLowerCase();
        if (attr == "true" || attr == "yes") {
            return true;
        } else if (attr == "false" || attr == "no") {
            return false;
        }

        throw new LoadError("attribute is not a boolean [name=" + name +
            ", value=" + requireAttribute(name) + "]", _data);
    }

    public function requireIntAttribute (name :String) :int {
        var attr :String = requireAttribute(name);
        try {
            return Util.parseInteger(attr);
        } catch (e :Error) {
            throw new LoadError("attribute is not an int [name=" + name +
                ", value=" + attr + "]", _data);
        }
        return 0;
    }

    public function requireNumberAttribute (name :String) :Number {
        var attr :String = requireAttribute(name);
        try {
            return Util.parseNumber(attr);
        } catch (e :Error) {
            throw new LoadError("attribute is not a Number [name=" + name +
                ", value=" + attr + "]", _data);
        }
        return 0;
    }

    public function hasAttribute (name :String) :Boolean {
        return (attributeNamed(name) != null);
    }

    public function hasChild (name :String) :Boolean {
        return (childNamed(name) != null);
    }

    public function getAllChildren () :Array {
        if (_children == null) {
            _children = _data.getAllChildren();
        }
        return _children;
    }

    public function get name () :String {
        return _data.name;
    }

    public function get value () :String {
        return _data.value;
    }

    public function get description () :String {
        return _data.description;
    }

    public function attributeNamed (name :String) :String {
        return _data.attributeNamed(name);
    }

    // private
    public function DataReader (data :DataElement) {
        _data = data;
    }

    protected var _data :DataElement;
    protected var _children :Array;
    protected var _childrenByName :Dictionary;
}
}
