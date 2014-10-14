

package microtome.test {

// GENERATED IMPORTS START
import microtome.MutableTome;
import microtome.prop.BoolProp;
import microtome.prop.IntProp;
import microtome.prop.NumberProp;
import microtome.prop.Prop;
import microtome.prop.PropSpec;
// GENERATED IMPORTS END

// GENERATED CLASS_INTRO START
public class MutablePrimitiveTome extends MutableTome implements PrimitiveTome
{
// GENERATED CLASS_INTRO END

// GENERATED CONSTRUCTOR START
    public function MutablePrimitiveTome (name :String) {
        super(name);
        initProps();
    }
// GENERATED CONSTRUCTOR END

// GENERATED CLASS_BODY START
    public function get foo () :Boolean { return _foo.value; }
    public function set foo (val :Boolean) :void { _foo.value = val; }
    public function get bar () :int { return _bar.value; }
    public function set bar (val :int) :void { _bar.value = val; }
    public function get baz () :Number { return _baz.value; }
    public function set baz (val :Number) :void { _baz.value = val; }
    public function get dead () :int { return _dead.value; }
    public function set dead (val :int) :void { _dead.value = val; }

    override public function get props () :Vector.<Prop> { return super.props.concat(new <Prop>[ _foo, _bar, _baz, _dead, ]); }

    private function initProps () :void {
        if (!s_propSpecsInited) {
            s_propSpecsInited = true;
            s_fooSpec = new PropSpec("foo", null, [ Boolean, ]);
            s_barSpec = new PropSpec("bar", null, [ int, ]);
            s_bazSpec = new PropSpec("baz", null, [ Number, ]);
            s_deadSpec = new PropSpec("dead", null, [ int, ]);
        }
        _foo = new BoolProp(this, s_fooSpec);
        _bar = new IntProp(this, s_barSpec);
        _baz = new NumberProp(this, s_bazSpec);
        _dead = new IntProp(this, s_deadSpec);
    }

    protected var _foo :BoolProp;
    protected var _bar :IntProp;
    protected var _baz :NumberProp;
    protected var _dead :IntProp;

    private static var s_propSpecsInited :Boolean;
    private static var s_fooSpec :PropSpec;
    private static var s_barSpec :PropSpec;
    private static var s_bazSpec :PropSpec;
    private static var s_deadSpec :PropSpec;
// GENERATED CLASS_BODY END

// GENERATED CLASS_OUTRO START
}
}
// GENERATED CLASS_OUTRO END
