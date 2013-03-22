//
// microtome

package microtome.core {

public interface ReadableObject
{
    function get name () :String;
    function get debugDescription () :String;
    function get children () :Vector.<ReadableObject>;

    function hasValue (name :String) :Boolean;
    function getBool (name :String) :Boolean;
    function getInt (name :String) :int;
    function getNumber (name :String) :Number;
    function getString (name :String) :String;
}
}
