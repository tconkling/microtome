//
// microtome

package microtome.marshaller {

import microtome.core.DataElement;
import microtome.core.LibraryManager;
import microtome.core.TypeInfo;

public interface ObjectMarshaller extends DataMarshaller
{
    function get valueClass () :Class;
    function get handlesSubclasses () :Boolean;

    /** loads an object from a data element */
    function loadObject (data :DataElement, type :TypeInfo, mgr :LibraryManager) :*;

    /** resolves PageRefs contained within an object */
    function resolveRefs (obj :*, type :TypeInfo, mgr :LibraryManager) :void;
}
}
