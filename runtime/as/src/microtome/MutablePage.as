//
// microtome

package microtome {

public class MutablePage
    implements Page
{
    public function get name () :String {
        return _name;
    }

    public function get type () :ValueType {
        return new ValueType(Util.getClass(this), null);
    }

    public function get props () :Vector.<Prop> {
        return new Vector.<Prop>();
    }

    public function childNamed (name :String) :* {
        var prop :Prop = Util.getProp(this, name);
        return (prop != null && prop is ObjectProp ? ObjectProp(prop).value : null);
    }

    internal function set name (name :String) :void {
        _name = name;
    }

    protected var _name :String;
}
}
