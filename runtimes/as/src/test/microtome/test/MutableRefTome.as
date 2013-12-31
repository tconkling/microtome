

package microtome.test {

// GENERATED IMPORTS START
import microtome.MutableTome;
import microtome.core.TomeRef;
import microtome.prop.ObjectProp;
import microtome.prop.Prop;
import microtome.prop.PropSpec;
// GENERATED IMPORTS END

// GENERATED CLASS_INTRO START
public class MutableRefTome extends MutableTome implements RefTome
{
// GENERATED CLASS_INTRO END

// GENERATED CONSTRUCTOR START
    public function MutableRefTome (name :String) {
        super(name);
        initProps();
    }
// GENERATED CONSTRUCTOR END

// GENERATED CLASS_BODY START
    public function get mutableNested () :MutablePrimitiveTome { const ref :TomeRef = _nested.value; return (ref != null ? ref.tome : null); }
    public function get nested () :PrimitiveTome { return this.mutableNested; }
    public function set nested (val :PrimitiveTome) :void { _nested.value = (val != null ? TomeRef.fromTome(val) : null); }

    override public function get props () :Vector.<Prop> { return super.props.concat(new <Prop>[ _nested, ]); }

    private function initProps () :void {
        if (!s_propSpecsInited) {
            s_propSpecsInited = true;
            s_nestedSpec = new PropSpec("nested", null, [ TomeRef, MutablePrimitiveTome, ]);
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
