//
// microtome

package microtome {

import microtome.core.LibraryItem;

/**
 * A Tome is a collection of uniquely-named Pages.
 */
public interface Tome extends LibraryItem
{
    /** @return the base class for Pages in the Tome */
    function get pageClass () :Class;

    /** @return the number of Pages in the Tome */
    function get length () :uint;

    /** @return the Page with the given name, or null if no such page is in the Tome */
    function getPage (name :String) :*;

    /** @return the Page with the given name. Throws an error if there is no such page. */
    function requirePage (name :String) :*;
}
}
