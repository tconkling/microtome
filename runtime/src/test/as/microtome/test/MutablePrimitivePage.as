

package microtome.test {

// GENERATED IMPORTS START
import microtome.MutablePage;
import microtome.prop.BoolProp;
import microtome.prop.IntProp;
import microtome.prop.NumberProp;
import microtome.prop.Prop;
import microtome.prop.PropSpec;
// GENERATED IMPORTS END

// GENERATED CLASS_INTRO START
public class MutablePrimitivePage extends MutablePage
    implements PrimitivePage
{
// GENERATED CLASS_INTRO END

// GENERATED CONSTRUCTOR START
    public function MutablePrimitivePage () {
        initProps();
    }
// GENERATED CONSTRUCTOR END

// GENERATED PROPS START
    public function get foo () :Boolean { return _foo.value; }
    public function set foo (val :Boolean) :void { _foo.value = val; }
    public function get bar () :int { return _bar.value; }
    public function set bar (val :int) :void { _bar.value = val; }
    public function get baz () :Number { return _baz.value; }
    public function set baz (val :Number) :void { _baz.value = val; }

    override public function get props () :Vector.<Prop> { return super.props.concat(new <Prop>[ _foo, _bar, _baz, ]); }

    private function initProps () :void {
        _foo = new BoolProp(this, s_fooSpec);
        _bar = new IntProp(this, s_barSpec);
        _baz = new NumberProp(this, s_bazSpec);
    }
// GENERATED PROPS END

// GENERATED IVARS START
    protected var _foo :BoolProp;
    protected var _bar :IntProp;
    protected var _baz :NumberProp;
// GENERATED IVARS END

// GENERATED STATICS START
    protected static const s_fooSpec :PropSpec = new PropSpec("foo", null, null);
    protected static const s_barSpec :PropSpec = new PropSpec("bar", null, null);
    protected static const s_bazSpec :PropSpec = new PropSpec("baz", null, null);
// GENERATED STATICS END

// GENERATED CLASS_OUTRO START
}
}
// GENERATED CLASS_OUTRO END
