//
// microtome

package microtome.core {

import microtome.Library;
import microtome.Page;

public final class PageRef
{
    public static function fromPage (page :Page) :PageRef {
        const ref :PageRef = new PageRef(page.fullyQualifiedName);
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
        _page = lib.requirePageWithQualifiedName(_pageName, pageClass);
    }

    public function clone () :PageRef {
        return new PageRef(_pageName);
    }

    protected var _pageName :String;
    protected var _page :Page;
}
}
