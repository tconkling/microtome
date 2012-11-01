//
// microtome

package microtome {

public interface ObjectMarshaller
{
    function get valueClass () :Class;
    function get handlesSubclasses () :Boolean;

    /** loads an object from a data element */
    function loadObject (data :DataElement, type :TypeInfo, library :Library) :*;

    /** resolves PageRefs contained within an object */
    function resolveRefs (obj :*, type :TypeInfo, library :Library) :void;

    /**
     * Validates an object's value.
     * @throw a ValidationException on failure.
     */
    function validatePropValue (prop :ObjectProp) :void;
}
}
