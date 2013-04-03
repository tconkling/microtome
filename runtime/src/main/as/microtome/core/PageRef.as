//
// microtome

package microtome.core {

import microtome.Library;
import microtome.Page;
import microtome.error.ResolveRefError;
import microtome.util.ClassUtil;

public final class PageRef
{
    public static function fromPage (page :Page) :PageRef {
        const ref :PageRef = new PageRef(page.qualifiedName);
        ref._page = page;
        return ref;
    }

    public function PageRef (pageName :String) {
        _pageName = pageName;
    }

    public function get pageName () :String {
        return _pageName;
    }

    public function get page () :* {
        return (_page != null && _page.library != null ? _page : null);
    }

    public function resolve (lib :Library, pageClass :Class) :void {
        const item :* = lib.getItemWithQualifiedName(_pageName);
        if (item == null) {
            throw new ResolveRefError("No such item", "name", _pageName);
        } else if (!(item is pageClass)) {
            throw new ResolveRefError("Wrong page type", "name", _pageName,
                "expectedType", ClassUtil.getClassName(pageClass),
                "actualType", ClassUtil.getClassName(item));
        }
        _page = item;
    }

    public function clone () :PageRef {
        return new PageRef(_pageName);
    }

    protected var _pageName :String;
    protected var _page :Page;
}
}
