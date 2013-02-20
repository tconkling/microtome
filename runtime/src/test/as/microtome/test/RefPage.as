

package microtome.test {

// GENERATED IMPORTS START
import microtome.Page;
import microtome.core.PageRef;
import microtome.prop.ObjectProp;
import microtome.prop.Prop;
import microtome.prop.PropSpec;
// GENERATED IMPORTS END

// GENERATED CLASS_INTRO START
public class RefPage extends Page {
// GENERATED CLASS_INTRO END

// GENERATED PROPS START
    public function get nested () :PrimitivePage { return PageRef(_nested.value).page; }

    override public function get props () :Vector.<Prop> { return super.props.concat(new <Prop>[ _nested, ]); }
// GENERATED PROPS END

// GENERATED IVARS START
    protected var _nested :ObjectProp = new ObjectProp(s_nestedSpec);
// GENERATED IVARS END

// GENERATED STATICS START
    protected static const s_nestedSpec :PropSpec = new PropSpec("nested", null, [ PageRef, PrimitivePage, ]);
// GENERATED STATICS END

// GENERATED CLASS_OUTRO START
}}
// GENERATED CLASS_OUTRO END
