//
// microtome

package microtome {

import microtome.core.Defs;
import microtome.core.LibraryItemImpl;
import microtome.core.MicrotomeItem;
import microtome.core.TypeInfo;
import microtome.prop.ObjectProp;
import microtome.prop.Prop;
import microtome.util.ClassUtil;
import microtome.util.Util;

public class MutablePage extends LibraryItemImpl
    implements Page
{
    public function MutablePage (name :String) {
        super(name);
    }

    /** The page's fully qualified name, used during PageRef resolution */
    public final function get fullyQualifiedName () :String {
        var out :String = _name;
        var curItem :MicrotomeItem = _parent;
        while (curItem != null && curItem.library != curItem) {
            out = curItem.name + Defs.NAME_SEPARATOR + out;
            curItem = curItem.parent;
        }
        return out;
    }

    override public final function get typeInfo () :TypeInfo {
        if (_typeInfo == null) {
            _typeInfo = new TypeInfo(ClassUtil.getClass(this), null);
        }
        return _typeInfo;
    }

    override public final function childNamed (name :String) :* {
        var prop :Prop = Util.getProp(this, name);
        return (prop != null && prop is ObjectProp ? ObjectProp(prop).value : null);
    }

    public function get props () :Vector.<Prop> {
        return EMPTY_VEC;
    }

    public function toString () :String {
        return ClassUtil.tinyClassName(this) + ":'" + _name + "'";
    }

    private var _typeInfo :TypeInfo;

    protected static const EMPTY_VEC :Vector.<Prop> = new Vector.<Prop>(0, true);
}
}
