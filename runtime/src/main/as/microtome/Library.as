//
// microtome

package microtome {

import flash.utils.Dictionary;
import flash.utils.Proxy;
import flash.utils.flash_proxy;

import microtome.marshaller.ListMarshaller;
import microtome.marshaller.PageMarshaller;
import microtome.marshaller.PageRefMarshaller;
import microtome.marshaller.StringMarshaller;
import microtome.marshaller.TomeMarshaller;

public dynamic class Library extends Proxy
{
    public var primitiveMarshaller :PrimitiveMarshaller = new DefaultPrimitiveMarshaller();

    public function Library () {
        registerObjectMarshaller(new ListMarshaller());
        registerObjectMarshaller(new PageMarshaller());
        registerObjectMarshaller(new PageRefMarshaller());
        registerObjectMarshaller(new StringMarshaller());
        registerObjectMarshaller(new TomeMarshaller());
    }

    flash_proxy override function getProperty (name :*): * {
        return _items[name];
    }

    flash_proxy override function hasProperty (name :*) :Boolean {
        return (name in _items);
    }

    flash_proxy override function setProperty (name :*, value :*) :void {
        throw new Error("Library items cannot be directly added to the Library");
    }

    public function loadData (dataElements :Array) :void {
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
                throw new LoadError("Missing template '" + missing.templateName + "'",
                    missing.data);
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

    public function registerPageClasses (...classes) :void {
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
            throw new Error("Missing required page [name='" + qualifiedName + "']");
        } else if (!(page is pageClass)) {
            throw new Error("Wrong type for required page [name='" + qualifiedName +
                "', expectedType=" + ClassUtil.getClassName(pageClass) +
                ", actualType=" + ClassUtil.getClassName(page) + "]");
        }
        return page;
    }

    public function loadTome (tomeData :DataElement, pageClass :Class) :MutableTome {
        var name :String = tomeData.name;
        if (!Util.validLibraryItemName(name)) {
            throw new LoadError("Tome name '" + name + "' is invalid", tomeData);
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
            throw new LoadError("Page name '" + name + "' is invalid", pageData);
        }

        var reader :DataReader = DataReader.withData(pageData);
        var typename :String = reader.requireAttribute(TYPE_ATTR);
        var pageClass :Class = requirePageClass(typename, superclass);

        var page :Page = new pageClass();
        page.setName(name);

        if (reader.hasAttribute(TEMPLATE_ATTR)) {
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
            throw new LoadError("Incompatible template [pageName='" + page.name +
                "', pageClass=" + ClassUtil.getClassName(page) +
                ", templateName='" + tmpl.name +
                "', templateClass=" + ClassUtil.getClassName(tmpl), pageData);
        }

        for each (var prop :Prop in page.props) {
            // if we have a template, get its corresponding template
            var tProp :Prop = null;
            if (tmpl != null) {
                tProp = Util.getProp(tmpl, prop.name);
                if (tProp == null) {
                    throw new LoadError("Template '" + tmpl.name + "' missing prop '"
                        + prop.name + "'", pageData);
                }
            }

            // load the prop
            try {
                loadPageProp(prop, tProp, pageData);
            } catch (loadErr :LoadError) {
                throw loadErr;
            } catch (err :Error) {
                throw new LoadError("Error loading prop '" + prop.name + "': " + err.message,
                    pageData);
            }
        }
    }

    protected function loadPageProp (prop :Prop, tProp :Prop, pageData :DataElement) :void {
        var objectProp :ObjectProp = prop as ObjectProp;
        var isPrimitive :Boolean = (objectProp == null);

        var pageReader :DataReader = DataReader.withData(pageData);

        if (isPrimitive) {
            // handle primitive props (read from attributes)
            var useTemplate :Boolean =
                (tProp != null && !pageReader.hasAttribute(prop.name));

            if (prop is IntProp) {
                var intProp :IntProp = IntProp(prop);
                if (useTemplate) {
                    intProp.value = IntProp(tProp).value;
                } else {
                    intProp.value = pageReader.requireIntAttribute(prop.name);
                    this.primitiveMarshaller.validateInt(intProp);
                }
            } else if (prop is BoolProp) {
                var boolProp :BoolProp = BoolProp(prop);
                if (useTemplate) {
                    boolProp.value = BoolProp(tProp).value;
                } else {
                    boolProp.value = pageReader.requireBoolAttribute(prop.name);
                    this.primitiveMarshaller.validateBool(boolProp);
                }
            } else if (prop is NumberProp) {
                var numProp :NumberProp = NumberProp(prop);
                if (useTemplate) {
                    numProp.value = NumberProp(tProp).value;
                } else {
                    numProp.value = pageReader.requireNumberAttribute(prop.name);
                    this.primitiveMarshaller.validateNumber(numProp);
                }
            } else {
                throw new LoadError("Unrecognized primitive prop [name='" + prop.name +
                    "', class=" + ClassUtil.getClassName(prop) + "]", pageData);
            }

        } else {
            // handle object props (read from child elements)
            var tObjectProp :ObjectProp = (tProp != null ? ObjectProp(tProp) : null);
            var propData :DataElement = pageReader.childNamed(prop.name);

            if (propData == null) {
                // Handle null object
                if (tObjectProp != null) {
                    // inherit from template
                    objectProp.value = tObjectProp.value;
                } else if (objectProp.nullable) {
                    // object is nullable
                    objectProp.value = null;
                } else {
                    throw new LoadError("Missing required child [name='" + prop.name + "']",
                        pageData);
                }

            } else {
                // load normally
                var marshaller :ObjectMarshaller =
                    requireObjectMarshallerForClass(objectProp.valueType.clazz);
                objectProp.value = marshaller.loadObject(propData, objectProp.valueType, this);
                marshaller.validatePropValue(objectProp);
            }
        }
    }

    protected function loadLibraryItem (data :DataElement) :LibraryItem {
        // a tome or a page
        var reader :DataReader = DataReader.withData(data);
        var typeName :String = reader.requireAttribute(TYPE_ATTR);
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
            throw new LoadError("No page class for name '" + name + "'");
        } else if (requiredSuperclass != null && !ClassUtil.isAssignableAs(requiredSuperclass, clazz)) {
            throw new LoadError("Unexpected page class [required=" +
                ClassUtil.getClassName(requiredSuperclass) + ", got=" + ClassUtil.getClassName(clazz));
        }
        return clazz;
    }

    protected function addLoadedItems (task :LoadTask) :void {
        if (task.state != LoadTask.LOADING) {
            throw new Error("task.state != LOADING");
        }

        for each (var item :LibraryItem in task.libraryItems) {
            if (_items[item.name] != null) {
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
                marshaller.resolveRefs(item, item.type, this);
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

    protected static const TYPE_ATTR :String = "type";
}
}

const TEMPLATE_ATTR :String = "template";

import microtome.DataElement;
import microtome.DataReader;
import microtome.Page;

class TemplatedPage {
    public function TemplatedPage (page :Page, data :DataElement) {
        _page = page;
        _data = DataReader.withData(data);
    }

    public function get page () :Page {
        return _page;
    }

    public function get data () :DataReader {
        return _data;
    }

    public function get templateName () :String {
        return _data.requireAttribute(TEMPLATE_ATTR);
    }

    protected var _page :Page;
    protected var _data :DataReader;
}
