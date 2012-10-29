//
// microtome

package microtome {

import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

public class Util
{
    /**
     * Get the full class name, e.g. "com.threerings.util.ClassUtil".
     * Calling getClassName with a Class object will return the same value as calling it with an
     * instance of that class. That is, getClassName(Foo) == getClassName(new Foo()).
     */
    public static function getClassName (obj :Object) :String {
        return getQualifiedClassName(obj).replace("::", ".");
    }

    /**
     * Get just the class name, e.g. "ClassUtil".
     */
    public static function tinyClassName (obj :Object) :String
    {
        var s :String = getClassName(obj);
        var dex :int = s.lastIndexOf(".");
        return s.substring(dex + 1); // works even if dex is -1
    }

    public static function getClass (obj :Object) :Class {
        return Object(obj).constructor;
    }

    public static function getProp (page :Page, name :String) :Prop {
        for each (var prop :Prop in page.props) {
            if (prop.name == name) {
                return prop;
            }
        }
        return null;
    }
}
}
