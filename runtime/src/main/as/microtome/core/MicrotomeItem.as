//
// microtome

package microtome.core {
import microtome.Library;

/** The common interface for LibraryItems and the Library itself */
public interface MicrotomeItem
{
    function get name () :String;
    function get library () :Library;
    function get parent () :MicrotomeItem;
}
}
