//
// microtome

package microtome.core {

public interface DataElement
{
    function get name () :String;
    function get children () :Vector.<DataElement>;
    function getAttribute (name :String) :String;

    function get debugDescription () :String;
}
}
