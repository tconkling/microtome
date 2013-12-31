

package microtome.test {

// GENERATED IMPORTS START
import microtome.MutableTome;
import microtome.prop.ObjectProp;
import microtome.prop.Prop;
import microtome.prop.PropSpec;
// GENERATED IMPORTS END

// GENERATED CLASS_INTRO START
public class MutableNestedTome extends MutableTome implements NestedTome
{
// GENERATED CLASS_INTRO END

// GENERATED CONSTRUCTOR START
    public function MutableNestedTome (name :String) {
        super(name);
        initProps();
    }
// GENERATED CONSTRUCTOR END

// GENERATED CLASS_BODY START
    public function get mutableNested () :MutablePrimitiveTome { return _nested.value; }
    public function get nested () :PrimitiveTome { return _nested.value; }
    public function set nested (val :PrimitiveTome) :void { _nested.value = val; }

    override public function get props () :Vector.<Prop> { return super.props.concat(new <Prop>[ _nested, ]); }

    private function initProps () :void {
        if (!s_propSpecsInited) {
            s_propSpecsInited = true;
            s_nestedSpec = new PropSpec("nested", null, [ MutablePrimitiveTome, ]);
        }
        _nested = new ObjectProp(this, s_nestedSpec);
    }

    protected var _nested :ObjectProp;

    private static var s_propSpecsInited :Boolean;
    private static var s_nestedSpec :PropSpec;
// GENERATED CLASS_BODY END

// GENERATED CLASS_OUTRO START
}
}
// GENERATED CLASS_OUTRO END
