//
// microtome

package microtome {

public interface PageRef
{
    function get pageType () :Class;
    function get pageName () :String;
    function get page () :*;
}
}
