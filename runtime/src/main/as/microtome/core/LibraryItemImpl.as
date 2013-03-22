//
// microtome

package microtome.core {

import microtome.Library;

public class LibraryItemImpl
    implements MicrotomeItem
{
    public function LibraryItemImpl (name :String) {
        _name = name;
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

