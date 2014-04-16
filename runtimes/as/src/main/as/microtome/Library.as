//
// microtome

package microtome {

import flash.utils.Dictionary;

import microtome.core.Defs;
import microtome.core.MicrotomeItem;
import microtome.core.microtome_internal;
import microtome.error.MicrotomeError;
import microtome.util.Util;

public final class Library implements MicrotomeItem {
    public function get name () :String {
        return null;
    }

    public function get library () :Library {
        return this;
    }

    public function get parent () :MicrotomeItem {
        return null;
    }

    public function get children () :Array {
        return Util.dictToArray(_tomes);
    }

    public function getTome (tomeId :String) :* {
        // A tomeId is a series of tome names, separated by dots
        // E.g. level1.baddies.big_boss

        var item :Tome = null;
        for each (var name :String in tomeId.split(Defs.ID_SEPARATOR)) {
            item = (item == null ? _tomes[name] : item.getChild(name));
            if (item == null) {
                return null;
            }
        }

        return item;
    }

    public function requireTome (tomeId :String) :* {
        var item :Tome = getTome(tomeId);
        if (item == null) {
            throw new MicrotomeError("No such tome", "tomeId", tomeId);
        }
        return item;
    }

    public function getChild (name :String) :* {
        return _tomes[name];
    }

    public function requireChild (name :String) :* {
        const tome :Tome = getChild(name);
        if (tome == null) {
            throw new Error("Missing required tome [name='" + name + "']");
        }
        return tome;
    }

    public function hasChild (name :String) :Boolean {
        return (name in _tomes);
    }

    public function addChild (tome :Tome) :void {
        if (hasChild(tome.name)) {
            throw new MicrotomeError("A child tome with that name already exists", "name", tome.name);
        } else if (tome.parent != null) {
            throw new MicrotomeError("Tome is already in a library", "tome", tome);
        }

        setTomeParent(tome, this);
        _tomes[tome.name] = tome;
    }

    public function removeChild (tome :Tome) :void {
        if (tome.parent != this) {
            throw new MicrotomeError("Tome is not in this library", "tome", tome);
        }
        setTomeParent(tome, null);
        delete _tomes[tome.name];
    }

    public function removeAllTomes () :void {
        for each (var item :Tome in _tomes) {
            setTomeParent(item, null);
        }
        _tomes = new Dictionary();
    }

    protected function setTomeParent (tome :Tome, library :Library) :void {
        MutableTome(tome).microtome_internal::setParent(library);
    }

    internal var _tomes :Dictionary = new Dictionary();
}
}
