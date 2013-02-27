

package microtome.test {

// GENERATED IMPORTS START
import microtome.Page;
import microtome.prop.ObjectProp;
import microtome.prop.Prop;
import microtome.prop.PropSpec;
// GENERATED IMPORTS END

// GENERATED CLASS_INTRO START
public class ListPage extends Page {
// GENERATED CLASS_INTRO END

// GENERATED PROPS START
    public function get list () :Array { return _list.value; }

    override public function get props () :Vector.<Prop> { return super.props.concat(new <Prop>[ _list, ]); }
// GENERATED PROPS END

// GENERATED IVARS START
    protected var _list :ObjectProp = new ObjectProp(s_listSpec);
// GENERATED IVARS END

// GENERATED STATICS START
    protected static const s_listSpec :PropSpec = new PropSpec("list", null, [ Array, PrimitivePage, ]);
// GENERATED STATICS END

// GENERATED CLASS_OUTRO START
}}
// GENERATED CLASS_OUTRO END