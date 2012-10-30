//
// microtome

package microtome {

public class LoadTask
{
    public static const LOADING :int = 0;
    public static const ADDED_ITEMS :int = 1;
    public static const FINALIZED :int = 2;
    public static const ABORTED :int = 3;

    public var state :int = LOADING;
    public var pendingTemplatedPages :Array = [];

    public function get libraryItems () :Array {
        return _libraryItems;
    }

    public function addItem (item :LibraryItem) :void {
        if (this.state != LOADING) {
            throw new Error("state != LOADING");
        }
        _libraryItems.push(item);
    }

    protected var _libraryItems :Array = [];
}
}
