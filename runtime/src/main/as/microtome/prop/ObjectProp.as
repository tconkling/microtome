//
// microtome

package microtome.prop {

import microtome.core.Defs;
import microtome.core.LibraryItemImpl;
import microtome.MutablePage;
import microtome.core.TypeInfo;
import microtome.core.microtome_internal;

public final class ObjectProp extends Prop
{
    public function ObjectProp (page :MutablePage, spec :PropSpec) {
        super(page, spec);
    }

    public function get nullable () :Boolean {
        return boolAnnotation(Defs.NULLABLE_ANNOTATION, false);
    }

    override public function set value (val :*) :void {
        if (_value == val) {
            return;
        }

        if (_value is LibraryItemImpl) {
            LibraryItemImpl(_value).microtome_internal::setParent(null);
        }
        _value = val;
        if (_value is LibraryItemImpl) {
            LibraryItemImpl(_value).microtome_internal::setParent(_page);
        }
    }

    override public function get valueType () :TypeInfo {
        return _spec.valueType;
    }
}
}
