

package microtome.test {

// GENERATED IMPORTS START
import microtome.MutablePage;
import microtome.core.PageRef;
import microtome.prop.ObjectProp;
import microtome.prop.Prop;
import microtome.prop.PropSpec;
// GENERATED IMPORTS END

// GENERATED CLASS_INTRO START
public class MutableRefPage extends MutablePage
    implements RefPage
{
// GENERATED CLASS_INTRO END

// GENERATED CONSTRUCTOR START
    public function MutableRefPage (name :String) {
        super(name);
        initProps();
    }
// GENERATED CONSTRUCTOR END

// GENERATED PROPS START
    public function get mutableNested () :MutablePrimitivePage { return PageRef(_nested.value).page; }
    public function get nested () :PrimitivePage { return PageRef(_nested.value).page; }
    public function set nested (val :PrimitivePage) :void { PageRef(_nested.value).page = val; }

    override public function get props () :Vector.<Prop> { return super.props.concat(new <Prop>[ _nested, ]); }

    private function initProps () :void {
        _nested = new ObjectProp(this, s_nestedSpec);
    }
// GENERATED PROPS END

// GENERATED IVARS START
    protected var _nested :ObjectProp;
// GENERATED IVARS END

// GENERATED STATICS START
    protected static const s_nestedSpec :PropSpec = new PropSpec("nested", null, [ PageRef, MutablePrimitivePage, ]);
// GENERATED STATICS END

// GENERATED CLASS_OUTRO START
}
}
// GENERATED CLASS_OUTRO END
