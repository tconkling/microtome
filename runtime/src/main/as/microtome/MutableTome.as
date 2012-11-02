//
// microtome

package microtome {

import flash.utils.Dictionary;

public class MutableTome
    implements Tome
{
    public function MutableTome (name :String, pageClass :Class) {
        _name = name;
        _type = TypeInfo.fromClasses([ ClassUtil.getClass(this), pageClass ]);
    }

    public function get name () :String {
        return _name;
    }

    public function get type () :TypeInfo {
        return _type;
    }

    public function get pageClass () :Class {
        return _type.subtype.clazz;
    }

    public function get size () :int {
        return _size;
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

    public function pageNamed (name :String) :Page {
        return _pages[name];
    }

    public function childNamed (name :String) :* {
        return _pages[name];
    }

    public function requirePageNamed (name :String) :Page {
        var page :Page = _pages[name];
        if (page == null) {
            throw new Error("Missing required page [name='" + name + "']");
        }
        return page;
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
        _size++;
    }

    protected var _name :String;
    protected var _type :TypeInfo;
    protected var _pages :Dictionary = new Dictionary();
    protected var _size :int;
}
}
