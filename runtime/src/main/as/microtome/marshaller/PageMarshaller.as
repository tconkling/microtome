//
// microtome

package microtome.marshaller {

import microtome.LibraryLoader;
import microtome.MutablePage;
import microtome.Page;
import microtome.core.DataElement;
import microtome.core.LibraryItem;
import microtome.core.TypeInfo;
import microtome.error.ResolveRefError;
import microtome.prop.ObjectProp;
import microtome.prop.Prop;

public class PageMarshaller extends ObjectMarshallerBase
{
    override public function get valueClass () :Class {
        return Page;
    }

    override public function get handlesSubclasses () :Boolean {
        return true;
    }

    override public function loadObject (parent :LibraryItem, data :DataElement, type :TypeInfo, loader :LibraryLoader):* {
        return loader.loadPage(parent, data, type.clazz);
    }

    override public function resolveRefs (obj :*, type :TypeInfo, loader :LibraryLoader) :void {
        var page :MutablePage = MutablePage(obj);
        for each (var prop :Prop in page.props) {
            var objectProp :ObjectProp = (prop as ObjectProp);
            if (objectProp != null && objectProp.value != null) {
                try {
                    var propMarshaller :ObjectMarshaller =
                        loader.requireObjectMarshallerForClass(objectProp.valueType.clazz);
                    propMarshaller.resolveRefs(objectProp.value, objectProp.valueType, loader);
                } catch (rre :ResolveRefError) {
                    throw rre;
                } catch (e :Error) {
                    throw new ResolveRefError("Failed to resolve ref",
                        "page", page.fullyQualifiedName, "err", e.message);
                }
            }
        }
    }
}
}
