//
// microtome

package microtome.marshaller {

import microtome.Page;
import microtome.core.DataElement;
import microtome.core.LibraryManager;
import microtome.MutablePage;
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

    override public function loadObject (data :DataElement, type :TypeInfo, loader :LibraryManager) :* {
        return loader.loadPage(data, type.clazz);
    }

    override public function resolveRefs (obj :*, type :TypeInfo, mgr :LibraryManager) :void {
        var page :MutablePage = MutablePage(obj);
        for each (var prop :Prop in page.props) {
            var objectProp :ObjectProp = (prop as ObjectProp);
            if (objectProp != null && objectProp.value != null) {
                try {
                    var marshaller :ObjectMarshaller = mgr.requireObjectMarshallerForClass(
                        objectProp.valueType.clazz);
                    marshaller.resolveRefs(objectProp.value, objectProp.valueType, mgr);
                } catch (rre :ResolveRefError) {
                    throw rre;
                } catch (e :Error) {
                    throw new ResolveRefError("Failed to resolve ref",
                        "page", page.fullyQualifiedName, "err", e.message);
                }
            }
        }
    }

    override public function cloneObject (data :Object, mgr :LibraryManager) :Object {
        const page :MutablePage = MutablePage(data);
        const clazz :Class = ClassUtil.getClass(page);
        const clone :MutablePage = new clazz();

        for (var ii :int = 0; ii < page.props.length; ++ii) {
            var prop :Prop = page.props[ii];
            var cloneProp :Prop = clone.props[ii];
            var marshaller :DataMarshaller = (prop is ObjectProp ?
                mgr.requireObjectMarshallerForClass(prop.valueType.clazz) :
                mgr.primitiveMarshaller);
            cloneProp.value = (marshaller.cloneData(prop.value, mgr));
        }

        return clone;
    }
}
}
