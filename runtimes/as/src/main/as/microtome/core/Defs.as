//
// microtome

package microtome.core {

import microtome.MutableTome;
import microtome.util.ClassUtil;
import microtome.util.Util;

public class Defs
{
    public static const MUTABLE_TOME_NAME :String = Util.tomeTypeName(MutableTome);

    public static const TOME_TYPE_ATTR :String = "tomeType";
    public static const TEMPLATE_ATTR :String = "template";

    public static const NULLABLE_ANNOTATION :String = "nullable";
    public static const MIN_ANNOTATION :String = "min";
    public static const MAX_ANNOTATION :String = "max";
    public static const DEFAULT_ANNOTATION :String = "default";

    public static const NAME_SEPARATOR :String = ".";
}
}
