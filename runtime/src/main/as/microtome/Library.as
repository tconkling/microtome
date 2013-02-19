//
// microtome

package microtome {

import flash.utils.Dictionary;

import microtome.core.DataElement;
import microtome.core.DataReader;
import microtome.core.Defs;
import microtome.core.LibraryItem;
import microtome.core.LoadTask;
import microtome.core.TemplatedPage;
import microtome.error.LoadError;
import microtome.error.RequirePageError;
import microtome.error.ResolveRefError;
import microtome.marshaller.DefaultPrimitiveMarshaller;
import microtome.marshaller.ListMarshaller;
import microtome.marshaller.ObjectMarshaller;
import microtome.marshaller.PageMarshaller;
import microtome.marshaller.PageRefMarshaller;
import microtome.marshaller.PrimitiveMarshaller;
import microtome.marshaller.StringMarshaller;
import microtome.marshaller.TomeMarshaller;
import microtome.prop.BoolProp;
import microtome.prop.IntProp;
import microtome.prop.NumberProp;
import microtome.prop.ObjectProp;
import microtome.prop.Prop;
import microtome.util.ClassUtil;
import microtome.util.Util;

public class Library
{
    public var primitiveMarshaller :PrimitiveMarshaller = new DefaultPrimitiveMarshaller();

    public function Library () {
        registerObjectMarshaller(new ListMarshaller());
        registerObjectMarshaller(new PageMarshaller());
        registerObjectMarshaller(new PageRefMarshaller());
        registerObjectMarshaller(new StringMarshaller());
        registerObjectMarshaller(new TomeMarshaller());
    }

    public function getItem (name :String) :* {
        return _items[name];
    }

    public function hasItem (name :String) :Boolean {
        return (name in _items);
    }

    public function loadData (dataElements :Vector.<DataElement>) :void {
        if (_loadTask != null) {
            throw new Error("Load already in progress");
        }
        _loadTask = new LoadTask();

        try {
            for each (var doc :DataElement in dataElements) {
                for each (var itemData :DataElement in DataReader.withData(doc).children) {
                    _loadTask.addItem(loadLibraryItem(itemData));
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
                    var tmpl :Page = pageWithQualifiedName(tPage.templateName);
                    if (tmpl == null) {
                        continue;
                    }
                    loadPageProps(tPage.page, tPage.data, tmpl);
                    _loadTask.pendingTemplatedPages.splice(ii--, 1);
                    foundTemplate = true;
                }
            } while (foundTemplate);

            // throw an error if we're missing a template
            if (_loadTask.pendingTemplatedPages.length > 0) {
                var missing :TemplatedPage = _loadTask.pendingTemplatedPages[0];
                throw new LoadError(missing.data, "Missing template", "name", missing.templateName);
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

    public function removeAllItems () :void {
        _items = new Dictionary();
    }

    public function registerPageClasses (classes :Vector.<Class>) :void {
        for each (var clazz :Class in classes) {
            if (!ClassUtil.isAssignableAs(Page, clazz)) {
                throw new Error("Class must implement " + ClassUtil.getClassName(Page) +
                    " [pageClass=" + ClassUtil.getClassName(clazz) + "]");
            }

            _pageClasses[ClassUtil.tinyClassName(clazz)] = clazz;
        }
    }

    public function registerObjectMarshaller (marshaller :ObjectMarshaller) :void {
        _objectMarshallers[marshaller.valueClass] = marshaller;
    }

    public function pageWithQualifiedName (qualifiedName :String) :Page {
        // A page's qualifiedName is a series of page and tome names, separated by dots
        // E.g. level1.baddies.big_boss

        var item :LibraryItem = null;
        for each (var name :String in qualifiedName.split(Defs.NAME_SEPARATOR)) {
            var child :* = (item != null ? item.childNamed(name) : _items[name]);
            if (!(child is LibraryItem)) {
                return null;
            }
            item = LibraryItem(child);
        }

        return (item as Page);
    }

    public function requirePageWithQualifiedName (qualifiedName :String, pageClass :Class) :Page {
        var page :Page = pageWithQualifiedName(qualifiedName);
        if (page == null) {
            throw new RequirePageError("No such page", "name", qualifiedName);
        } else if (!(page is pageClass)) {
            throw new RequirePageError("Wrong page type", "name", qualifiedName,
                "expectedType", ClassUtil.getClassName(pageClass),
                "actualType", ClassUtil.getClassName(page));
        }
        return page;
    }

    public function loadTome (tomeData :DataElement, pageClass :Class) :MutableTome {
        var name :String = tomeData.name;
        if (!Util.validLibraryItemName(name)) {
            throw new LoadError(tomeData, "Invalid tome name", "name", name);
        }

        var tome :MutableTome = new MutableTome(name, pageClass);
        for each (var pageData :DataElement in DataReader.withData(tomeData).children) {
            tome.addPage(loadPage(pageData, pageClass));
        }
        return tome;
    }

    public function loadPage (pageData :DataElement, superclass :Class = null) :Page {
        var name :String = pageData.name;
        if (!Util.validLibraryItemName(name)) {
            throw new LoadError(pageData, "Invalid page name", "name", name);
        }

        var reader :DataReader = DataReader.withData(pageData);
        var typename :String = reader.requireAttribute(Defs.TYPE_ANNOTATION);
        var pageClass :Class = requirePageClass(typename, superclass);

        var page :Page = new pageClass();
        page.setName(name);

        if (reader.hasAttribute(Defs.TEMPLATE_ANNOTATION)) {
            // if this page has a template, we defer its loading until the end
            _loadTask.pendingTemplatedPages.push(new TemplatedPage(page, pageData));
        } else {
            loadPageProps(page, reader);
        }

        return page;
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

    protected function loadPageProps (page :Page, pageData :DataElement, tmpl :Page = null) :void {
        // template's class must be equal to (or a subclass of) page's class
        if (tmpl != null && !(tmpl is ClassUtil.getClass(page))) {
            throw new LoadError(pageData, "Incompatible template", "pageName", page.name,
                "pageClass", ClassUtil.getClassName(page), "templateName", tmpl.name,
                "templateClass", ClassUtil.getClassName(tmpl));
        }

        for each (var prop :Prop in page.props) {
            // if we have a template, get its corresponding template
            var tProp :Prop = null;
            if (tmpl != null) {
                tProp = Util.getProp(tmpl, prop.name);
                if (tProp == null) {
                    throw new LoadError(pageData, "Missing prop in template",
                        "template", tmpl.name, "prop", prop.name);
                }
            }

            // load the prop
            try {
                loadPageProp(prop, tProp, pageData);
            } catch (loadErr :LoadError) {
                throw loadErr;
            } catch (err :Error) {
                throw new LoadError(pageData, "Error loading prop", "name", prop.name, err);
            }
        }
    }

    protected function loadPageProp (prop :Prop, tProp :Prop, pageData :DataElement) :void {
        var pageReader :DataReader = DataReader.withData(pageData);

        var objectProp :ObjectProp = prop as ObjectProp;

        const isPrimitive :Boolean = (objectProp == null);
        const canRead :Boolean =
            (isPrimitive ? pageReader.hasAttribute(prop.name) : pageReader.hasChild(prop.name));
        const useTemplate :Boolean = !canRead && (tProp != null);

        if (isPrimitive) {
            // Handle primitive props (read from attributes):
            // 1. Read the value from the DataReader, if it exists
            // 2. Else, copy the value from the template, if it exists
            // 3. Else, set the value to its default, if it has a default
            // 4. Else, fail.

            const useDefault :Boolean =
                !canRead && !useTemplate && prop.hasAnnotation(Defs.DEFAULT_ANNOTATION);

            if (prop is IntProp) {
                var intProp :IntProp = IntProp(prop);
                if (useDefault) {
                    intProp.value = prop.intAnnotation(Defs.DEFAULT_ANNOTATION, 0);
                } else if (useTemplate) {
                    intProp.value = IntProp(tProp).value;
                } else {
                    intProp.value = pageReader.requireIntAttribute(prop.name);
                    this.primitiveMarshaller.validateInt(intProp);
                }

            } else if (prop is BoolProp) {
                var boolProp :BoolProp = BoolProp(prop);
                if (useDefault) {
                    boolProp.value = prop.boolAnnotation(Defs.DEFAULT_ANNOTATION, false);
                } else if (useTemplate) {
                    boolProp.value = BoolProp(tProp).value;
                } else {
                    boolProp.value = pageReader.requireBoolAttribute(prop.name);
                    this.primitiveMarshaller.validateBool(boolProp);
                }

            } else if (prop is NumberProp) {
                var numProp :NumberProp = NumberProp(prop);
                if (useDefault) {
                    numProp.value = prop.numberAnnotation(Defs.DEFAULT_ANNOTATION, 0);
                } else if (useTemplate) {
                    numProp.value = NumberProp(tProp).value;
                } else {
                    numProp.value = pageReader.requireNumberAttribute(prop.name);
                    this.primitiveMarshaller.validateNumber(numProp);
                }

            } else {
                throw new LoadError(pageData, "Unrecognized primitive prop", "name", prop.name,
                    "class", ClassUtil.getClassName(prop));
            }

        } else {
            // Handle object props (read from child elements):
            // 1. Read the value from the DataReader, if it exists
            // 2. Else, copy the value from the template, if it exists
            // 3. Else, set the value to null if it's nullable
            // 4. Else, fail.

            if (canRead) {
                var marshaller :ObjectMarshaller =
                    requireObjectMarshallerForClass(objectProp.valueType.clazz);
                var propData :DataElement = pageReader.childNamed(prop.name);
                objectProp.value = marshaller.loadObject(propData, objectProp.valueType, this);
                marshaller.validatePropValue(objectProp);

            } else if (useTemplate) {
                objectProp.value = ObjectProp(tProp).value;
            } else if (objectProp.nullable) {
                objectProp.value = null;
            } else {
                throw new LoadError(pageData, "Missing required child", "name", prop.name);
            }
        }
    }

    protected function loadLibraryItem (data :DataElement) :LibraryItem {
        // a tome or a page
        var reader :DataReader = DataReader.withData(data);
        var typeName :String = reader.requireAttribute(Defs.TYPE_ANNOTATION);
        if (Util.startsWith(typeName, Defs.TOME_PREFIX)) {
            // it's a tome!
            typeName = typeName.substr(Defs.TOME_PREFIX.length);
            var pageClass :Class = requirePageClass(typeName);
            return loadTome(reader, pageClass);
        } else {
            // it's a page!
            return loadPage(reader);
        }
    }

    protected function getPageClass (name :String) :Class {
        return _pageClasses[name];
    }

    protected function requirePageClass (name :String, requiredSuperclass :Class = null) :Class {
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

    protected function addLoadedItems (task :LoadTask) :void {
        if (task.state != LoadTask.LOADING) {
            throw new Error("task.state != LOADING");
        }

        for each (var item :LibraryItem in task.libraryItems) {
            if (item.name in _items) {
                task.state = LoadTask.ABORTED;
                throw new Error("An item named '" + item.name + "' is already loaded");
            }
        }

        for each (item in task.libraryItems) {
            _items[item.name] = item;
        }

        task.state = LoadTask.ADDED_ITEMS;
    }

    protected function finalizeLoadedItems (task :LoadTask) :void {
        if (task.state != LoadTask.ADDED_ITEMS) {
            throw new Error("task.state != ADDED_ITEMS");
        }

        try {
            for each (var item :LibraryItem in task.libraryItems) {
                var marshaller :ObjectMarshaller =
                    requireObjectMarshallerForClass(ClassUtil.getClass(item));
                try {
                    marshaller.resolveRefs(item, item.type, this);
                } catch (e :Error) {
                    throw new ResolveRefError("Failed to resolve ref", "item", item.name,
                        "err", e.message);
                }
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
            delete _items[item.name];
        }
        task.state = LoadTask.ABORTED;
    }

    protected var _loadTask :LoadTask;

    protected var _items :Dictionary = new Dictionary();
    protected var _pageClasses :Dictionary = new Dictionary();  // <String, Class>
    protected var _objectMarshallers :Dictionary = new Dictionary(); // <Class, ObjectMarshaller>
}
}
