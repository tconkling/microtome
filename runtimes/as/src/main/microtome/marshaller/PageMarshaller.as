//
// microtome

package microtome.marshaller {

import microtome.MutablePage;
import microtome.Page;
import microtome.core.DataReader;
import microtome.core.MicrotomeMgr;
import microtome.core.TypeInfo;
import microtome.core.WritableObject;
import microtome.error.ResolveRefError;
import microtome.prop.ObjectProp;
import microtome.prop.Prop;
import microtome.util.ClassUtil;

public class PageMarshaller extends ObjectMarshaller
{
    public function PageMarshaller () {
        super(false);
    }

    override public function get valueClass () :Class {
        return Page;
    }

    override public function get handlesSubclasses () :Boolean {
        return true;
    }

    override public function readValue (mgr :MicrotomeMgr, reader :DataReader, name :String, type :TypeInfo) :* {
        return mgr.loadPage(reader, type.clazz);
    }

    override public function writeValue (mgr :MicrotomeMgr, writer :WritableObject, obj :*, name :String, type :TypeInfo) :void {
        mgr.writePage(writer, MutablePage(obj));
    }

    override public function resolveRefs (mgr :MicrotomeMgr, obj :*, type :TypeInfo) :void {
        const page :MutablePage = MutablePage(obj);
        for each (var prop :Prop in page.props) {
            var objectProp :ObjectProp = (prop as ObjectProp);
            if (objectProp != null && objectProp.value != null) {
                try {
                    var marshaller :DataMarshaller = mgr.requireDataMarshaller(
                        objectProp.valueType.clazz);
                    marshaller.resolveRefs(mgr, objectProp.value, objectProp.valueType);
                } catch (rre :ResolveRefError) {
                    throw rre;
                } catch (e :Error) {
                    throw new ResolveRefError("Failed to resolve ref",
                        "page", page.qualifiedName).initCause(e);
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
            var marshaller :DataMarshaller = mgr.requireDataMarshaller(prop.valueType.clazz);
            cloneProp.value = (marshaller.cloneData(mgr, prop.value, prop.valueType));
        }

        return clone;
    }
}
}
