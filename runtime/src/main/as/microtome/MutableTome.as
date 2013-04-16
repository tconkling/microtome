//
// microtome

package microtome {

import flash.utils.Dictionary;

import microtome.core.LibraryItemBase;
import microtome.core.TypeInfo;
import microtome.core.microtome_internal;
import microtome.error.MicrotomeError;
import microtome.util.ClassUtil;
import microtome.util.Util;

public final class MutableTome extends LibraryItemBase
    implements Tome
{
    public function MutableTome (name :String, pageClass :Class) {
        super(name);
        _type = TypeInfo.fromClasses([ MutableTome, pageClass ]);
    }

    override public function get typeInfo () :TypeInfo {
        return _type;
    }

    public function get pageClass () :Class {
        return _type.subtype.clazz;
    }

    public function get length () :uint {
        return _length;
    }

    override public function get children () :Array {
        return Util.dictToArray(_pages);
    }

    override public function childNamed (name :String) :* {
        return this.getPage(name);
    }

    public function getPage (name :String) :* {
        return _pages[name];
    }

    public function requirePage (name :String) :* {
        const page :Page = _pages[name];
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
        _length++;
    }

    public function removePage (page :MutablePage) :void {
        if (page.parent != this) {
            throw new MicrotomeError("Page is not in this tome", "page", page);
        }
        page.microtome_internal::setParent(null);
        delete _pages[page.name];
        _length--;
    }

    protected var _type :TypeInfo;
    protected var _pages :Dictionary = new Dictionary();
    protected var _length :uint;
}
}
