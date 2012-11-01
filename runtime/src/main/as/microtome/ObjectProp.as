//
// microtome

package microtome {

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
        return boolAnnotation(Defs.NULLABLE, false);
    }
}
}
