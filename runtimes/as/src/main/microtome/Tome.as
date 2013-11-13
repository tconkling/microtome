//
// microtome

package microtome {

import microtome.core.MicrotomeItem;
import microtome.core.TypeInfo;

public interface Tome extends MicrotomeItem
{
    function get qualifiedName () :String;

    function get typeInfo () :TypeInfo;

    /** @return true if the Tome has a child Tome with the given name */
    function hasTome (name :String) :Boolean;

    /** @return the child Tome with the given name, or null if no such child is in the Tome */
    function getTome (name :String) :*;

    /** @return the child Tome with the given name, or null if no such child is in the Tome */
    function requireTome (name :String) :*;
}
}
