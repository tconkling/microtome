//
// microtome

package microtome {

public interface Tome extends LibraryItem
{
    function get pageClass () :Class;
    function get size () :int;
    function forEach (fn :Function) :void;

    function pageNamed (name :String) :Page;
    function requirePageNamed (name :String) :Page;
}
}
