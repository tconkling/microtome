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

    public function get typeInfo () :TypeInfo {
        return new TypeInfo(ClassUtil.getClass(this), null);
    }

    public function get props () :Vector.<Prop> {
        return EMPTY_VEC;
    }

    public function childNamed (name :String) :* {
        var prop :Prop = Util.getProp(this, name);
        return (prop != null && prop is ObjectProp ? ObjectProp(prop).value : null);
    }

    public function toString () :String {
        return ClassUtil.tinyClassName(this) + ":'" + _name + "'";
    }

    internal function setName (name :String) :void {
        _name = name;
    }

    protected var _name :String;

    protected static const EMPTY_VEC :Vector.<Prop> = new Vector.<Prop>(0, true);
}
}
