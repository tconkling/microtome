//
// microtome

package microtome.test {

import microtome.MutablePage;
import microtome.ObjectProp;
import microtome.PropSpec;

public class NestedPage extends MutablePage
{
    public function get nested () :PrimitivePage { return _nested.value; }

    override public function get props () :Array { return super.props.concat([ _nested ]); }

    protected var _nested :ObjectProp = new ObjectProp(_nestedSpec);

    private static const _nestedSpec :PropSpec = new PropSpec("nested", null, [ PrimitivePage ]);
}
}