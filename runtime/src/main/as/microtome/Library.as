//
// microtome

package microtome {

import flash.utils.Dictionary;

import microtome.core.Defs;
import microtome.core.LibraryItem;
import microtome.core.LibraryItemImpl;
import microtome.core.MicrotomeItem;
import microtome.core.microtome_internal;
import microtome.error.MicrotomeError;
import microtome.error.RequirePageError;
import microtome.util.ClassUtil;

public final class Library
    implements MicrotomeItem
{
    public function get library () :Library {
        return this;
    }

    public function get parent () :MicrotomeItem {
        return null;
    }

    public function get name () :String {
        return null;
    }

    public function getItem (name :String) :* {
        return _items[name];
    }

    public function hasItem (name :String) :Boolean {
        return (name in _items);
    }

    public function addItem (item :LibraryItem) :void {
        if (hasItem(item.name)) {
            throw new MicrotomeError("An item with that name already exists", "name", name);
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

    public function pageWithQualifiedName (qualifiedName :String, pageClass :Class = null) :MutablePage {
        // A page's qualifiedName is a series of page and tome names, separated by dots
        // E.g. level1.baddies.big_boss

        var item :LibraryItem = null;
        for each (var name :String in qualifiedName.split(Defs.NAME_SEPARATOR)) {
            var child :* = (item != null ? item.childNamed(name) : _items[name]);
            if (!(child is LibraryItem)) {
                return null;
            }
            item = LibraryItem(child);
        }

        if (pageClass != null && !(item is pageClass)) {
            throw new MicrotomeError("Wrong page type", "name", qualifiedName,
                "expectedType", ClassUtil.getClassName(pageClass),
                "actualType", ClassUtil.getClassName(item));
        }

        return (item as MutablePage);
    }

    public function requirePageWithQualifiedName (qualifiedName :String, pageClass :Class) :MutablePage {
        var page :MutablePage = pageWithQualifiedName(qualifiedName, pageClass);
        if (page == null) {
            throw new RequirePageError("No such page", "name", qualifiedName);
        }
        return page;
    }

    protected function setItemParent (item :LibraryItem, library :Library) :void {
        LibraryItemImpl(item).microtome_internal::setParent(library);
    }

    internal var _items :Dictionary = new Dictionary();
}
}
