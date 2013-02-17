
package microtome.test {

import microtome.Page;
import microtome.prop.IntProp;
import microtome.prop.ObjectProp;
import microtome.prop.Prop;
import microtome.prop.PropSpec;

public class AnnotationPage extends Page
{
    public function get foo () :int { return _foo.value; }
    public function get bar () :int { return _bar.value; }
    public function get primitives () :PrimitivePage { return _primitives.value; }

    override public function get props () :Vector.<Prop> { return super.props.concat(new <Prop>[ _foo, _bar, _primitives, ]); }

    protected var _foo :IntProp = new IntProp(s_fooSpec);
    protected var _bar :IntProp = new IntProp(s_barSpec);
    protected var _primitives :ObjectProp = new ObjectProp(s_primitivesSpec);

    protected static const s_fooSpec :PropSpec = new PropSpec("foo", { "min": 3.0, "max": 5.0 }, null);
    protected static const s_barSpec :PropSpec = new PropSpec("bar", { "default": 3.0 }, null);
    protected static const s_primitivesSpec :PropSpec = new PropSpec("primitives", { "nullable": true }, [ PrimitivePage, ]);
}

}
