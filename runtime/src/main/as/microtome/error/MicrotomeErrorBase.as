//
// microtome

package microtome.error {

public class MicrotomeErrorBase extends Throwable
{
    public function MicrotomeErrorBase (message :String, args :Array = null) {
        super(Joiner.pairsArray(message, args || []));
    }
}
}

class Joiner {
    public static function pairsArray (message :String, args :Array) :String {
        return output(message, format("", args));
    }

    protected static function output (msg :String, details :String) :String {
        return (details == "") ? msg : msg + " [" + details + "]";
    }

    protected static function format (s :String, args :Array) :String {
        for (var ii :int = 0; ii < args.length; ii++) {
            if (s != "") {
                s += ", ";
            }
            s += argToString(args[ii]);
            if (++ii < args.length) {
                s += "=" + argToString(args[ii]);
            }
        }
        return s;
    }

    protected static function argToString (arg :*) :String {
        return String(arg);
    }
}

