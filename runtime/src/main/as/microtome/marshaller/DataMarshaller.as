//
// microtome

package microtome.marshaller {

import microtome.core.LibraryManager;
import microtome.prop.Prop;

public interface DataMarshaller
{
    /**
     * Validates a prop's value.
     * @throw a ValidationException on failure.
     */
    function validateProp (prop :Prop) :void;

    /** @return a clone of the given data */
    function cloneData (data :Object, mgr :LibraryManager) :*;
}
}
