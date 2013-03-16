

package microtome.test {

// GENERATED IMPORTS START
import microtome.MutablePage;
import microtome.prop.ObjectProp;
import microtome.prop.Prop;
import microtome.prop.PropSpec;
// GENERATED IMPORTS END

// GENERATED CLASS_INTRO START
public class MutableObjectPage extends MutablePage
    implements ObjectPage
{
// GENERATED CLASS_INTRO END

// GENERATED PROPS START
    public function get foo () :String { return _foo.value; }
    public function set foo (val :String) :void { _foo.value = val; }

    override public function get props () :Vector.<Prop> { return super.props.concat(new <Prop>[ _foo, ]); }
// GENERATED PROPS END

// GENERATED IVARS START
    protected var _foo :ObjectProp = new ObjectProp(s_fooSpec);
// GENERATED IVARS END

// GENERATED STATICS START
    protected static const s_fooSpec :PropSpec = new PropSpec("foo", null, [ String, ]);
// GENERATED STATICS END

// GENERATED CLASS_OUTRO START
}
}
// GENERATED CLASS_OUTRO END
