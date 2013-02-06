//
// microtome

package microtome.core {

public class LoadTask
{
    public static const LOADING :int = 0;
    public static const ADDED_ITEMS :int = 1;
    public static const FINALIZED :int = 2;
    public static const ABORTED :int = 3;

    public var state :int = LOADING;
    public var pendingTemplatedPages :Vector.<TemplatedPage> = new <TemplatedPage>[];

    public function get libraryItems () :Vector.<LibraryItem> {
        return _libraryItems;
    }

    public function addItem (item :LibraryItem) :void {
        if (this.state != LOADING) {
            throw new Error("state != LOADING");
        }
        _libraryItems.push(item);
    }

    protected var _libraryItems :Vector.<LibraryItem> = new <LibraryItem>[];
}
}
