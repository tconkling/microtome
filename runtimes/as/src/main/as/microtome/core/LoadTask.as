//
// microtome

package microtome.core {

import microtome.Library;
import microtome.Tome;

internal class LoadTask
{
    public static const LOADING :int = 0;
    public static const ADDED_ITEMS :int = 1;
    public static const FINALIZED :int = 2;
    public static const ABORTED :int = 3;

    public var state :int = LOADING;
    public const pendingTemplatedTomes :Vector.<TemplatedTome> = new <TemplatedTome>[];

    public function LoadTask (library :Library) {
        _library = library;
    }

    public function get library () :Library {
        return _library;
    }

    public function get libraryItems () :Vector.<Tome> {
        return _tomes;
    }

    public function addTome (tome :Tome) :void {
        if (this.state != LOADING) {
            throw new Error("state != LOADING");
        }
        _tomes.push(tome);
    }

    public function isPendingTemplatedTome (tome :Tome) :Boolean {
        return pendingTemplatedTomes.some(function (ttome :TemplatedTome, ..._) :Boolean {
            return ttome.tome == tome;
        });
    }

    protected var _library :Library;
    protected const _tomes :Vector.<Tome> = new <Tome>[];
}
}
