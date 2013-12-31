

package microtome.test {

// GENERATED IMPORTS START
import microtome.MutableTome;
import microtome.prop.ObjectProp;
import microtome.prop.Prop;
import microtome.prop.PropSpec;
// GENERATED IMPORTS END

// GENERATED CLASS_INTRO START
public class MutableListTome extends MutableTome implements ListTome
{
// GENERATED CLASS_INTRO END

// GENERATED CONSTRUCTOR START
    public function MutableListTome (name :String) {
        super(name);
        initProps();
    }
// GENERATED CONSTRUCTOR END

// GENERATED CLASS_BODY START
    public function get kids () :Array { return _kids.value; }
    public function set kids (val :Array) :void { _kids.value = val; }

    override public function get props () :Vector.<Prop> { return super.props.concat(new <Prop>[ _kids, ]); }

    private function initProps () :void {
        if (!s_propSpecsInited) {
            s_propSpecsInited = true;
            s_kidsSpec = new PropSpec("kids", null, [ Array, MutablePrimitiveTome, ]);
        }
        _kids = new ObjectProp(this, s_kidsSpec);
    }

    protected var _kids :ObjectProp;

    private static var s_propSpecsInited :Boolean;
    private static var s_kidsSpec :PropSpec;
// GENERATED CLASS_BODY END

// GENERATED CLASS_OUTRO START
}
}
// GENERATED CLASS_OUTRO END
