//
// microtome

package microtome.prop {

import microtome.MutablePage;
import microtome.core.DataReader;
import microtome.core.Defs;
import microtome.core.TypeInfo;

public final class BoolProp extends PrimitiveProp
{
    public function BoolProp (page :MutablePage, spec :PropSpec) {
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
        return reader.requireBool(this.name);
    }

    override protected function get defaultValue () :* {
        return boolAnnotation(Defs.DEFAULT_ANNOTATION, false);
    }

    protected var _value :Boolean;

    protected static const VALUE_TYPE :TypeInfo = new TypeInfo(Boolean, null);
}
}
