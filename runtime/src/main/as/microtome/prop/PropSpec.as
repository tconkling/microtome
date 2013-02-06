//
// microtome

package microtome.prop {

import flash.utils.Dictionary;
import microtome.core.TypeInfo;

public class PropSpec
{
    public var name :String;
    public var annotations :Dictionary;
    public var valueType :TypeInfo;

    public function PropSpec (name :String, annos :Object, valueClasses :Array) {
        this.name = name;
        this.annotations = (annos != null ? new Dictionary() : EMPTY_DICT);
        if (annos != null) {
            for (var key :String in annos) {
                this.annotations[key] = annos[key];
            }
        }
        this.valueType = (valueClasses != null ? TypeInfo.fromClasses(valueClasses) : null);
    }

    protected static const EMPTY_DICT :Dictionary = new Dictionary();
}
}
