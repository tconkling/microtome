//
// microtome

package microtome.core {

public interface Annotation
{
    function boolValue (defaultVal :Boolean) :Boolean;
    function intValue (defaultVal :int) :int;
    function numberValue (defaultVal :Number) :Number;
    function stringValue (defaultVal :String) :String;
}
}
