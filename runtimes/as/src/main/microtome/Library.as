//
// microtome

package microtome {

import flash.utils.Dictionary;

import microtome.core.Defs;
import microtome.core.LibraryItem;
import microtome.core.LibraryItemBase;
import microtome.core.MicrotomeItem;
import microtome.core.microtome_internal;
import microtome.error.MicrotomeError;
import microtome.util.Util;

public final class Library
    implements MicrotomeItem
{
    public function get name () :String {
        return null;
    }

    public function get library () :Library {
        return this;
    }

    public function get parent () :MicrotomeItem {
        return null;
    }

    public function get children () :Array {
        return Util.dictToArray(_items);
    }

    public function getItemWithQualifiedName (qualifiedName :String) :* {
        // A qualifiedName is a series of page and tome names, separated by dots
        // E.g. level1.baddies.big_boss

        var item :LibraryItem = null;
        for each (var name :String in qualifiedName.split(Defs.NAME_SEPARATOR)) {
            var child :* = (item != null ? item.childNamed(name) : _items[name]);
            if (!(child is LibraryItem)) {
                return null;
            }
            item = LibraryItem(child);
        }

        return item;
    }

    public function requireItemWithQualifiedName (qualifiedName :String) :* {
        var item :LibraryItem = getItemWithQualifiedName(qualifiedName);
        if (item == null) {
            throw new MicrotomeError("No such item", "qualifiedName", qualifiedName);
        }
        return item;
    }

    public function getItem (name :String) :* {
        return _items[name];
    }

    public function hasItem (name :String) :Boolean {
        return (name in _items);
    }

    public function addItem (item :LibraryItem) :void {
        if (hasItem(item.name)) {
            throw new MicrotomeError("An item with that name already exists", "name", item.name);
        } else if (item.parent != null) {
            throw new MicrotomeError("Item is already in a library", "item", item);
        }

        setItemParent(item, this);
        _items[item.name] = item;
    }

    public function removeItem (item :LibraryItem) :void {
        if (item.parent != this) {
            throw new MicrotomeError("Item is not in this library", "item", item);
        }
        setItemParent(item, null);
        delete _items[item.name];
    }

    public function removeAllItems () :void {
        for each (var item :LibraryItem in _items) {
            setItemParent(item, null);
        }
        _items = new Dictionary();
    }

    protected function setItemParent (item :LibraryItem, library :Library) :void {
        LibraryItemBase(item).microtome_internal::setParent(library);
    }

    internal var _items :Dictionary = new Dictionary();
}
}
