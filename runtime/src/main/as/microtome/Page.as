//
// microtome

package microtome {

import microtome.core.LibraryItem;

public interface Page extends LibraryItem
{
    function get fullyQualifiedName () :String;
}
}
