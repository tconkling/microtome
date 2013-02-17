
package microtome.test {

import microtome.Page;
import microtome.core.PageRef;
import microtome.prop.ObjectProp;
import microtome.prop.Prop;
import microtome.prop.PropSpec;

public class RefPage extends Page
{
    public function get nested () :PrimitivePage { return PageRef(_nested.value).page; }

    override public function get props () :Vector.<Prop> { return super.props.concat(new <Prop>[ _nested, ]); }

    protected var _nested :ObjectProp = new ObjectProp(s_nestedSpec);

    protected static const s_nestedSpec :PropSpec = new PropSpec("nested", null, [ PageRef, PrimitivePage, ]);
}

}
