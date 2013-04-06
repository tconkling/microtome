//
// microtome

package microtome.core {

import flash.utils.Dictionary;

import microtome.error.LoadError;

/** Wraps a ReadableElement and provides additional convenience functions */
public class DataReader
{
    public function DataReader (data :ReadableObject) {
        _data = data;
    }

    public function get data () :ReadableObject {
        return _data;
    }

    public function get name () :String {
        return _data.name;
    }

    public function hasValue (name :String) :Boolean {
        return _data.hasValue(name);
    }

    public function get children () :Vector.<DataReader> {
        if (_children == null) {
            _children = new <DataReader>[];
            for each (var element :ReadableObject in _data.children) {
                _children.push(new DataReader(element));
            }
        }
        return _children;
    }

    public function hasChild (name :String) :Boolean {
        return (getChild(name) != null);
    }

    public function getChild (name :String) :DataReader {
        if (_childrenByName == null) {
            _childrenByName = new Dictionary();
            for each (var child :DataReader in this.children) {
                _childrenByName[child.name] = child;
            }
        }
        return _childrenByName[name];
    }

    public function requireChild (name :String) :DataReader {
        var child :DataReader = getChild(name);
        if (child == null) {
            throw new LoadError(_data, "Missing required child", "name", name);
        }
        return child;
    }

    public function getString (name :String, defaultVal :String = null) :String {
        return (hasValue(name) ? _data.getString(name) : defaultVal);
    }

    public function getBool (name :String, defaultVal :Boolean = false) :Boolean {
        return (hasValue(name) ? requireBool(name) : defaultVal);
    }

    public function getInt (name :String, defaultVal :int = 0) :int {
        return (hasValue(name) ? requireInt(name) : defaultVal);
    }

    public function getNumber (name :String, defaultVal :Number = 0) :Number {
        return (hasValue(name) ? requireNumber(name) : defaultVal);
    }

    public function requireString (name :String) :String {
        return _data.getString(name);
    }

    public function requireBool (name :String) :Boolean {
        return _data.getBool(name);
    }

    public function requireInt (name :String) :int {
        return _data.getInt(name);
    }

    public function requireNumber (name :String) :Number {
        return _data.getNumber(name);
    }

    protected var _data :ReadableObject;
    protected var _children :Vector.<DataReader>;
    protected var _childrenByName :Dictionary;
}
}
