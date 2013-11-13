

package microtome.test {

// GENERATED IMPORTS START
import microtome.MutableTome;
import microtome.prop.IntProp;
import microtome.prop.ObjectProp;
import microtome.prop.Prop;
import microtome.prop.PropSpec;
// GENERATED IMPORTS END

// GENERATED CLASS_INTRO START
public class MutableAnnotationTome extends MutableTome implements AnnotationTome
{
// GENERATED CLASS_INTRO END

// GENERATED CONSTRUCTOR START
    public function MutableAnnotationTome (name :String) {
        super(name);
        initProps();
    }
// GENERATED CONSTRUCTOR END

// GENERATED PROPS START
    public function get foo () :int { return _foo.value; }
    public function set foo (val :int) :void { _foo.value = val; }
    public function get bar () :int { return _bar.value; }
    public function set bar (val :int) :void { _bar.value = val; }
    public function get mutablePrimitives () :MutablePrimitiveTome { return _primitives.value; }
    public function get primitives () :PrimitiveTome { return _primitives.value; }
    public function set primitives (val :PrimitiveTome) :void { _primitives.value = val; }

    override public function get props () :Vector.<Prop> { return super.props.concat(new <Prop>[ _foo, _bar, _primitives, ]); }

    private function initProps () :void {
        if (!s_propSpecsInited) {
            s_propSpecsInited = true;
            s_fooSpec = new PropSpec("foo", { "min": 3.0, "max": 5.0 }, [ int, ]);
            s_barSpec = new PropSpec("bar", { "default": 3.0 }, [ int, ]);
            s_primitivesSpec = new PropSpec("primitives", { "nullable": true }, [ MutablePrimitiveTome, ]);
        }
        _foo = new IntProp(this, s_fooSpec);
        _bar = new IntProp(this, s_barSpec);
        _primitives = new ObjectProp(this, s_primitivesSpec);
    }
// GENERATED PROPS END

// GENERATED IVARS START
    protected var _foo :IntProp;
    protected var _bar :IntProp;
    protected var _primitives :ObjectProp;
// GENERATED IVARS END

// GENERATED STATICS START
    private static var s_propSpecsInited :Boolean;
    private static var s_fooSpec :PropSpec;
    private static var s_barSpec :PropSpec;
    private static var s_primitivesSpec :PropSpec;
// GENERATED STATICS END

// GENERATED CLASS_OUTRO START
}
}
// GENERATED CLASS_OUTRO END
