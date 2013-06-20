//
// microtome

package microtome.marshaller {

import microtome.core.Annotation;
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

    /** @true if this marshaller can read the named value from the given reader. */
    function canReadValue (reader :DataReader, name :String) :Boolean;

    /** @return a DataReader for the given property on the given DataReader. */
    function getValueReader (parentReader :DataReader, name :String) :DataReader;

    /** @return a WritableObject for the given property on the given WritableObject. */
    function getValueWriter (parentWriter :WritableObject, name :String) :WritableObject;

    /**
     * Reads data using a data reader.
     * @throw LoadError if the data cannot be loaded for any reason.
     */
    function readValue (mgr :MicrotomeMgr, reader :DataReader, name :String, type :TypeInfo) :*;

    /**
     * reads data from a prop's annotations
     * @throw LoadError if the default cannot used for any reason.
     */
    function readDefault (mgr :MicrotomeMgr, type :TypeInfo, anno :Annotation) :*;

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
