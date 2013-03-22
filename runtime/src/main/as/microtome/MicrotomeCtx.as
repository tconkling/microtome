//
// microtome

package microtome {

import microtome.core.DataElement;
import microtome.core.DataWriter;
import microtome.core.LibraryItem;
import microtome.marshaller.ObjectMarshaller;
import microtome.marshaller.PrimitiveMarshaller;

public interface MicrotomeCtx
{
    function registerPageClasses (classes :Vector.<Class>) :void;

    function registerObjectMarshaller (marshaller :ObjectMarshaller) :void;
    function registerPrimitiveMarshaller (marshaller :PrimitiveMarshaller) :void;

    function load (library :Library, data :Vector.<DataElement>) :void;
    function save (item :LibraryItem, writer :DataWriter) :DataElement;
    function clone (item :LibraryItem) :*;
}
}
