//
// microtome

package microtome.xml {

import microtome.core.ReadableObject;
import microtome.core.WritableObject;
import microtome.error.LoadError;
import microtome.util.Util;

internal class XmlElement
    implements ReadableObject, WritableObject
{
    public function XmlElement (xml :XML) {
        _xml = xml;
    }

    public function get name () :String {
        return _xml.localName();
    }

    public function get debugDescription () :String {
        return toXMLString(_xml);
    }

    public function get children () :Vector.<ReadableObject> {
        var children :Vector.<ReadableObject> = new <ReadableObject>[];
        for each (var child :XML in _xml.elements()) {
            children.push(new XmlElement(child));
        }
        return children;
    }

    public function hasValue (name :String) :Boolean {
        return _xml.attribute(name)[0] != null;
    }

    public function getString (name :String) :String {
        const out :String = _xml.attribute(name)[0];
        if (out == null) {
            throw new LoadError(this, "Missing required attribute", "name", name);
        }
        return out;
    }

    public function getBool (name :String) :Boolean {
        const attr :String = getString(name).toLowerCase();
        if (attr == "true" || attr == "yes") {
            return true;
        } else if (attr == "false" || attr == "no") {
            return false;
        }

        throw new LoadError(this, "attribute is not a boolean", "name", name, "value", attr);
    }

    public function getInt (name :String) :int {
        const attr :String = getString(name);
        try {
            return Util.parseInteger(attr);
        } catch (e :Error) {
            throw new LoadError(this, "attribute is not an int", "name", name, "value", attr);
        }
        return 0;
    }

    public function getNumber (name :String) :Number {
        const attr :String = getString(name);
        try {
            return Util.parseNumber(attr);
        } catch (e :Error) {
            throw new LoadError(this, "attribute is not a Number", "name", name, "value", attr);
        }
        return 0;
    }

    public function addChild (name :String) :WritableObject {
        const child :XML = <{name}/>;
        _xml.appendChild(child);
        return new XmlElement(child);
    }

    public function writeString (name :String, val :String) :void {
        _xml.@[name] = val;
    }

    public function writeBool (name :String, val :Boolean) :void {
        writeString(name, (val ? "true" : "false"));
    }

    public function writeNumber (name :String, val :Number) :void {
        writeString(name, "" + val);
    }

    public function writeInt (name :String, val :int) :void {
        writeString(name, "" + val);
    }

    /**
     * Call toXMLString() on the specified XML object safely. This is equivalent to
     * <code>xml.toXMLString()</code> but offers protection from other code that may have changed
     * the default settings used for stringing XML. Also, if you would like to use the
     * non-standard printing settings this method will protect other code from being
     * broken by you.
     *
     * @param xml the xml value to Stringify.
     * @param settings an Object containing your desired XML settings, or null (or omitted) to
     * use the default settings.
     * @see XML#toXMLString()
     * @see XML#setSettings()
     */
    protected static function toXMLString (xml :XML, settings :Object = null) :String {
        return safeOp(function () :* {
            return xml.toXMLString();
        }, settings) as String;
    }

    /**
     * Perform an operation on XML that takes place using the specified settings, and
     * restores the XML settings to their previous values.
     *
     * @param fn a function to be called with no arguments.
     * @param settings an Object containing your desired XML settings, or null (or omitted) to
     * use the default settings.
     *
     * @return the return value of your function, if any.
     * @see XML#setSettings()
     * @see XML#settings()
     */
    protected static function safeOp (fn :Function, settings :Object = null) :* {
        var oldSettings :Object = XML.settings();
        try {
            XML.setSettings(settings); // setting to null resets to all the defaults
            return fn();
        } finally {
            XML.setSettings(oldSettings);
        }
    }

    protected var _xml :XML;
    protected var _value :String;
    protected var _children :Array;
}
}
