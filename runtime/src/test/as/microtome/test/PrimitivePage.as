//
// microtome-test

package microtome.test {

import microtome.BoolProp;
import microtome.IntProp;
import microtome.NumberProp;
import microtome.Page;
import microtome.PropSpec;

public class PrimitivePage extends Page
{
    public function get foo () :Boolean { return _foo.value; }
    public function get bar () :int { return _bar.value; }
    public function get baz () :Number { return _baz.value; }

    override public function get props () :Array { return super.props.concat([ _foo, _bar, _baz ]); }

    protected var _foo :BoolProp = new BoolProp(_fooSpec);
    protected var _bar :IntProp = new IntProp(_barSpec);
    protected var _baz :NumberProp = new NumberProp(_bazSpec);

    private static const _fooSpec :PropSpec = new PropSpec("foo", null, null);
    private static const _barSpec :PropSpec = new PropSpec("bar", null, null);
    private static const _bazSpec :PropSpec = new PropSpec("baz", null, null);
}
}
