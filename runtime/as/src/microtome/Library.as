//
// microtome

package microtome {
import flash.utils.Dictionary;

public class Library
{
    public function Library()
    {
    }

    protected var _items :Dictionary = new Dictionary();
    protected var _pageClasses :Dictionary = new Dictionary();
    protected var _objectMarshallers :Dictionary = new Dictionary();
}
}
