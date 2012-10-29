//
// microtome

package microtome {

import flash.utils.Dictionary;

internal class PropSpec
{
    public var name :String;
    public var annotations :Dictionary;
    public var valueType :ValueType;

    public function PropSpec (name :String, annotations :Dictionary, valueClasses :Vector.<Class>) {
        this.name = name;
        this.annotations = annotations;
        this.valueType = ValueType.fromClasses(valueClasses);
    }
}
}
