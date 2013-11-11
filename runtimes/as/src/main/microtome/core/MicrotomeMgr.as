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
import microtome.marshaller.BoolMarshaller;
import microtome.marshaller.DataMarshaller;
import microtome.marshaller.IntMarshaller;
import microtome.marshaller.ListMarshaller;
import microtome.marshaller.NumberMarshaller;
import microtome.marshaller.PageMarshaller;
import microtome.marshaller.PageRefMarshaller;
import microtome.marshaller.StringMarshaller;
import microtome.marshaller.TomeMarshaller;
import microtome.prop.Prop;
import microtome.util.ClassUtil;
import microtome.util.Util;

public final class MicrotomeMgr implements MicrotomeCtx
{
    public function MicrotomeMgr () {
        registerDataMarshaller(new BoolMarshaller());
        registerDataMarshaller(new IntMarshaller());
        registerDataMarshaller(new NumberMarshaller());
        registerDataMarshaller(new ListMarshaller());
        registerDataMarshaller(new PageMarshaller());
        registerDataMarshaller(new PageRefMarshaller());
        registerDataMarshaller(new StringMarshaller());
        registerDataMarshaller(new TomeMarshaller());
    }

    public final function get library () :Library {
        return _loadTask.library;
    }

    public function registerPageClasses (classes :Vector.<Class>) :void {
        for each (var clazz :Class in classes) {
            if (!ClassUtil.isAssignableAs(MutablePage, clazz)) {
                throw new MicrotomeError("Class must extend " + ClassUtil.getClassName(MutablePage),
                    "pageClass", ClassUtil.getClassName(clazz));
            }

            _pageClasses[Util.pageTypeName(clazz)] = clazz;
        }
    }

    public function registerDataMarshaller (marshaller :DataMarshaller) :void {
        _dataMarshallers[marshaller.valueClass] = marshaller;
    }

    public function requireDataMarshaller (clazz :Class) :DataMarshaller {
        var marshaller :DataMarshaller = _dataMarshallers[clazz];
        if (marshaller == null) {
            // if we can't find an exact match, see if we have a handler for a superclass that
            // can take subclasses
            for each (var candidate :DataMarshaller in _dataMarshallers) {
                if (candidate.handlesSubclasses && ClassUtil.isAssignableAs(candidate.valueClass, clazz)) {
                    _dataMarshallers[clazz] = candidate;
                    marshaller = candidate;
                    break;
                }
            }
        }

        if (marshaller == null) {
            throw new MicrotomeError("No DataMarshaller for '" + ClassUtil.getClassName(clazz) + "'");
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
            throw new MicrotomeError("Load already in progress");
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
            var foundTemplate :Boolean = true;
            while (foundTemplate) {
                foundTemplate = false;
                for (var ii :int = 0; ii < _loadTask.pendingTemplatedPages.length; ++ii) {
                    var tPage :TemplatedPage = _loadTask.pendingTemplatedPages[ii];
                    var tmpl :MutablePage = _loadTask.library.getItemWithQualifiedName(tPage.templateName);
                    if (tmpl != null && !_loadTask.isPendingTemplatedPage(tmpl)) {
                        loadPageProps(tPage.page, tPage.reader, tmpl);
                        _loadTask.pendingTemplatedPages.splice(ii--, 1);
                        foundTemplate = true;
                        break;
                    }
                }
            }

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

    public function write (item :LibraryItem, writer :WritableObject) :void {
        const itemWriter :WritableObject = writer.addChild(item.name);
        if (item is MutablePage) {
            writePage(itemWriter, MutablePage(item));
        } else if (item is MutableTome) {
            writeTome(itemWriter, MutableTome(item));
        } else {
            throw new MicrotomeError("Unrecognized LibraryItem", "item", item);
        }
    }

    public function writePage (writer :WritableObject, page :MutablePage) :void {
        writer.writeString(Defs.PAGE_TYPE_ATTR, Util.pageTypeName(ClassUtil.getClass(page)));

        // TODO: template suppport...
        for each (var prop :Prop in page.props) {
            if (prop.value === null) {
                continue;
            }
            var marshaller :DataMarshaller = requireDataMarshaller(prop.valueType.clazz);
            var childWriter :WritableObject =
                (marshaller.isSimple ? writer : writer.addChild(prop.name));
            marshaller.writeValue(this, childWriter, prop.value, prop.name, prop.valueType);
        }
    }

    public function writeTome (writer :WritableObject, tome :MutableTome) :void {
        writer.writeString(Defs.TOME_TYPE_ATTR, Util.pageTypeName(tome.pageClass));
        for each (var page :MutablePage in tome.children.sortOn("name")) {
            writePage(writer.addChild(page.name), page);
        }
    }

    public function clone (item :LibraryItem) :* {
        const clazz :Class = ClassUtil.getClass(item);
        const marshaller :DataMarshaller = requireDataMarshaller(clazz);
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
                throw new LoadError(reader.data, "Error loading prop", "name", prop.name)
                    .initCause(err);
            }
        }
    }

    protected function loadPageProp (page :Page, prop :Prop, tProp :Prop, pageReader :DataReader) :void {
        // 1. Read the value from the DataReader, if it exists
        // 2. Else, copy the value from the template, if it exists
        // 3. Else, read the value from its 'default' annotation, if it exists
        // 3. Else, set the value to null if it's nullable
        // 4. Else, fail.

        const name :String = prop.name;
        const marshaller :DataMarshaller = requireDataMarshaller(prop.valueType.clazz);

        const canRead :Boolean =
            (marshaller.isSimple ? pageReader.hasValue(name) : pageReader.hasChild(name));
        const useTemplate :Boolean = !canRead && (tProp != null);

        if (canRead) {
            const reader :DataReader =
                (marshaller.isSimple ? pageReader : pageReader.requireChild(name));
            prop.value = marshaller.readValue(this, reader, name, prop.valueType);
            marshaller.validateProp(prop);
        } else if (useTemplate) {
            prop.value = tProp.value;
        } else if (prop.hasDefault) {
            prop.value = marshaller.readDefault(this, prop.valueType, prop.annotation(Defs.DEFAULT_ANNOTATION));
        } else if (prop.nullable) {
            prop.value = null;
        } else {
            throw new LoadError(pageReader.data, "Missing required value or child", "name", name);
        }
    }

    protected function loadLibraryItem (reader :DataReader) :LibraryItem {
        // a tome or a page
        if (reader.hasValue(Defs.TOME_TYPE_ATTR)) {
            // it's a tome!
            return loadTome(reader, requirePageClass(reader.requireString(Defs.TOME_TYPE_ATTR)));
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
                var marshaller :DataMarshaller = requireDataMarshaller(ClassUtil.getClass(item));
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
            if (task.library == item.library) {
                task.library.removeItem(item);
            }
        }
        task.state = LoadTask.ABORTED;
    }

    protected var _pageClasses :Dictionary = new Dictionary();  // <String, Class>
    protected var _dataMarshallers :Dictionary = new Dictionary(); // <Class, DataMarshaller>

    protected var _loadTask :LoadTask;
}
}
