//
// microtome-test

package microtome.test {

import microtome.Page;
import microtome.prop.ObjectProp;
import microtome.core.PageRef;
import microtome.prop.Prop;
import microtome.prop.PropSpec;

public class RefPage extends Page
{
    public function get nested () :PrimitivePage { return PageRef(_nested.value).page; }

    override public function get props () :Vector.<Prop> { return super.props.concat(new <Prop>[ _nested ]); }

    protected var _nested :ObjectProp = new ObjectProp(_nestedSpec);

    protected static const _nestedSpec :PropSpec = new PropSpec("nested", null, [ PageRef, PrimitivePage ]);
}
}
