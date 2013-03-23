//
// microtome

package microtome.prop {
import microtome.MutablePage;
import microtome.core.DataReader;
import microtome.core.Defs;

public class PrimitiveProp extends Prop
{
    public function PrimitiveProp (page :MutablePage, spec :PropSpec) {
        super(page, spec);
    }

    public final function load (reader :DataReader, templateProp :Prop) :void {
        const canRead :Boolean = reader.hasValue(this.name);
        const useTemplate :Boolean = (!canRead && templateProp != null);
        const useDefault :Boolean =
            (!canRead && !useTemplate && hasAnnotation(Defs.DEFAULT_ANNOTATION));

        if (useDefault) {
            this.value = this.defaultValue;
        } else if (useTemplate) {
            this.value = templateProp.value;
        } else {
            this.value = readValue(reader);
        }
    }

    protected function readValue (reader :DataReader) :* {
        throw new Error("abstract");
    }

    protected function get defaultValue () :* {
        throw new Error("abstract");
    }
}
}
