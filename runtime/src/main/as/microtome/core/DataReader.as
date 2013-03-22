//
// microtome

package microtome.core {

import flash.utils.Dictionary;

import microtome.error.LoadError;
import microtome.util.Util;

public class DataReader
    implements DataElement
{
    public static function withData (data :DataElement) :DataReader {
        return (data is DataReader ? DataReader(data) : new DataReader(data));
    }

    public function getChild (name :String) :DataElement {
        if (_childrenByName == null) {
            _childrenByName = new Dictionary();
            for each (var child :DataElement in this.children) {
                _childrenByName[child.name] = child;
            }
        }
        return _childrenByName[name];
    }

    public function getStringAttribute (name :String, defaultVal :String = null) :String {
        var attr :String = getAttribute(name);
        return (attr != null ? attr : defaultVal);
    }

    public function getBoolAttribute (name :String, defaultVal :Boolean = false) :Boolean {
        return (hasAttribute(name) ? requireBoolAttribute(name) : defaultVal);
    }

    public function getIntAttribute (name :String, defaultVal :int = 0) :int {
        return (hasAttribute(name) ? requireIntAttribute(name) : defaultVal);
    }

    public function getNumberAttribute (name :String, defaultVal :Number = 0) :Number {
        return (hasAttribute(name) ? requireNumberAttribute(name) : defaultVal);
    }

    public function requireAttribute (name :String) :String {
        var attr :String = getAttribute(name);
        if (attr == null) {
            throw new LoadError(_data, "Missing required attribute", "name", name);
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

        throw new LoadError(_data, "attribute is not a boolean", "name", name,
            "value", requireAttribute(name));
    }

    public function requireIntAttribute (name :String) :int {
        var attr :String = requireAttribute(name);
        try {
            return Util.parseInteger(attr);
        } catch (e :Error) {
            throw new LoadError(_data, "attribute is not an int", "name", name, "value", attr);
        }
        return 0;
    }

    public function requireNumberAttribute (name :String) :Number {
        var attr :String = requireAttribute(name);
        try {
            return Util.parseNumber(attr);
        } catch (e :Error) {
            throw new LoadError(_data, "attribute is not a Number", "name", name, "value", attr);
        }
        return 0;
    }

    public function hasAttribute (name :String) :Boolean {
        return (getAttribute(name) != null);
    }

    public function hasChild (name :String) :Boolean {
        return (getChild(name) != null);
    }

    public function get children () :Vector.<DataElement> {
        if (_children == null) {
            _children = _data.children;
        }
        return _children;
    }

    public function get name () :String {
        return _data.name;
    }

    public function get debugDescription () :String {
        return _data.debugDescription;
    }

    public function getAttribute (name :String) :String {
        return _data.getAttribute(name);
    }

    // private
    public function DataReader (data :DataElement) {
        _data = data;
    }

    protected var _data :DataElement;
    protected var _children :Vector.<DataElement>;
    protected var _childrenByName :Dictionary;
}
}
