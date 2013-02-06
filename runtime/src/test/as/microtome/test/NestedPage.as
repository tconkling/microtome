//
// microtome

package microtome.test {

import microtome.Page;
import microtome.prop.ObjectProp;
import microtome.prop.Prop;
import microtome.prop.PropSpec;

public class NestedPage extends Page
{
    public function get nested () :PrimitivePage { return _nested.value; }

    override public function get props () :Vector.<Prop> { return super.props.concat(new <Prop>[ _nested ]); }

    protected var _nested :ObjectProp = new ObjectProp(_nestedSpec);

    private static const _nestedSpec :PropSpec = new PropSpec("nested", null, [ PrimitivePage ]);
}
}
