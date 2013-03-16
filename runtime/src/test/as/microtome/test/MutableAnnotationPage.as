

package microtome.test {

// GENERATED IMPORTS START
import microtome.MutablePage;
import microtome.prop.IntProp;
import microtome.prop.ObjectProp;
import microtome.prop.Prop;
import microtome.prop.PropSpec;
// GENERATED IMPORTS END

// GENERATED CLASS_INTRO START
public class MutableAnnotationPage extends MutablePage
    implements AnnotationPage
{
// GENERATED CLASS_INTRO END

// GENERATED PROPS START
    public function get foo () :int { return _foo.value; }
    public function set foo (val :int) :void { _foo.value = val; }
    public function get bar () :int { return _bar.value; }
    public function set bar (val :int) :void { _bar.value = val; }
    public function get mutablePrimitives () :MutablePrimitivePage { return _primitives.value; }
    public function get primitives () :PrimitivePage { return _primitives.value; }
    public function set primitives (val :PrimitivePage) :void { _primitives.value = val; }

    override public function get props () :Vector.<Prop> { return super.props.concat(new <Prop>[ _foo, _bar, _primitives, ]); }
// GENERATED PROPS END

// GENERATED IVARS START
    protected var _foo :IntProp = new IntProp(s_fooSpec);
    protected var _bar :IntProp = new IntProp(s_barSpec);
    protected var _primitives :ObjectProp = new ObjectProp(s_primitivesSpec);
// GENERATED IVARS END

// GENERATED STATICS START
    protected static const s_fooSpec :PropSpec = new PropSpec("foo", { "min": 3.0, "max": 5.0 }, null);
    protected static const s_barSpec :PropSpec = new PropSpec("bar", { "default": 3.0 }, null);
    protected static const s_primitivesSpec :PropSpec = new PropSpec("primitives", { "nullable": true }, [ MutablePrimitivePage, ]);
// GENERATED STATICS END

// GENERATED CLASS_OUTRO START
}
}
// GENERATED CLASS_OUTRO END
