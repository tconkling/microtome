//
// microtome

package microtome.prop {

import microtome.MutablePage;
import microtome.core.LibraryItemBase;
import microtome.core.microtome_internal;

public final class ObjectProp extends Prop
{
    public function ObjectProp (page :MutablePage, spec :PropSpec) {
        super(page, spec);
    }

    override public function get value () :* {
        return _value;
    }

    override public function set value (val :*) :void {
        if (_value == val) {
            return;
        }

        if (_value is LibraryItemBase) {
            LibraryItemBase(_value).microtome_internal::setParent(null);
        }
        _value = val;
        if (_value is LibraryItemBase) {
            LibraryItemBase(_value).microtome_internal::setParent(_page);
        }
    }

    protected var _value :Object;
}
}
