//
// microtome

package microtome {
import flash.utils.Dictionary;

public class MutableTome
    implements Tome
{
    public function MutableTome (name :String, pageClass :Class) {
        _name = name;
        _type = TypeInfo.fromClasses(Util.getClass(this), pageClass);
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

    public function get pages () :Vector.<Page> {
        var pages :Vector.<Page> = new Vector.<Page>(_size);
        for each (var page :Page in _pages) {
            pages.push(page);
        }
        return pages;
    }

    public function childNamed (name :String) :* {
        return pageNamed(name);
    }

    public function pageNamed (name :String) :Page {
        return _pages.get(name);
    }

    public function requirePageNamed (name :String) :Page {
        var page :Page = _pages.get(name);
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
                Util.getClassName(this.pageClass) + "', got='" +
                Util.getClassName(page) + "']");
        } else if (page.name == null) {
            throw new Error("Page is missing name [type='" + Util.getClassName(page) + "']");
        } else if (pageNamed(page.name) != null) {
            throw new Error("Duplicate page name '" + page.name + "'");
        }
        _pages.put(page.name, page);
    }

    protected var _name :String;
    protected var _type :TypeInfo;
    protected var _pages :Dictionary = new Dictionary();
    protected var _size :int;
}
}
