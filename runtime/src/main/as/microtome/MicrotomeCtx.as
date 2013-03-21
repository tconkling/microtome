//
// microtome

package microtome {

import microtome.core.DataElement;
import microtome.marshaller.ObjectMarshaller;
import microtome.marshaller.PrimitiveMarshaller;

public interface MicrotomeCtx
{
    function set primitiveMarshaller (val :PrimitiveMarshaller) :void;

    function registerPageClasses (classes :Vector.<Class>) :void;
    function registerObjectMarshaller (marshaller :ObjectMarshaller) :void;

    function loadData (dataElements :Vector.<DataElement>) :void;
}
}
