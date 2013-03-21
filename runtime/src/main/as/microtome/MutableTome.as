//
// microtome

package microtome {

import flash.utils.Dictionary;

import microtome.core.LibraryItemImpl;
import microtome.core.TypeInfo;
import microtome.core.microtome_internal;
import microtome.error.MicrotomeError;
import microtome.util.ClassUtil;

public final class MutableTome extends LibraryItemImpl
    implements Tome
{
    public function MutableTome (name :String, pageClass :Class) {
        _name = name;
        _type = TypeInfo.fromClasses([ MutableTome, pageClass ]);
    }

    override public function get typeInfo () :TypeInfo {
        return _type;
    }

    public function get pageClass () :Class {
        return _type.subtype.clazz;
    }

    public function get size () :int {
        return _size;
    }

    public function getAllPages (out :Array = null) :Array {
        const pages :Vector.<Page> = getPageList();
        out = (out || []);
        out.length = 0;
        for (var ii :int = 0; ii < _size; ++ii) {
            out.push(pages[ii]);
        }
        return out;
    }

    override public function childNamed (name :String) :* {
        return this.getPage(name);
    }

    public function getPage (name :String) :* {
        return _pages[name];
    }

    public function requirePage (name :String) :* {
        var page :Page = _pages[name];
        if (page == null) {
            throw new Error("Missing required page [name='" + name + "']");
        }
        return page;
    }

    /**
     * Iterates over the pages in the Tome.
     * fn should take a single MutablePage argument. It can optionally return a Boolean specifying
     * whether to stop the iteration.
     */
    public function forEach (fn :Function) :void {
        for each (var page :Page in _pages) {
            if (fn(page)) {
                return;
            }
        }
    }

    public function addPage (page :MutablePage) :void {
        if (!(page is this.pageClass)) {
            throw new MicrotomeError("Incorrect page type",
                "required", ClassUtil.getClassName(this.pageClass),
                "got", ClassUtil.getClassName(page));
        } else if (page.name == null) {
            throw new MicrotomeError("Page is missing name", "type", ClassUtil.getClassName(page));
        } else if (_pages[page.name] != null) {
            throw new MicrotomeError("Duplicate page name '" + page.name + "'");
        } else if (page.parent != null) {
            throw new MicrotomeError("Page is already parented", "parent", page.parent);
        }

        page.microtome_internal::setParent(this);
        _pages[page.name] = page;
        _pageList = null;
        _size++;
    }

    public function removePage (page :MutablePage) :void {
        if (page.parent != this) {
            throw new MicrotomeError("Page is not in this tome", "page", page);
        }
        page.microtome_internal::setParent(null);
        delete _pages[page.name];
        _pageList = null;
        _size--;
    }

    protected function getPageList () :Vector.<Page> {
        if (_pageList == null) {
            _pageList = new Vector.<Page>(_size, true);
            var ii :int = 0;
            for each (var page :Page in _pages) {
                _pageList[ii++] = page;
            }
        }
        return _pageList;
    }

    protected var _type :TypeInfo;
    protected var _pages :Dictionary = new Dictionary();
    protected var _size :int;

    protected var _pageList :Vector.<Page>; // lazily instantiated
}
}
