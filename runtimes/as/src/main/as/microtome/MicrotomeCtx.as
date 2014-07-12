//
// microtome

package microtome {

import microtome.core.ReadableObject;
import microtome.core.WritableObject;
import microtome.marshaller.DataMarshaller;

public interface MicrotomeCtx
{
    function registerTomeClasses (classes :Vector.<Class>) :void;

    function registerDataMarshaller (marshaller :DataMarshaller) :void;

    /** Loads data into a library, and returns the newly-loaded top-level tomes */
    function load (library :Library, data :Vector.<ReadableObject>) :Vector.<Tome>;

    /** Writes the given tome to a WritableObject */
    function write (item :Tome, writer :WritableObject) :void;

    /** Returns a clone of the given Tome */
    function clone (item :Tome) :*;
}
}
