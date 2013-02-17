
package microtome.test {

import microtome.Page;
import microtome.prop.BoolProp;
import microtome.prop.IntProp;
import microtome.prop.NumberProp;
import microtome.prop.Prop;
import microtome.prop.PropSpec;

public class PrimitivePage extends Page
{
    public function get foo () :Boolean { return _foo.value; }
    public function get bar () :int { return _bar.value; }
    public function get baz () :Number { return _baz.value; }

    override public function get props () :Vector.<Prop> { return super.props.concat(new <Prop>[ _foo, _bar, _baz, ]); }

    protected var _foo :BoolProp = new BoolProp(s_fooSpec);
    protected var _bar :IntProp = new IntProp(s_barSpec);
    protected var _baz :NumberProp = new NumberProp(s_bazSpec);

    protected static const s_fooSpec :PropSpec = new PropSpec("foo", null, null);
    protected static const s_barSpec :PropSpec = new PropSpec("bar", null, null);
    protected static const s_bazSpec :PropSpec = new PropSpec("baz", null, null);
}

}
