//
// microtome

package microtome {

import microtome.core.LibraryItem;
import microtome.core.TypeInfo;
import microtome.prop.ObjectProp;
import microtome.prop.Prop;
import microtome.util.ClassUtil;
import microtome.util.Util;

public class Page
    implements LibraryItem
{
    public function get name () :String {
        return _name;
    }

    public function get type () :TypeInfo {
        return new TypeInfo(ClassUtil.getClass(this), null);
    }

    public function get props () :Array {
        return EMPTY_ARRAY;
    }

    public function childNamed (name :String) :* {
        var prop :Prop = Util.getProp(this, name);
        return (prop != null && prop is ObjectProp ? ObjectProp(prop).value : null);
    }

    internal function setName (name :String) :void {
        _name = name;
    }

    protected var _name :String;

    protected static var EMPTY_ARRAY :Array = [];
}
}
