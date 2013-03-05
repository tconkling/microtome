//
// microtome

package microtome {

import flash.utils.Dictionary;
import flash.utils.Proxy;
import flash.utils.flash_proxy;

import microtome.core.LibraryItem;
import microtome.core.TypeInfo;
import microtome.util.ClassUtil;

public final class MutableTome extends Proxy
    implements Tome
{
    public function MutableTome (parent :LibraryItem, name :String, pageClass :Class) {
        _name = name;
        _parent = parent;
        _type = TypeInfo.fromClasses([ MutableTome, pageClass ]);
    }

    public final function get name () :String {
        return _name;
    }

    public final function get parent () :LibraryItem {
        return _parent;
    }

    public final function get typeInfo () :TypeInfo {
        return _type;
    }

    public final function get pageClass () :Class {
        return _type.subtype.clazz;
    }

    public final function get size () :int {
        return _size;
    }

    public final function childNamed (name :String) :* {
        return this.pageNamed(name);
    }

    public final function pageNamed (name :String) :* {
        return _pages[name];
    }

    public function requirePageNamed (name :String) :* {
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

    public function addPage (page :Page) :void {
        if (page == null) {
            throw new Error("Can't add null page");
        } else if (!(page is this.pageClass)) {
            throw new Error("Incorrect page type [required='" +
                ClassUtil.getClassName(this.pageClass) + "', got='" +
                ClassUtil.getClassName(page) + "']");
        } else if (page.name == null) {
            throw new Error("Page is missing name [type='" + ClassUtil.getClassName(page) + "']");
        } else if (_pages[page.name] != null) {
            throw new Error("Duplicate page name '" + page.name + "'");
        }
        _pages[page.name] = page;
        _pageList = null;
        _size++;
    }

    override flash_proxy function getProperty (name :*) :* {
        return _pages[name];
    }

    override flash_proxy function hasProperty (name :*) :Boolean {
        return name in _pages;
    }

    override flash_proxy function nextNameIndex (index :int) :int {
        // iteration stops when nextNameIndex returns 0, so we return
        // index + 1 here, and use index - 1 in nextName/nextValue
        return (index < _size ? index + 1 : 0);
    }

    override flash_proxy function nextName (index :int) :String {
        return getPageList()[index - 1].name;
    }

    override flash_proxy function nextValue (index :int) :* {
        return getPageList()[index - 1];
    }

    override flash_proxy function setProperty (name :*, value :*) :void {
        throw new Error("unsupported");
    }

    override flash_proxy function deleteProperty (name :*) :Boolean {
        throw new Error("unsupported");
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

    protected var _name :String;
    protected var _parent :LibraryItem;
    protected var _type :TypeInfo;
    protected var _pages :Dictionary = new Dictionary();
    protected var _size :int;

    protected var _pageList :Vector.<Page>; // lazily instantiated
}
}
