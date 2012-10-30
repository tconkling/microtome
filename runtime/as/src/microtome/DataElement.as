//
// microtome

package microtome {

public interface DataElement
{
    function get name () :String;
    function get value () :String;
    function get description () :String;

    function getAllChildren () :Array;

    function attributeNamed (name :String) :String;

}
}
