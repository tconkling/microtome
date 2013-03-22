//
// microtome

package microtome.marshaller {

import microtome.core.DataReader;
import microtome.core.MicrotomeMgr;
import microtome.core.TypeInfo;
import microtome.core.WritableObject;

public interface ObjectMarshaller extends DataMarshaller
{
    function get valueClass () :Class;
    function get handlesSubclasses () :Boolean;

    /** reads an object using a data reader */
    function readObject (mgr :MicrotomeMgr, reader :DataReader, type :TypeInfo) :*;

    /** writes an object */
    function writeObject (mgr :MicrotomeMgr, writer :WritableObject, obj :*, type :TypeInfo) :void;

    /** resolves PageRefs contained within an object */
    function resolveRefs (mgr :MicrotomeMgr, obj :*, type :TypeInfo) :void;
}
}
