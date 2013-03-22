//
// microtome

package microtome.marshaller {

import microtome.core.DataReader;
import microtome.core.MicrotomeMgr;
import microtome.core.TypeInfo;

public interface ObjectMarshaller extends DataMarshaller
{
    function get valueClass () :Class;
    function get handlesSubclasses () :Boolean;

    /** loads an object from a data element */
    function readObject (mgr :MicrotomeMgr, reader :DataReader, type :TypeInfo) :*;

    /** resolves PageRefs contained within an object */
    function resolveRefs (mgr :MicrotomeMgr, obj :*, type :TypeInfo) :void;
}
}
