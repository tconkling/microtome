//
// microtome

package microtome.prop {

import microtome.MutablePage;
import microtome.core.DataReader;
import microtome.core.Defs;
import microtome.core.TypeInfo;

public final class IntProp extends PrimitiveProp
{
    public function IntProp (page :MutablePage, spec :PropSpec) {
        super(page, spec);
    }

    override public function get value () :* {
        return _value;
    }

    override public function set value (val :*) :void {
        _value = val;
    }

    override public function get valueType () :TypeInfo {
        return VALUE_TYPE;
    }

    override protected function readValue (reader :DataReader) :* {
        return reader.requireInt(this.name);
    }

    override protected function get defaultValue () :* {
        return intAnnotation(Defs.DEFAULT_ANNOTATION, 0);
    }

    protected var _value :int;

    protected static const VALUE_TYPE :TypeInfo = new TypeInfo(int, null);
}
}
