//
// microtome

package microtome.prop {

import microtome.core.Defs;
import microtome.core.TypeInfo;

public class ObjectProp extends Prop
{
    public var value :*;

    public function ObjectProp (spec :PropSpec) {
        super(spec);
    }

    public function get valueType () :TypeInfo {
        return _spec.valueType;
    }

    public function get nullable () :Boolean {
        return boolAnnotation(Defs.NULLABLE_ATTR, false);
    }
}
}
