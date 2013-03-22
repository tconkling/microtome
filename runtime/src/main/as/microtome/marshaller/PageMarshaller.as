//
// microtome

package microtome.marshaller {

import microtome.MutablePage;
import microtome.Page;
import microtome.core.DataReader;
import microtome.core.MicrotomeMgr;
import microtome.core.TypeInfo;
import microtome.error.ResolveRefError;
import microtome.prop.ObjectProp;
import microtome.prop.Prop;
import microtome.util.ClassUtil;

public class PageMarshaller extends ObjectMarshallerBase
{
    override public function get valueClass () :Class {
        return Page;
    }

    override public function get handlesSubclasses () :Boolean {
        return true;
    }

    override public function readObject (mgr :MicrotomeMgr, reader :DataReader, type :TypeInfo) :* {
        return mgr.loadPage(reader, type.clazz);
    }

    override public function resolveRefs (mgr :MicrotomeMgr, obj :*, type :TypeInfo) :void {
        const page :MutablePage = MutablePage(obj);
        for each (var prop :Prop in page.props) {
            var objectProp :ObjectProp = (prop as ObjectProp);
            if (objectProp != null && objectProp.value != null) {
                try {
                    var marshaller :ObjectMarshaller = mgr.requireObjectMarshallerForClass(
                        objectProp.valueType.clazz);
                    marshaller.resolveRefs(mgr, objectProp.value, objectProp.valueType);
                } catch (rre :ResolveRefError) {
                    throw rre;
                } catch (e :Error) {
                    throw new ResolveRefError("Failed to resolve ref",
                        "page", page.fullyQualifiedName, "err", e.message);
                }
            }
        }
    }

    override public function cloneObject (mgr :MicrotomeMgr, data :Object, type :TypeInfo) :Object {
        const page :MutablePage = MutablePage(data);
        const clazz :Class = ClassUtil.getClass(page);
        const clone :MutablePage = new clazz(page.name);

        for (var ii :int = 0; ii < page.props.length; ++ii) {
            var prop :Prop = page.props[ii];
            var cloneProp :Prop = clone.props[ii];
            var marshaller :DataMarshaller = (prop is ObjectProp ?
                mgr.requireObjectMarshallerForClass(prop.valueType.clazz) :
                mgr.primitiveMarshaller);
            cloneProp.value = (marshaller.cloneData(mgr, prop.value, prop.valueType));
        }

        return clone;
    }
}
}
