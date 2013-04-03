//
// microtome

package microtome.core {

import flash.utils.Dictionary;

import microtome.Library;
import microtome.MicrotomeCtx;
import microtome.MutablePage;
import microtome.MutableTome;
import microtome.Page;
import microtome.error.LoadError;
import microtome.error.MicrotomeError;
import microtome.marshaller.ListMarshaller;
import microtome.marshaller.ObjectMarshaller;
import microtome.marshaller.PageMarshaller;
import microtome.marshaller.PageRefMarshaller;
import microtome.marshaller.PrimitiveMarshaller;
import microtome.marshaller.StringMarshaller;
import microtome.marshaller.TomeMarshaller;
import microtome.prop.ObjectProp;
import microtome.prop.PrimitiveProp;
import microtome.prop.Prop;
import microtome.util.ClassUtil;
import microtome.util.Util;

public final class MicrotomeMgr
    implements MicrotomeCtx
{
    public function MicrotomeMgr () {
        registerObjectMarshaller(new ListMarshaller());
        registerObjectMarshaller(new PageMarshaller());
        registerObjectMarshaller(new PageRefMarshaller());
        registerObjectMarshaller(new StringMarshaller());
        registerObjectMarshaller(new TomeMarshaller());
    }

    public final function get library () :Library {
        return _loadTask.library;
    }

    public function registerPrimitiveMarshaller (val :PrimitiveMarshaller) :void {
        _primitiveMarshaller = val;
    }

    public function get primitiveMarshaller () :PrimitiveMarshaller {
        return _primitiveMarshaller;
    }

    public function registerPageClasses (classes :Vector.<Class>) :void {
        for each (var clazz :Class in classes) {
            if (!ClassUtil.isAssignableAs(MutablePage, clazz)) {
                throw new Error("Class must extend " + ClassUtil.getClassName(MutablePage) +
                    " [pageClass=" + ClassUtil.getClassName(clazz) + "]");
            }

            _pageClasses[Util.pageTypeName(clazz)] = clazz;
        }
    }

    public function registerObjectMarshaller (marshaller :ObjectMarshaller) :void {
        _objectMarshallers[marshaller.valueClass] = marshaller;
    }

    public function requireObjectMarshallerForClass (clazz :Class) :ObjectMarshaller {
        var marshaller :ObjectMarshaller = _objectMarshallers[clazz];
        if (marshaller == null) {
            // if we can't find an exact match, see if we have a handler for a superclass that
            // can take subclasses
            for each (var candidate :ObjectMarshaller in _objectMarshallers) {
                if (candidate.handlesSubclasses && ClassUtil.isAssignableAs(candidate.valueClass, clazz)) {
                    _objectMarshallers[clazz] = candidate;
                    marshaller = candidate;
                    break;
                }
            }
        }

        if (marshaller == null) {
            throw new Error("No ObjectMarshaller for '" + ClassUtil.getClassName(clazz) + "'");
        }

        return marshaller;
    }

    public function getPageClass (name :String) :Class {
        return _pageClasses[name];
    }

    public function requirePageClass (name :String, requiredSuperclass :Class = null) :Class {
        var clazz :Class = getPageClass(name);
        if (clazz == null) {
            throw new LoadError(null, "No such page class", "name", name);
        } else if (requiredSuperclass != null && !ClassUtil.isAssignableAs(requiredSuperclass, clazz)) {
            throw new LoadError(null, "Unexpected page class",
                "required", ClassUtil.getClassName(requiredSuperclass),
                "got", ClassUtil.getClassName(clazz));
        }
        return clazz;
    }

    public function load (library :Library, dataElements :Vector.<ReadableObject>) :void {
        if (_loadTask != null) {
            throw new Error("Load already in progress");
        }
        _loadTask = new LoadTask(library);

        try {
            for each (var elt :ReadableObject in dataElements) {
                for each (var itemReader :DataReader in new DataReader(elt).children) {
                    _loadTask.addItem(loadLibraryItem(itemReader));
                }
            }

            addLoadedItems(_loadTask);

            // Resolve all templated items:
            // Iterate through the array as many times as it takes to resolve all template-dependent
            // pages (some templates may themselves have templates in the pendingTemplatedPages).
            // _pendingTemplatedPages can have items added to it during this process.
            var foundTemplate :Boolean;
            do {
                foundTemplate = false;
                for (var ii :int = 0; ii < _loadTask.pendingTemplatedPages.length; ++ii) {
                    var tPage :TemplatedPage = _loadTask.pendingTemplatedPages[ii];
                    var tmpl :MutablePage = _loadTask.library.pageWithQualifiedName(tPage.templateName);
                    if (tmpl == null) {
                        continue;
                    }
                    loadPageProps(tPage.page, tPage.reader, tmpl);
                    _loadTask.pendingTemplatedPages.splice(ii--, 1);
                    foundTemplate = true;
                }
            } while (foundTemplate);

            // throw an error if we're missing a template
            if (_loadTask.pendingTemplatedPages.length > 0) {
                const missing :TemplatedPage = _loadTask.pendingTemplatedPages[0];
                throw new LoadError(missing.reader.data, "Missing template",
                    "name", missing.templateName);
            }

            // finalize the load, which resolves all PageRefs
            finalizeLoadedItems(_loadTask);

        } catch (e :Error) {
            abortLoad(_loadTask);
            throw e;

        } finally {
            _loadTask = null;
        }
    }

    public function loadTome (reader :DataReader, pageClass :Class) :MutableTome {
        const name :String = reader.name;
        if (!Util.validLibraryItemName(name)) {
            throw new LoadError(reader.data, "Invalid tome name", "name", name);
        }

        const tome :MutableTome = new MutableTome(name, pageClass);
        for each (var pageReader :DataReader in reader.children) {
            tome.addPage(loadPage(pageReader, pageClass));
        }
        return tome;
    }

    public function loadPage (reader :DataReader, requiredSuperclass :Class = null) :MutablePage {
        const name :String = reader.name;
        if (!Util.validLibraryItemName(name)) {
            throw new LoadError(reader.data, "Invalid page name", "name", name);
        }

        const typename :String = reader.requireString(Defs.PAGE_TYPE_ATTR);
        const pageClass :Class = requirePageClass(typename, requiredSuperclass);

        const page :MutablePage = new pageClass(name);

        if (reader.hasValue(Defs.TEMPLATE_ATTR)) {
            // if this page has a template, we defer its loading until the end
            _loadTask.pendingTemplatedPages.push(new TemplatedPage(page, reader));
        } else {
            loadPageProps(page, reader);
        }

        return page;
    }

    public function save (item :LibraryItem, writer :WritableObject) :void {
        const itemWriter :WritableObject = writer.addChild(item.name);
        if (item is MutablePage) {
            savePage(itemWriter, MutablePage(item));
        } else if (item is MutableTome) {
            saveTome(itemWriter, MutableTome(item));
        } else {
            throw new MicrotomeError("Unrecognized LibraryItem", "item", item);
        }
    }

    public function savePage (writer :WritableObject, page :MutablePage) :void {
        writer.writeString(Defs.PAGE_TYPE_ATTR, Util.pageTypeName(ClassUtil.getClass(page)));

        // TODO: template suppport...
        for each (var prop :Prop in page.props) {
            if (prop is PrimitiveProp) {
                PrimitiveProp(prop).writeValue(writer);
            } else {
                var objectProp :ObjectProp = ObjectProp(prop);
                if (objectProp.value != null) {
                    var marshaller :ObjectMarshaller =
                        requireObjectMarshallerForClass(objectProp.valueType.clazz);
                    marshaller.writeObject(this, writer.addChild(prop.name), objectProp.value,
                        objectProp.valueType);
                }
            }
        }
    }

    public function saveTome (writer :WritableObject, tome :MutableTome) :void {
        writer.writeString(Defs.PAGE_TYPE_ATTR, Util.pageTypeName(tome.pageClass));
        writer.writeBool(Defs.IS_TOME_ATTR, true);
        for each (var page :MutablePage in tome.getAllPages().sortOn("name")) {
            savePage(writer.addChild(page.name), page);
        }
    }

    public function clone (item :LibraryItem) :* {
        const clazz :Class = ClassUtil.getClass(item);
        const marshaller :ObjectMarshaller = requireObjectMarshallerForClass(clazz);
        return marshaller.cloneData(this, item, item.typeInfo);
    }

    protected function loadPageProps (page :MutablePage, reader :DataReader, tmpl :MutablePage = null) :void {
        // template's class must be equal to (or a subclass of) page's class
        if (tmpl != null && !(tmpl is ClassUtil.getClass(page))) {
            throw new LoadError(reader.data, "Incompatible template", "pageName", page.name,
                "pageClass", ClassUtil.getClassName(page), "templateName", tmpl.name,
                "templateClass", ClassUtil.getClassName(tmpl));
        }

        for each (var prop :Prop in page.props) {
            // if we have a template, get its corresponding template
            var tProp :Prop = null;
            if (tmpl != null) {
                tProp = Util.getProp(tmpl, prop.name);
                if (tProp == null) {
                    throw new LoadError(reader.data, "Missing prop in template",
                        "template", tmpl.name, "prop", prop.name);
                }
            }

            // load the prop
            try {
                loadPageProp(page, prop, tProp, reader);
            } catch (loadErr :LoadError) {
                throw loadErr;
            } catch (err :Error) {
                throw new LoadError(reader.data, "Error loading prop", "name", prop.name, err);
            }
        }
    }

    protected function loadPageProp (page :Page, prop :Prop, tProp :Prop, pageReader :DataReader) :void {
        if (prop is PrimitiveProp) {
            PrimitiveProp(prop).load(pageReader, tProp);
            _primitiveMarshaller.validateProp(prop);

        } else {
            // Handle object props:
            // 1. Read the value from the DataReader, if it exists
            // 2. Else, copy the value from the template, if it exists
            // 3. Else, set the value to null if it's nullable
            // 4. Else, fail.

            const objectProp :ObjectProp = prop as ObjectProp;
            const canRead :Boolean = pageReader.hasChild(prop.name);
            const useTemplate :Boolean = !canRead && (tProp != null);

            if (canRead) {
                const marshaller :ObjectMarshaller =
                    requireObjectMarshallerForClass(objectProp.valueType.clazz);
                const propReader :DataReader = pageReader.getChild(prop.name);
                objectProp.value = marshaller.readObject(this, propReader, objectProp.valueType);
                marshaller.validateProp(objectProp);

            } else if (useTemplate) {
                objectProp.value = ObjectProp(tProp).value;
            } else if (objectProp.nullable) {
                objectProp.value = null;
            } else {
                throw new LoadError(pageReader.data, "Missing required child", "name", prop.name);
            }
        }
    }

    protected function loadLibraryItem (reader :DataReader) :LibraryItem {
        // a tome or a page
        const pageType :String = reader.requireString(Defs.PAGE_TYPE_ATTR);
        if (reader.getBool(Defs.IS_TOME_ATTR, false)) {
            // it's a tome!
            return loadTome(reader, requirePageClass(pageType));
        } else {
            // it's a page!
            return loadPage(reader);
        }
    }

    protected function addLoadedItems (task :LoadTask) :void {
        if (task.state != LoadTask.LOADING) {
            throw new MicrotomeError("task.state != LOADING");
        }

        for each (var item :LibraryItem in task.libraryItems) {
            if (task.library.hasItem(item.name)) {
                task.state = LoadTask.ABORTED;
                throw new LoadError(null, "An item named '" + item.name + "' is already loaded");
            }
        }

        for each (item in task.libraryItems) {
            task.library.addItem(item);
        }

        task.state = LoadTask.ADDED_ITEMS;
    }

    protected function finalizeLoadedItems (task :LoadTask) :void {
        if (task.state != LoadTask.ADDED_ITEMS) {
            throw new MicrotomeError("task.state != ADDED_ITEMS");
        }

        try {
            for each (var item :LibraryItem in task.libraryItems) {
                var marshaller :ObjectMarshaller =
                    requireObjectMarshallerForClass(ClassUtil.getClass(item));
                marshaller.resolveRefs(this, item, item.typeInfo);
            }
        } catch (e :Error) {
            abortLoad(task);
            throw e;
        }

        task.state = LoadTask.FINALIZED;
    }

    protected function abortLoad (task :LoadTask) :void {
        if (task.state == LoadTask.ABORTED) {
            return;
        }

        for each (var item :LibraryItem in task.libraryItems) {
            task.library.removeItem(item);
        }
        task.state = LoadTask.ABORTED;
    }

    protected var _pageClasses :Dictionary = new Dictionary();  // <String, Class>
    protected var _objectMarshallers :Dictionary = new Dictionary(); // <Class, ObjectMarshaller>
    protected var _primitiveMarshaller :PrimitiveMarshaller = new PrimitiveMarshaller();

    protected var _loadTask :LoadTask;
}
}
