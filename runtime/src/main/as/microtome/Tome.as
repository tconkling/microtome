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
    function get pageClass () :Class;
    function get size () :int;

    function pageNamed (name :String) :*;
    function requirePageNamed (name :String) :*;
}
}
