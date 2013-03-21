

package microtome.test {

// GENERATED IMPORTS START
import microtome.MutablePage;
import microtome.prop.ObjectProp;
import microtome.prop.Prop;
import microtome.prop.PropSpec;
// GENERATED IMPORTS END

// GENERATED CLASS_INTRO START
public class MutableListPage extends MutablePage
    implements ListPage
{
// GENERATED CLASS_INTRO END

// GENERATED CONSTRUCTOR START
    public function MutableListPage () {
        initProps();
    }
// GENERATED CONSTRUCTOR END

// GENERATED PROPS START
    public function get list () :Array { return _list.value; }
    public function set list (val :Array) :void { _list.value = val; }

    override public function get props () :Vector.<Prop> { return super.props.concat(new <Prop>[ _list, ]); }

    private function initProps () :void {
        _list = new ObjectProp(this, s_listSpec);
    }
// GENERATED PROPS END

// GENERATED IVARS START
    protected var _list :ObjectProp;
// GENERATED IVARS END

// GENERATED STATICS START
    protected static const s_listSpec :PropSpec = new PropSpec("list", null, [ Array, MutablePrimitivePage, ]);
// GENERATED STATICS END

// GENERATED CLASS_OUTRO START
}
}
// GENERATED CLASS_OUTRO END
