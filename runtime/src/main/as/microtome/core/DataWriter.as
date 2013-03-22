//
// microtome

package microtome.core {

public interface DataWriter
{
    function writeBool (name :String, val :Boolean) :void;
    function writeInt (name :String, val :int) :void;
    function writeNumber (name :String, val :Number) :void;
    function writeString (name :String, val :String) :void;

    function createChild (name :String) :DataWriter;
}

}
