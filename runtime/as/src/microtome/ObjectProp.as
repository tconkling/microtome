//
// microtome

package microtome {

public class ObjectProp extends Prop
{
    public var value :*;

    public function ObjectProp (spec :PropSpec) {
        super(spec);
    }

    public function get valueType () :ValueType {
        return _spec.valueType;
    }

    public function get nullable () :Boolean {
        return boolAnnotation(Defs.NULLABLE, false);
    }
}
}
