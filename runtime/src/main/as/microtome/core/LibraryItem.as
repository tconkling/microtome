//
// microtome

package microtome.core {

public interface LibraryItem extends MicrotomeItem
{
    function get typeInfo () :TypeInfo;
    function childNamed (name :String) :*;
}
}
