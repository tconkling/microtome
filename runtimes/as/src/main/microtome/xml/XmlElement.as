//
// microtome

package microtome.xml {

import microtome.core.ReadableObject;
import microtome.core.WritableObject;
import microtome.util.Util;

internal class XmlElement
    implements ReadableObject, WritableObject
{
    public function XmlElement (xml :XML, isList :Boolean) {
        _xml = xml;
        // we are only created to wrap a primitive in the case of reading a list.
        var children :XMLList = xml.children();
        _isPrimitive = xml.attributes().length() == 0 &&
            children.length() == 1 && children[0].nodeKind() == "text";
        _isList = !_isPrimitive && isList;
    }

    public function get name () :String {
        return _isPrimitive ? null : _xml.localName();
    }

    public function get debugDescription () :String {
        var out :String = toXMLString(_xml, { prettyIndent: 2, prettyPrinting: true });
        return out.split("\n")[0];
    }

    public function get children () :Vector.<ReadableObject> {
        if (_isPrimitive) {
            return new <ReadableObject>[];
        }
        var children :Vector.<ReadableObject> = new <ReadableObject>[];
        for each (var child :XML in _xml.elements()) {
            // assume that a child with no properties is a list, the XMLElement constructor will
            // catch the case of a primitive.
            children.push(new XmlElement(child, child.attributes().length() == 0));
        }
        return children;
    }

    public function hasValue (name :String) :Boolean {
        return (_isPrimitive && name == null) || _xml.attribute(name)[0] != null;
    }

    public function getString (name :String) :String {
        const out :String = _isPrimitive ? _xml[0] : _xml.attribute(name)[0];
        if (out == null) {
            throw new Error("Missing string attribute");
        }
        return out;
    }

    public function getBool (name :String) :Boolean {
        const attr :String = getString(name).toLowerCase();
        if (attr == "true" || attr == "yes") {
            return true;
        } else if (attr == "false" || attr == "no") {
            return false;
        } else {
            throw new Error("not a boolean");
        }
    }

    public function getInt (name :String) :int {
        return Util.parseInteger(getString(name));
    }

    public function getNumber (name :String) :Number {
        return Util.parseNumber(getString(name));
    }

    public function addChild (name :String, isList :Boolean = false) :WritableObject {
        const child :XML = <{name}/>;
        _xml.appendChild(child);
        return new XmlElement(child, isList);
    }

    public function writeString (name :String, val :String) :void {
        if (_isList) {
            _xml.appendChild(<value/>.appendChild(val));
        } else {
            _xml.@[name] = val;
        }
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
    protected var _isPrimitive :Boolean;
    protected var _isList :Boolean;
}
}
