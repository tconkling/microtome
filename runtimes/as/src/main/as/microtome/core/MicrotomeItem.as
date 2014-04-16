//
// microtome

package microtome.core {

import microtome.Library;

/** The common interface for Tomes and the Library itself */
public interface MicrotomeItem {
    function get name () :String;
    function get library () :Library;
    function get parent () :MicrotomeItem;
    function get children () :Array; // Array<Tome>

    /** @return true if the Tome has a child Tome with the given name */
    function hasChild (name :String) :Boolean;

    /** @return the child Tome with the given name, or null if no such child is in the Tome */
    function getChild (name :String) :*;

    /** @return the child Tome with the given name, or null if no such child is in the Tome */
    function requireChild (name :String) :*;
}
}
