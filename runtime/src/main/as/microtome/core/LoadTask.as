//
// microtome

package microtome.core {

import microtome.Library;

internal class LoadTask
{
    public static const LOADING :int = 0;
    public static const ADDED_ITEMS :int = 1;
    public static const FINALIZED :int = 2;
    public static const ABORTED :int = 3;

    public var state :int = LOADING;
    public const pendingTemplatedPages :Vector.<TemplatedPage> = new <TemplatedPage>[];

    public function LoadTask (library :Library) {
        _library = library;
    }

    public function get library () :Library {
        return _library;
    }

    public function get libraryItems () :Vector.<LibraryItem> {
        return _libraryItems;
    }

    public function addItem (item :LibraryItem) :void {
        if (this.state != LOADING) {
            throw new Error("state != LOADING");
        }
        _libraryItems.push(item);
    }

    protected var _library :Library;
    protected const _libraryItems :Vector.<LibraryItem> = new <LibraryItem>[];
}
}
