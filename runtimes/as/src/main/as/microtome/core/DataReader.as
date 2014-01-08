//
// microtome

package microtome.core {

import flash.utils.Dictionary;

import microtome.error.LoadError;
import microtome.util.ClassUtil;
import microtome.util.Util;

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

    public function getInts (name :String, count :uint = 0, delim :String = ",", defaultVal :Array = null) :Array {
        return (hasValue(name) ? requireInts(name, count, delim) : defaultVal);
    }

    public function getNumbers (name :String, count :uint = 0, delim :String = ",", defaultVal :Array = null) :Array {
        return (hasValue(name) ? requireNumbers(name, count, delim) : defaultVal);
    }

    public function requireString (name :String) :String {
        return _data.getString(name);
    }

    public function requireBool (name :String) :Boolean {
        try {
            return _data.getBool(name);
        } catch (e :Error) {
            throw new LoadError(_data, "error loading boolean", "name", name).initCause(e);
        }
        return false;
    }

    public function requireInt (name :String) :int {
        try {
            return _data.getInt(name);
        } catch (e :Error) {
            throw new LoadError(_data, "error loading int", "name", name).initCause(e);
        }
        return 0;
    }

    public function requireNumber (name :String) :Number {
        try {
            return _data.getNumber(name);
        } catch (e :Error) {
            throw new LoadError(_data, "error loading Number", "name", name).initCause(e);
        }
        return 0;
    }

    public function requireInts (name :String, count :uint = 0, delim :String = ",") :Array {
        return requireList(name, count, delim, int, function (str :String) :int {
            return Util.parseInteger(str, 0);
        });
    }

    public function requireNumbers (name :String, count :uint = 0, delim :String = ",") :Array {
        return requireList(name, count, delim, Number, Util.parseNumber);
    }

    protected function requireList (name :String, count :uint, delim :String, type :Class, parser :Function) :Array {
        var out :Array = null;
        try {
            out = requireString(name).split(delim).map(function (str :String, ..._) :int {
                return parser(str);
            });
        } catch (e :LoadError) {
            throw e;

        } catch (e :Error) {
            throw new LoadError(_data, "error loading " + ClassUtil.tinyClassName(type) + " list",
                "name", name).initCause(e);
        }

        if (count > 0 && out.length != count) {
            throw new LoadError(_data, "bad " + ClassUtil.tinyClassName(type) + " list length",
                "name", name, "required", count, "got", out.length);
        }

        return out;
    }

    protected var _data :ReadableObject;
    protected var _children :Vector.<DataReader>;
    protected var _childrenByName :Dictionary;
}
}
