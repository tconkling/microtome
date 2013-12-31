

package microtome.test {

// GENERATED IMPORTS START
import microtome.MutableTome;
import microtome.Tome;
import microtome.prop.ObjectProp;
import microtome.prop.Prop;
import microtome.prop.PropSpec;
// GENERATED IMPORTS END

// GENERATED CLASS_INTRO START
public class MutableGenericNestedTome extends MutableTome implements GenericNestedTome
{
// GENERATED CLASS_INTRO END

// GENERATED CONSTRUCTOR START
    public function MutableGenericNestedTome (name :String) {
        super(name);
        initProps();
    }
// GENERATED CONSTRUCTOR END

// GENERATED CLASS_BODY START
    public function get mutableGeneric () :MutableTome { return _generic.value; }
    public function get generic () :Tome { return _generic.value; }
    public function set generic (val :Tome) :void { _generic.value = val; }

    override public function get props () :Vector.<Prop> { return super.props.concat(new <Prop>[ _generic, ]); }

    private function initProps () :void {
        if (!s_propSpecsInited) {
            s_propSpecsInited = true;
            s_genericSpec = new PropSpec("generic", null, [ MutableTome, ]);
        }
        _generic = new ObjectProp(this, s_genericSpec);
    }

    protected var _generic :ObjectProp;

    private static var s_propSpecsInited :Boolean;
    private static var s_genericSpec :PropSpec;
// GENERATED CLASS_BODY END

// GENERATED CLASS_OUTRO START
}
}
// GENERATED CLASS_OUTRO END
