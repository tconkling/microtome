//
// microtome

package microtome.marshaller {

import microtome.MutableTome;
import microtome.Tome;
import microtome.core.DataReader;
import microtome.core.MicrotomeMgr;
import microtome.core.TypeInfo;
import microtome.core.WritableObject;
import microtome.error.ResolveRefError;
import microtome.prop.ObjectProp;
import microtome.prop.Prop;
import microtome.util.ClassUtil;

public class TomeMarshaller extends ObjectMarshaller
{
    public function TomeMarshaller () {
        super(false);
    }

    override public function get valueClass () :Class {
        return Tome;
    }

    override public function get handlesSubclasses () :Boolean {
        return true;
    }

    override public function readValue (mgr :MicrotomeMgr, reader :DataReader, name :String, type :TypeInfo) :* {
        return mgr.loadTome(reader, type.clazz);
    }

    override public function writeValue (mgr :MicrotomeMgr, writer :WritableObject, obj :*, name :String, type :TypeInfo) :void {
        mgr.writeTome(writer, MutableTome(obj));
    }

    override public function resolveRefs (mgr :MicrotomeMgr, obj :*, type :TypeInfo) :void {
        const tome :MutableTome = MutableTome(obj);

        // Non-tome props
        for each (var prop :Prop in tome.props) {
            var objectProp :ObjectProp = (prop as ObjectProp);
            if (objectProp != null && objectProp.value != null && !(objectProp.value is MutableTome)) {
                try {
                    var marshaller :DataMarshaller = mgr.requireDataMarshaller(
                        objectProp.valueType.clazz);
                    marshaller.resolveRefs(mgr, objectProp.value, objectProp.valueType);
                } catch (rre :ResolveRefError) {
                    throw rre;
                } catch (e :Error) {
                    throw new ResolveRefError("Failed to resolve ref",
                        "tome", tome.qualifiedName).initCause(e);
                }
            }
        }

        // Tomes
        tome.forEachTome(function (child :MutableTome) :void {
            var marshaller :DataMarshaller = mgr.requireDataMarshaller(child.typeInfo.clazz);
            marshaller.resolveRefs(mgr, child, child.typeInfo);
        });
    }

    override public function cloneObject (mgr :MicrotomeMgr, data :Object, type :TypeInfo) :Object {
        const tome :MutableTome = MutableTome(data);
        const clazz :Class = ClassUtil.getClass(tome);
        const clone :MutableTome = new clazz(tome.name);

        // non-tome props
        for (var ii :int = 0; ii < tome.props.length; ++ii) {
            var prop :Prop = tome.props[ii];
            if (prop.value is MutableTome) {
                continue;
            }
            var cloneProp :Prop = clone.props[ii];
            var marshaller :DataMarshaller = mgr.requireDataMarshaller(prop.valueType.clazz);
            cloneProp.value = (marshaller.cloneData(mgr, prop.value, prop.valueType));
        }

        // tomes
        tome.forEachTome(function (child :MutableTome) :void {
            var marshaller :DataMarshaller = mgr.requireDataMarshaller(child.typeInfo.clazz);
            clone.addTome(marshaller.cloneData(mgr, child, child.typeInfo));
        });

        return clone;
    }
}
}
