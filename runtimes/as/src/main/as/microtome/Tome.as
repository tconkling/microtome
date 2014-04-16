//
// microtome

package microtome {

import microtome.core.MicrotomeItem;
import microtome.core.TypeInfo;

public interface Tome extends MicrotomeItem {
    /** The Tome's ID. Guaranteed to be unique across a Library. */
    function get id () :String;
    function get typeInfo () :TypeInfo;
}
}
