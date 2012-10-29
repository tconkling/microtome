//
// microtome

package microtome {

public interface LibraryItem
{
    function get name () :String;
    function get type () :ValueType;

    function childNamed (name :String) :*;
}
}
