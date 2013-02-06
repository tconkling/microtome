//
// microtome

package microtome.core {

public interface LibraryItem
{
    function get name () :String;
    function get type () :TypeInfo;

    function childNamed (name :String) :*;
}
}
