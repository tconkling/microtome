

package microtome.test {

// GENERATED IMPORTS START
import microtome.MutablePage;
import microtome.prop.ObjectProp;
import microtome.prop.Prop;
import microtome.prop.PropSpec;
// GENERATED IMPORTS END

// GENERATED CLASS_INTRO START
public class MutableNestedPage extends MutablePage
    implements NestedPage
{
// GENERATED CLASS_INTRO END

// GENERATED PROPS START
    public function get nested () :PrimitivePage { return _nested.value; }
    public function set nested (val :PrimitivePage) :void { _nested.value = val; }

    override public function get props () :Vector.<Prop> { return super.props.concat(new <Prop>[ _nested, ]); }
// GENERATED PROPS END

// GENERATED IVARS START
    protected var _nested :ObjectProp = new ObjectProp(s_nestedSpec);
// GENERATED IVARS END

// GENERATED STATICS START
    protected static const s_nestedSpec :PropSpec = new PropSpec("nested", null, [ ]);
// GENERATED STATICS END

// GENERATED CLASS_OUTRO START
}
}
// GENERATED CLASS_OUTRO END
