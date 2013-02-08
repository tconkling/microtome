//
// microtome

package microtome.core {

import microtome.Page;

public class PageRef
{
    public function PageRef (pageClass :Class, pageName :String) {
        _pageClass = pageClass;
        _pageName = pageName;
    }

    public function get pageClass () :Class {
        return _pageClass;
    }

    public function get pageName () :String {
        return _pageName;
    }

    public function get page () :* {
        return _page;
    }

    public function set page (page :Page) :void {
        _page = page;
    }

    protected var _pageClass :Class;
    protected var _pageName :String;
    protected var _page :Page;
}
}
