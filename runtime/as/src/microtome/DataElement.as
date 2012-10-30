//
// microtome

package microtome {

public interface DataElement
{
    function get name () :String;
    function get value () :String;
    function get description () :String;

    function get children () :Array;

    function childNamed (name :String) :DataElement;
    function attributeNamed (name :String) :String;

}
}
