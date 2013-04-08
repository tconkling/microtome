//
// microtome

package microtome.core {

public interface Annotatable
{
    function hasAnnotation (name :String) :Boolean;
    function boolAnnotation (name :String, defaultVal :Boolean) :Boolean;
    function intAnnotation (name :String, defaultVal :int) :int;
    function numberAnnotation (name :String, defaultVal :Number) :Number;
    function stringAnnotation (name :String, defaultVal :String) :String;
}
}
