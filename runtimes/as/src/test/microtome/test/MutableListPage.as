

package microtome.test {

// GENERATED IMPORTS START
import microtome.MutablePage;
import microtome.prop.ObjectProp;
import microtome.prop.Prop;
import microtome.prop.PropSpec;
// GENERATED IMPORTS END

// GENERATED CLASS_INTRO START
public class MutableListPage extends MutablePage implements ListPage
{
// GENERATED CLASS_INTRO END

// GENERATED CONSTRUCTOR START
    public function MutableListPage (name :String) {
        super(name);
        initProps();
    }
// GENERATED CONSTRUCTOR END

// GENERATED PROPS START
    public function get kids () :Array { return _kids.value; }
    public function set kids (val :Array) :void { _kids.value = val; }

    override public function get props () :Vector.<Prop> { return super.props.concat(new <Prop>[ _kids, ]); }

    private function initProps () :void {
        if (!s_propSpecsInited) {
            s_propSpecsInited = true;
            s_kidsSpec = new PropSpec("kids", null, [ Array, MutablePrimitivePage, ]);
        }
        _kids = new ObjectProp(this, s_kidsSpec);
    }
// GENERATED PROPS END

// GENERATED IVARS START
    protected var _kids :ObjectProp;
// GENERATED IVARS END

// GENERATED STATICS START
    private static var s_propSpecsInited :Boolean;
    private static var s_kidsSpec :PropSpec;
// GENERATED STATICS END

// GENERATED CLASS_OUTRO START
}
}
// GENERATED CLASS_OUTRO END
