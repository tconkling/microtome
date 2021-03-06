

package microtome.test {

// GENERATED IMPORTS START
import microtome.MutableTome;
import microtome.prop.ObjectProp;
import microtome.prop.Prop;
import microtome.prop.PropSpec;
// GENERATED IMPORTS END

// GENERATED CLASS_INTRO START
public class MutableObjectTome extends MutableTome implements ObjectTome
{
// GENERATED CLASS_INTRO END

// GENERATED CONSTRUCTOR START
    public function MutableObjectTome (name :String) {
        super(name);
        initProps();
    }
// GENERATED CONSTRUCTOR END

// GENERATED CLASS_BODY START
    public function get foo () :String { return _foo.value; }
    public function set foo (val :String) :void { _foo.value = val; }

    override public function get props () :Vector.<Prop> { return super.props.concat(new <Prop>[ _foo, ]); }

    private function initProps () :void {
        if (!s_propSpecsInited) {
            s_propSpecsInited = true;
            s_fooSpec = new PropSpec("foo", null, [ String, ]);
        }
        _foo = new ObjectProp(this, s_fooSpec);
    }

    protected var _foo :ObjectProp;

    private static var s_propSpecsInited :Boolean;
    private static var s_fooSpec :PropSpec;
// GENERATED CLASS_BODY END

// GENERATED CLASS_OUTRO START
}
}
// GENERATED CLASS_OUTRO END
