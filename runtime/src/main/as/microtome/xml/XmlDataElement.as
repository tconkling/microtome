//
// microtome

package microtome.xml {

import microtome.core.DataElement;

internal class XmlDataElement
    implements DataElement
{
    public function XmlDataElement (xml :XML) {
        _xml = xml;
    }

    public function get name () :String {
        return _xml.localName();
    }

    public function get debugDescription () :String {
        return toXMLString(_xml);
    }

    public function get children () :Vector.<DataElement> {
        var children :Vector.<DataElement> = new <DataElement>[];
        for each (var child :XML in _xml.elements()) {
            children.push(new XmlDataElement(child));
        }
        return children;
    }

    public function getAttribute (name :String) :String {
        return _xml.attribute(name)[0];
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
