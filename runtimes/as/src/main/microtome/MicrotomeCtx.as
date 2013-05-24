//
// microtome

package microtome {

import microtome.core.LibraryItem;
import microtome.core.ReadableObject;
import microtome.core.WritableObject;
import microtome.marshaller.DataMarshaller;

public interface MicrotomeCtx
{
    function registerPageClasses (classes :Vector.<Class>) :void;

    function registerDataMarshaller (marshaller :DataMarshaller) :void;

    function load (library :Library, data :Vector.<ReadableObject>) :void;
    function write (item :LibraryItem, writer :WritableObject) :void;
    function clone (item :LibraryItem) :*;
}
}
