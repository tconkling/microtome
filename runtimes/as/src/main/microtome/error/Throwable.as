//
// microtome

package microtome.error {

import flash.errors.IllegalOperationError;
import flash.utils.Dictionary;

import microtome.util.ClassUtil;

/**
 * An Error subclass that supports chaining via the "cause" parameter (similar to
 * java.lang.Throwable).
 */
public class Throwable extends Error
{
    public function Throwable (message :String = "", cause :Error = null) {
        super(message);
        // save a reference to Error.getStackTrace so that we can use our own implementation
        // but still access the original.
        _originalGetStackTrace = super.getStackTrace;
        if (cause != null) {
            initCause(cause);
        }
    }

    public function get cause () :Error {
        return _cause;
    }

    public function initCause (val :Error) :Throwable {
        if (_cause != null) {
            throw new IllegalOperationError("Can't overwrite cause");
        } else if (val == this) {
            throw new ArgumentError("Self-causation not permitted");
        }
        _cause = val;
        return this;
    }

    override public function getStackTrace () :String {
        return printStackTrace();
    }

    protected function printStackTrace () :String {
        // print our stack trace
        var out :String = ClassUtil.getClassName(this) + "\n";
        var ourTrace :Array = getStackTraceElements(this);
        out += ourTrace.join("\n") + "\n";

        // print our cause
        if (_cause != null) {
            var dejaVu :Dictionary = new Dictionary();
            dejaVu[this] = this;
            out += printEnclosedStackTrace(_cause, ourTrace, dejaVu);
        }

        return out;
    }

    protected static function printEnclosedStackTrace (e :Error, enclosingTrace :Array, dejaVu :Dictionary) :String {
        var out :String = "";
        if (e in dejaVu) {
            out += "\t[CIRCULAR REFERENCE:" + ClassUtil.getClassName(e) + "]\n";
        } else {
            dejaVu[e] = e;
            // compute # of frames in common between this and enclosing trace
            var ourTrace :Array = getStackTraceElements(e);
            var m :int = ourTrace.length - 1;
            var n :int = enclosingTrace.length - 1;
            while (m >= 0 && n >= 0 && ourTrace[m] == enclosingTrace[n]) {
                m--; n--;
            }
            var framesInCommon :int = ourTrace.length - 1 - m;

            // Print our stack trace
            out += CAUSE_CAPTION + ClassUtil.getClassName(e) + ' "' + e.message + '"\n';
            for (var ii :int = 0; ii <= m; ++ii) {
                out += ourTrace[ii] + "\n";
            }
            if (framesInCommon != 0) {
                out += "\t... " + framesInCommon + " more\n";
            }

            // print cause, if any
            if (e is Throwable && Throwable(e).cause != null) {
                out += printEnclosedStackTrace(Throwable(e).cause, ourTrace, dejaVu);
            }
        }

        return out;
    }

    protected static function getStackTraceElements (e :Error) :Array {
        var theTrace :String = (e is Throwable ?
            Throwable(e)._originalGetStackTrace.apply(e) : e.getStackTrace());
        if (theTrace == null) {
            return [];
        } else {
            var lines :Array = theTrace.split("\n");
            return (lines.length > 1 ? lines.slice(1) : []);
        }
    }

    private var _cause :Error;
    private var _originalGetStackTrace :Function;

    protected static const CAUSE_CAPTION :String = "Caused by: ";
}
}
