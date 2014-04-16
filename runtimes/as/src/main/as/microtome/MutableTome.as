//
// microtome

package microtome {

import flash.utils.Dictionary;

import microtome.core.Defs;
import microtome.core.MicrotomeItem;
import microtome.core.TypeInfo;
import microtome.core.microtome_internal;
import microtome.error.MicrotomeError;
import microtome.prop.Prop;
import microtome.util.ClassUtil;
import microtome.util.Util;

public class MutableTome implements Tome
{
    public function MutableTome (name :String) {
        if (!Util.validLibraryItemName(name)) {
            throw new ArgumentError("Invalid Tome name '" + name + "'");
        }
        _name = name;
    }

    /** The Tome's ID is its fully qualified name (e.g. actors.baddies.orc) */
    public final function get id () :String {
        if (this.library == null) {
            throw new MicrotomeError("Tome must be in a library to have an id", "tome", this);
        }

        var out :String = _name;
        var curItem :MicrotomeItem = _parent;
        while (curItem != null && curItem.library != curItem) {
            out = curItem.name + Defs.ID_SEPARATOR + out;
            curItem = curItem.parent;
        }
        return out;
    }

    public final function get name () :String {
        return _name;
    }

    public final function get parent () :MicrotomeItem {
        return _parent;
    }

    public final function get library () :Library {
        return (_parent != null ? _parent.library : null);
    }

    public final function get typeInfo () :TypeInfo {
        if (_typeInfo == null) {
            _typeInfo = new TypeInfo(ClassUtil.getClass(this), null);
        }
        return _typeInfo;
    }

    public function get numChildren () :uint {
        return _numChildren;
    }

    public final function get children () :Array {
        return (_tomes != null ? Util.dictToArray(_tomes) : []);
    }

    public function get props () :Vector.<Prop> {
        return EMPTY_VEC;
    }

    public function hasChild (name :String) :Boolean {
        return (getChild(name) != null);
    }

    public function getChild (name :String) :* {
        return (_tomes != null ? _tomes[name] : null);
    }

    public function requireChild (name :String) :* {
        const tome :Tome = getChild(name);
        if (tome == null) {
            throw new Error("Missing required tome [name='" + name + "']");
        }
        return tome;
    }

    /**
     * Iterates over the named tome children in the Tome.
     * fn should take a single MutableTome argument. It can optionally return a Boolean specifying
     * whether to stop the iteration.
     */
    public function forEachChild (fn :Function) :void {
        if (_tomes != null) {
            for each (var tome :Tome in _tomes) {
                if (fn(tome)) {
                    return;
                }
            }
        }
    }

    public function addChild (tome :MutableTome) :void {
        if (tome.name == null) {
            throw new MicrotomeError("Tome is missing name", "type", ClassUtil.getClassName(tome));
        } else if (tome.parent != null) {
            throw new MicrotomeError("Tome is already parented", "parent", tome.parent);
        } else if (getChild(name) != null) {
            throw new MicrotomeError("Duplicate tome name '" + tome.name + "'");
        }

        tome.microtome_internal::setParent(this);
        if (_tomes == null) {
            _tomes = new Dictionary();
        }
        _tomes[tome.name] = tome;
        ++_numChildren;
    }

    public function removeChild (tome :MutableTome) :void {
        if (tome.parent != this) {
            throw new MicrotomeError("Tome is not a child of this tome", "tome", tome);
        }
        tome.microtome_internal::setParent(null);
        delete _tomes[tome.name];
        --_numChildren;
    }

    public function toString () :String {
        return ClassUtil.tinyClassName(this) + ":'" + _name + "'";
    }

    microtome_internal final function setParent (parent :MicrotomeItem) :void {
        _parent = parent;
    }

    protected var _parent :MicrotomeItem;
    protected var _name :String;

    private var _typeInfo :TypeInfo;
    private var _tomes :Dictionary;
    private var _numChildren :uint;

    protected static const EMPTY_VEC :Vector.<Prop> = new Vector.<Prop>(0, true);
}
}
