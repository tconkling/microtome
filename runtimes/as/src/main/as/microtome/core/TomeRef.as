//
// microtome

package microtome.core {

import microtome.Library;
import microtome.Tome;
import microtome.error.ResolveRefError;
import microtome.util.ClassUtil;

public final class TomeRef {
    public static function fromTome (tome :Tome) :TomeRef {
        const ref :TomeRef = new TomeRef(tome.id);
        ref._tome = tome;
        return ref;
    }

    public function TomeRef (tomeId :String) {
        _tomeId = tomeId;
    }

    public function get tomeId () :String {
        return _tomeId;
    }

    public function get tome () :* {
        return (_tome != null && _tome.library != null ? _tome : null);
    }

    public function resolve (lib :Library, tomeClass :Class) :void {
        const item :* = lib.getTome(_tomeId);
        if (item == null) {
            throw new ResolveRefError("No such item", "name", _tomeId);
        } else if (!(item is tomeClass)) {
            throw new ResolveRefError("Wrong tome type", "name", _tomeId,
                "expectedType", ClassUtil.getClassName(tomeClass),
                "actualType", ClassUtil.getClassName(item));
        }
        _tome = item;
    }

    public function clone () :TomeRef {
        var out :TomeRef = new TomeRef(_tomeId);
        out._tome = _tome;
        return out;
    }

    protected var _tomeId :String;
    protected var _tome :Tome;
}
}
