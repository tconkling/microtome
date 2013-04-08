//
// microtome

package microtome.marshaller {

import microtome.core.Annotatable;
import microtome.core.DataReader;
import microtome.core.MicrotomeMgr;
import microtome.core.TypeInfo;
import microtome.core.WritableObject;
import microtome.prop.Prop;

public interface DataMarshaller
{
    /** The class that this marshaller handles */
    function get valueClass () :Class;

    /** @true if the marshaller handles subclasses of its valueClass */
    function get handlesSubclasses () :Boolean;

    /**
     * @return true if this marshaller represents a "simple" data type.
     * A simple type is one that can be parsed from a single value. Generally, composite objects
     * are likely to be non-simple (though, for example, a Tuple object could be made simple if
     * you were to parse it from a comma-delimited string).
     */
    function get isSimple () :Boolean;

    /**
     * Reads data using a data reader.
     * @throw LoadError if the data cannot be loaded for any reason.
     */
    function readValue (mgr :MicrotomeMgr, reader :DataReader, name :String, type :TypeInfo) :*;

    /**
     * reads data from a prop's annotations
     * @throw LoadError if the default cannot used for any reason.
     */
    function readDefault (mgr :MicrotomeMgr, type :TypeInfo, anno :Annotatable) :*;

    /** writes an object's value */
    function writeValue (mgr :MicrotomeMgr, writer :WritableObject, val :*, name :String, type :TypeInfo) :void;

    /** resolves PageRefs contained within an object */
    function resolveRefs (mgr :MicrotomeMgr, val :*, type :TypeInfo) :void;

    /**
     * Validates a prop's value, possibly using the annotations on the prop.
     * @throw a ValidationException on failure.
     */
    function validateProp (prop :Prop) :void;

    /** @return a clone of the given data */
    function cloneData (mgr :MicrotomeMgr, data :Object, type :TypeInfo) :*;
}
}
