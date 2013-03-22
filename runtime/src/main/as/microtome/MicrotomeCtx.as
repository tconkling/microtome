//
// microtome

package microtome {

import microtome.core.ReadableObject;
import microtome.core.WritableObject;
import microtome.core.LibraryItem;
import microtome.marshaller.ObjectMarshaller;
import microtome.marshaller.PrimitiveMarshaller;

public interface MicrotomeCtx
{
    function registerPageClasses (classes :Vector.<Class>) :void;

    function registerObjectMarshaller (marshaller :ObjectMarshaller) :void;
    function registerPrimitiveMarshaller (marshaller :PrimitiveMarshaller) :void;

    function load (library :Library, data :Vector.<ReadableObject>) :void;
    function save (item :LibraryItem, writer :WritableObject) :void;
    function clone (item :LibraryItem) :*;
}
}
