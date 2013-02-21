//
// microtome

package microtome.util {

import microtome.Page;
import microtome.core.Defs;
import microtome.prop.Prop;

public class Util
{
    public static function validLibraryItemName (name :String) :Boolean {
        // library items cannot have '.' in the name
        return name.indexOf(Defs.NAME_SEPARATOR) < 0;
    }

    public static function getProp (page :Page, name :String) :Prop {
        for each (var prop :Prop in page.props) {
            if (prop.name == name) {
                return prop;
            }
        }
        return null;
    }

    /**
     * Parse an integer more anally than the built-in parseInt() function,
     * throwing an ArgumentError if there are any invalid characters.
     *
     * The built-in parseInt() will ignore trailing non-integer characters.
     *
     * @param str The string to parse.
     * @param radix The radix to use, from 2 to 16. If not specified the radix will be 10,
     *        unless the String begins with "0x" in which case it will be 16,
     *        or the String begins with "0" in which case it will be 8.
     */
    public static function parseInteger (str :String, radix :uint = 0) :int
    {
        return int(parseInt0(str, radix, true));
    }

    /**
     * Parse a Number from a String, throwing an ArgumentError if there are any
     * invalid characters.
     *
     * 1.5, 2e-3, -Infinity, Infinity, and NaN are all valid Strings.
     *
     * @param str the String to parse.
     */
    public static function parseNumber (str :String) :Number {
        if (str == null) {
            throw new ArgumentError("Cannot parseNumber(null)");
        }

        // deal with a few special cases
        if (str == "Infinity") {
            return Infinity;
        } else if (str == "-Infinity") {
            return -Infinity;
        } else if (str == "NaN") {
            return NaN;
        }

        const noCommas :String = str.replace(",", "");

        if (DECIMAL_REGEXP.exec(noCommas) == null) {
            throw new ArgumentError("Could not convert to Number: '" + str + "'");
        }

        // let Flash do the actual conversion
        return parseFloat(noCommas);
    }

    /**
     * Does the specified string start with any of the specified substrings.
     */
    public static function startsWith (str :String, substr :String, ... additionalSubstrs) :Boolean  {
        if (str.lastIndexOf(substr, 0) == 0) {
            return true;
        }
        for each (var additional :String in additionalSubstrs) {
            if (str.lastIndexOf(additional, 0) == 0) {
                return true;
            }
        }
        return false;
    }

    /**
     * Internal helper function for parseInteger and parseUnsignedInteger.
     */
    protected static function parseInt0 (str :String, radix :uint, allowNegative :Boolean) :Number {
        if (str == null) {
            throw new ArgumentError("Cannot parseInt(null)");
        }

        var negative :Boolean = (str.charAt(0) == "-");
        if (negative) {
            str = str.substring(1);
        }

        // handle this special case immediately, to prevent confusion about
        // a leading 0 meaning "parse as octal"
        if (str == "0") {
            return 0;
        }

        if (radix == 0) {
            if (startsWith(str, "0x")) {
                str = str.substring(2);
                radix = 16;

            } else if (startsWith(str, "0")) {
                str = str.substring(1);
                radix = 8;

            } else {
                radix = 10;
            }

        } else if (radix == 16 && startsWith(str, "0x")) {
            str = str.substring(2);

        } else if (radix < 2 || radix > 16) {
            throw new ArgumentError("Radix out of range: " + radix);
        }

        // now verify that str only contains valid chars for the radix
        for (var ii :int = 0; ii < str.length; ii++) {
            var dex :int = HEX.indexOf(str.charAt(ii).toLowerCase());
            if (dex == -1 || dex >= radix) {
                throw new ArgumentError("Invalid characters in String [string=" + arguments[0] +
                    ", radix=" + radix);
            }
        }

        var result :Number = parseInt(str, radix);
        if (isNaN(result)) {
            // this shouldn't happen..
            throw new ArgumentError("Could not parseInt: " + arguments[0]);
        }
        if (negative) {
            result *= -1;
        }
        return result;
    }

    /** Hexidecimal digits. */
    protected static const HEX :Array = [ "0", "1", "2", "3", "4",
        "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f" ];

    protected static const DECIMAL_REGEXP :RegExp = /^-?[0-9]*\.?[0-9]+(e-?[0-9]+)?$/;
}
}
