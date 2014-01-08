//
// microtome

package microtome {

import flash.utils.Dictionary;

import microtome.core.Defs;
import microtome.core.MicrotomeItem;
import microtome.core.microtome_internal;
import microtome.error.MicrotomeError;
import microtome.util.Util;

public final class Library implements MicrotomeItem
{
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

    public function getTomeWithQualifiedName (qualifiedName :String) :* {
        // A qualifiedName is a series of tome names, separated by dots
        // E.g. level1.baddies.big_boss

        var item :Tome = null;
        for each (var name :String in qualifiedName.split(Defs.NAME_SEPARATOR)) {
            item = (item == null ? _tomes[name] : item.getTome(name));
            if (item == null) {
                return null;
            }
        }

        return item;
    }

    public function requireTomeWithQualifiedName (qualifiedName :String) :* {
        var item :Tome = getTomeWithQualifiedName(qualifiedName);
        if (item == null) {
            throw new MicrotomeError("No such tome", "qualifiedName", qualifiedName);
        }
        return item;
    }

    public function getTome (name :String) :* {
        return _tomes[name];
    }

    public function hasTome (name :String) :Boolean {
        return (name in _tomes);
    }

    public function addTome (tome :Tome) :void {
        if (hasTome(tome.name)) {
            throw new MicrotomeError("A tome with that name already exists", "name", tome.name);
        } else if (tome.parent != null) {
            throw new MicrotomeError("Tome is already in a library", "tome", tome);
        }

        setTomeParent(tome, this);
        _tomes[tome.name] = tome;
    }

    public function removeTome (tome :Tome) :void {
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
