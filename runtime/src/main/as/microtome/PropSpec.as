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
        this.annotations = (annotations != null ? annotations : EMPTY_DICT);
        this.valueType = (valueClasses != null ? TypeInfo.fromClasses(valueClasses) : null);
    }

    protected static const EMPTY_DICT :Dictionary = new Dictionary();
}
}
