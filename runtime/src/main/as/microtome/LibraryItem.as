//
// microtome

package microtome {

public interface LibraryItem
{
    function get name () :String;
    function get type () :TypeInfo;

    function childNamed (name :String) :*;
}
}
