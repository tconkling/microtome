

package microtome.test {

// GENERATED IMPORTS START
import microtome.MutablePage;
import microtome.prop.ObjectProp;
import microtome.prop.Prop;
import microtome.prop.PropSpec;
// GENERATED IMPORTS END

// GENERATED CLASS_INTRO START
public class MutableNestedPage extends MutablePage implements NestedPage
{
// GENERATED CLASS_INTRO END

// GENERATED CONSTRUCTOR START
    public function MutableNestedPage (name :String) {
        super(name);
        initProps();
    }
// GENERATED CONSTRUCTOR END

// GENERATED PROPS START
    public function get mutableNested () :MutablePrimitivePage { return _nested.value; }
    public function get nested () :PrimitivePage { return _nested.value; }
    public function set nested (val :PrimitivePage) :void { _nested.value = val; }

    override public function get props () :Vector.<Prop> { return super.props.concat(new <Prop>[ _nested, ]); }

    private function initProps () :void {
        if (!s_propSpecsInited) {
            s_propSpecsInited = true;
            s_nestedSpec = new PropSpec("nested", null, [ MutablePrimitivePage, ]);
        }
        _nested = new ObjectProp(this, s_nestedSpec);
    }
// GENERATED PROPS END

// GENERATED IVARS START
    protected var _nested :ObjectProp;
// GENERATED IVARS END

// GENERATED STATICS START
    private static var s_propSpecsInited :Boolean;
    private static var s_nestedSpec :PropSpec;
// GENERATED STATICS END

// GENERATED CLASS_OUTRO START
}
}
// GENERATED CLASS_OUTRO END
