
package microtome.test {

import microtome.Page;
import microtome.prop.ObjectProp;
import microtome.prop.Prop;
import microtome.prop.PropSpec;

public class ListPage extends Page
{
    public function get list () :Array { return _list.value; }

    override public function get props () :Vector.<Prop> { return super.props.concat(new <Prop>[ _list, ]); }

    protected var _list :ObjectProp = new ObjectProp(s_listSpec);

    protected static const s_listSpec :PropSpec = new PropSpec("list", null, [ Array, PrimitivePage, ]);
}

}
