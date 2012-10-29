//
// microtome

package microtome {

public interface ObjectMarshaller
{
    function get valueType () :Class;
    function get handlesSubclasses () :Boolean;

    /** loads an object from a data element */
    function loadObject (data :DataElement, type :ValueType, library :Library) :*;

    /** resolves PageRefs contained within an object */
    function resolveRefs (obj :*, type :ValueType, library :Library) :void;

    /**
     * Validates an object's value.
     * @throw a ValidationException on failure.
     */
    function validatePropValue (prop :ObjectProp) :void;
}
}
