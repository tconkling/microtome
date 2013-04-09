//
// microtome

package microtome.core {

import microtome.Library;
import microtome.error.MicrotomeError;

public class LibraryItemBase
    implements MicrotomeItem
{
    public function LibraryItemBase (name :String) {
        _name = name;
    }

    /** The item's fully qualified name, used during PageRef resolution */
    public final function get qualifiedName () :String {
        if (this.library == null) {
            throw new MicrotomeError("item must be in a library to have a fullyQualifiedName",
                "item", this);
        }

        var out :String = _name;
        var curItem :MicrotomeItem = _parent;
        while (curItem != null && curItem.library != curItem) {
            out = curItem.name + Defs.NAME_SEPARATOR + out;
            curItem = curItem.parent;
        }
        return out;
    }

    public final function get name () :String {
        return _name;
    }

    public final function get parent () :MicrotomeItem {
        return _parent;
    }

    public final function get library () :Library {
        return (_parent != null ? _parent.library : null);
    }

    public function get typeInfo () :TypeInfo {
        throw new Error("abstract");
    }

    public function get children () :Array {
        throw new Error("abstract");
    }

    public function childNamed (name :String) :* {
        throw new Error("abstract");
    }

    microtome_internal final function setParent (parent :MicrotomeItem) :void {
        _parent = parent;
    }

    protected var _parent :MicrotomeItem;
    protected var _name :String;
}
}

