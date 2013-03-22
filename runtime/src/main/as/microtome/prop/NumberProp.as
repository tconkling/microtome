//
// microtome

package microtome.prop {

import microtome.MutablePage;
import microtome.core.DataReader;
import microtome.core.Defs;
import microtome.core.TypeInfo;
import microtome.core.WritableObject;

public final class NumberProp extends PrimitiveProp
{
    public function NumberProp (page :MutablePage, spec :PropSpec) {
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

    override public function writeValue (writer :WritableObject) :void {
        writer.writeNumber(this.name, _value);
    }

    override protected function readValue (reader :DataReader) :* {
        return reader.requireNumber(this.name);
    }

    override protected function get defaultValue () :* {
        return numberAnnotation(Defs.DEFAULT_ANNOTATION, 0);
    }

    protected var _value :Number;

    protected static const VALUE_TYPE :TypeInfo = new TypeInfo(Number, null);
}
}
