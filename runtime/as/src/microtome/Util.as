//
// microtome

package microtome {

public class Util
{
    public static function getProp (page :Page, name :String) :Prop {
        for each (var prop :Prop in page.props) {
            if (prop.name == name) {
                return prop;
            }
        }
        return null;
    }
}
}
