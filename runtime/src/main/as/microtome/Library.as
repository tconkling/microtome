//
// microtome

package microtome {

import flash.utils.Dictionary;

import microtome.core.Defs;
import microtome.core.LibraryItem;
import microtome.core.MicrotomeItem;
import microtome.error.MicrotomeError;
import microtome.error.RequirePageError;
import microtome.util.ClassUtil;

public final class Library
    implements MicrotomeItem
{
    public final function get library () :Library {
        return this;
    }

    public final function get parent () :MicrotomeItem {
        return null;
    }

    public final function get name () :String {
        return null;
    }

    public function getItem (name :String) :* {
        return _items[name];
    }

    public function hasItem (name :String) :Boolean {
        return (name in _items);
    }

    public function removeAllItems () :void {
        for each (var item :LibraryItem in _items) {
            if (item is Page) {
                Page(item)._parent = null;
            } else if (item is MutableTome) {
                MutableTome(item)._parent = null;
            } else {
                throw new MicrotomeError("Unrecognized LibraryItem", "item", item);
            }
        }
        _items = new Dictionary();
    }

    public function pageWithQualifiedName (qualifiedName :String) :Page {
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

        return (item as Page);
    }

    public function requirePageWithQualifiedName (qualifiedName :String, pageClass :Class) :Page {
        var page :Page = pageWithQualifiedName(qualifiedName);
        if (page == null) {
            throw new RequirePageError("No such page", "name", qualifiedName);
        } else if (!(page is pageClass)) {
            throw new RequirePageError("Wrong page type", "name", qualifiedName,
                "expectedType", ClassUtil.getClassName(pageClass),
                "actualType", ClassUtil.getClassName(page));
        }
        return page;
    }

    internal var _items :Dictionary = new Dictionary();
}
}
