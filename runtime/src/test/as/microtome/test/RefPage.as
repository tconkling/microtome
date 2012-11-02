//
// microtome-test

package microtome.test {

import microtome.Page;
import microtome.MutablePageRef;
import microtome.ObjectProp;
import microtome.PropSpec;

public class RefPage extends Page
{
    public function get nested () :PrimitivePage { return MutablePageRef(_nested.value).page; }

    override public function get props () :Array { return super.props.concat([ _nested ]); }

    protected var _nested :ObjectProp = new ObjectProp(_nestedSpec);

    protected static const _nestedSpec :PropSpec = new PropSpec("nested", null, [ MutablePageRef, PrimitivePage ]);
}
}