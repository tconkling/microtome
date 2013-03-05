//
// microtome

package microtome {

import microtome.core.Defs;
import microtome.core.LibraryItem;
import microtome.core.TypeInfo;
import microtome.prop.ObjectProp;
import microtome.prop.Prop;
import microtome.util.ClassUtil;
import microtome.util.Util;

public class Page
    implements LibraryItem
{
    public final function get name () :String {
        return _name;
    }

    /** The page's fully qualified name, used during PageRef resolution */
    public final function get fullyQualifiedName () :String {
        var out :String = _name;
        var curItem :LibraryItem = _parent;
        while (curItem != null) {
            out = curItem.name + Defs.NAME_SEPARATOR + out;
            curItem = curItem.parent;
        }
        return out;
    }

    public final function get parent () :LibraryItem {
        return _parent;
    }

    public final function get typeInfo () :TypeInfo {
        return new TypeInfo(ClassUtil.getClass(this), null);
    }

    public final function childNamed (name :String) :* {
        var prop :Prop = Util.getProp(this, name);
        return (prop != null && prop is ObjectProp ? ObjectProp(prop).value : null);
    }

    public function get props () :Vector.<Prop> {
        return EMPTY_VEC;
    }

    public function toString () :String {
        return ClassUtil.tinyClassName(this) + ":'" + _name + "'";
    }

    internal var _name :String;
    internal var _parent :LibraryItem;

    protected static const EMPTY_VEC :Vector.<Prop> = new Vector.<Prop>(0, true);
}
}
