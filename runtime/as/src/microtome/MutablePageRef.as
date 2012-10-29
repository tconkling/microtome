//
// microtome

package microtome {

public class MutablePageRef
    implements PageRef
{
    public function MutablePageRef (pageType :Class, pageName :String) {
        _pageType = pageType;
        _pageName = pageName;
    }

    public function get pageType () :Class {
        return _pageType;
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

    protected var _pageType :Class;
    protected var _pageName :String;
    protected var _page :Page;
}
}
