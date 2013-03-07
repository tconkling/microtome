//
// microtome

package microtome {

import microtome.core.LibraryItem;

/**
 * A Tome is a collection of uniquely-named Pages.
 *
 * For page lookup and iteration, Tome behaves like Dictionary. You can retrieve pages
 * using <code>myTome["page_name"]</code>, and iterate names and values using
 * <code>for (key in myTome)</code> and <code>for each (page in myTome)</code>.
 */
public interface Tome extends LibraryItem
{
    /** @return the base class for Pages in the Tome */
    function get pageClass () :Class;

    /** @return the number of Pages in the Tome */
    function get size () :int;

    /** @return a Vector containing all the Pages in the Tome. */
    function getAllPages (out :Vector.<Page> = null) :Vector.<Page>;

    /** @return the Page with the given name, or null if no such page is in the Tome */
    function getPage (name :String) :*;

    /** @return the Page with the given name. Throws an error if there is no such page. */
    function requirePage (name :String) :*;
}
}
