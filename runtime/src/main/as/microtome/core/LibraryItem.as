//
// microtome

package microtome.core {

public interface LibraryItem
{
    function get name () :String;
    function get typeInfo () :TypeInfo;

    function childNamed (name :String) :*;
}
}
