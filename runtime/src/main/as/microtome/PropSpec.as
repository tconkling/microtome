//
// microtome

package microtome {

import flash.utils.Dictionary;

public class PropSpec
{
    public var name :String;
    public var annotations :Dictionary;
    public var valueType :TypeInfo;

    public function PropSpec (name :String, annotations :Dictionary, valueClasses :Array) {
        this.name = name;
        this.annotations = annotations;
        this.valueType = (valueClasses != null ? TypeInfo.fromClasses(valueClasses) : null);
    }
}
}
