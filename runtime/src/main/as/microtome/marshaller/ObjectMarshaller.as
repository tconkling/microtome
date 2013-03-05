//
// microtome

package microtome.marshaller {

import microtome.LibraryLoader;
import microtome.core.DataElement;
import microtome.core.LibraryItem;
import microtome.core.TypeInfo;
import microtome.prop.ObjectProp;

public interface ObjectMarshaller
{
    function get valueClass () :Class;
    function get handlesSubclasses () :Boolean;

    /** loads an object from a data element */
    function loadObject (parent :LibraryItem, data :DataElement, type :TypeInfo, loader :LibraryLoader) :*;

    /** resolves PageRefs contained within an object */
    function resolveRefs (obj :*, type :TypeInfo, loader :LibraryLoader) :void;

    /**
     * Validates an object's value.
     * @throw a ValidationException on failure.
     */
    function validatePropValue (prop :ObjectProp) :void;
}
}
