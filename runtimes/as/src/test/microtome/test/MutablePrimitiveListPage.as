

package microtome.test {

// GENERATED IMPORTS START
import microtome.MutablePage;
import microtome.prop.ObjectProp;
import microtome.prop.Prop;
import microtome.prop.PropSpec;
// GENERATED IMPORTS END

// GENERATED CLASS_INTRO START
public class MutablePrimitiveListPage extends MutablePage
    implements PrimitiveListPage
{
// GENERATED CLASS_INTRO END

// GENERATED CONSTRUCTOR START
    public function MutablePrimitiveListPage (name :String) {
        super(name);
        initProps();
    }
// GENERATED CONSTRUCTOR END

// GENERATED PROPS START
    public function get strings () :Array { return _strings.value; }
    public function set strings (val :Array) :void { _strings.value = val; }
    public function get booleans () :Array { return _booleans.value; }
    public function set booleans (val :Array) :void { _booleans.value = val; }
    public function get ints () :Array { return _ints.value; }
    public function set ints (val :Array) :void { _ints.value = val; }
    public function get floats () :Array { return _floats.value; }
    public function set floats (val :Array) :void { _floats.value = val; }

    override public function get props () :Vector.<Prop> { return super.props.concat(new <Prop>[ _strings, _booleans, _ints, _floats, ]); }

    private function initProps () :void {
        _strings = new ObjectProp(this, s_stringsSpec);
        _booleans = new ObjectProp(this, s_booleansSpec);
        _ints = new ObjectProp(this, s_intsSpec);
        _floats = new ObjectProp(this, s_floatsSpec);
    }
// GENERATED PROPS END

// GENERATED IVARS START
    protected var _strings :ObjectProp;
    protected var _booleans :ObjectProp;
    protected var _ints :ObjectProp;
    protected var _floats :ObjectProp;
// GENERATED IVARS END

// GENERATED STATICS START
    protected static const s_stringsSpec :PropSpec = new PropSpec("strings", null, [ Array, String, ]);
    protected static const s_booleansSpec :PropSpec = new PropSpec("booleans", null, [ Array, Boolean, ]);
    protected static const s_intsSpec :PropSpec = new PropSpec("ints", null, [ Array, int, ]);
    protected static const s_floatsSpec :PropSpec = new PropSpec("floats", null, [ Array, Number, ]);
// GENERATED STATICS END

// GENERATED CLASS_OUTRO START
}
}
// GENERATED CLASS_OUTRO END
