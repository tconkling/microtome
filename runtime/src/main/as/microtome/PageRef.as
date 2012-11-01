//
// microtome

package microtome {

public interface PageRef
{
    function get pageClass () :Class;
    function get pageName () :String;
    function get page () :*;
}
}
