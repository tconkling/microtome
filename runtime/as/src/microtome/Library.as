//
// microtome

package microtome {

import flash.utils.Dictionary;

public class Library
{
    public var primitiveMarshaller :PrimitiveMarshaller = new DefaultPrimitiveMarshaller();

    public function Library () {
    }

    public function loadData (dataElements :Array) :void {
        if (_loadTask != null) {
            throw new Error("Load already in progress");
        }
        _loadTask = new LoadTask();

        try {
            for each (var doc :DataElement in dataElements) {
                for each (var itemData :DataElement in doc.children) {
                    _loadTask.addItem(loadLibraryItem(itemData));
                }

            }
        } catch (e :Error) {
            // TODO
        }
    }

    public function registerPageClasses (...classes) :void {
        for each (var clazz :Class in classes) {
            if (!(clazz is Page)) {
                throw new Error("Class must implement " + Util.getClassName(Page) +
                    " [pageClass=" + Util.getClassName(clazz) + "]");
            }

            _pageClasses[Util.tinyClassName(clazz)] = clazz;
        }
    }

    public function registerObjectMarshaller (marshaller :ObjectMarshaller) :void {
        _objectMarshallers[marshaller.valueClass] = marshaller;
    }

    public function loadTome (tomeData :DataElement, pageClass :Class) :MutableTome {
        var name :String = tomeData.name;
        if (!Util.validLibraryItemName(name)) {
            throw new LoadError("Tome name '" + name + "' is invalid", tomeData);
        }

        var tome :MutableTome = new MutableTome(name, pageClass);
        for each (var pageData :DataElement in tomeData.children) {
            tome.addPage(loadPage(pageData, pageClass));
        }
        return tome;
    }

    public function loadPage (pageData :DataElement, superclass :Class = null) :MutablePage {
        var name :String = pageData.name;
        if (!Util.validLibraryItemName(name)) {
            throw new LoadError("Page name '" + name + "' is invalid", pageData);
        }

        var reader :DataReader = DataReader.withData(pageData);
        var typename :String = reader.requireAttribute(TYPE_ATTR);
        var pageClass :Class = requirePageClass(typename, superclass);

        var page :MutablePage = new pageClass();
        page.setName(name);

        if (reader.hasAttribute(TEMPLATE_ATTR)) {
            // if this page has a template, we defer its loading until the end
            _loadTask.pendingTemplatedPages.push(new TemplatedPage(page, pageData));
        } else {
            loadPageProps(page, reader);
        }

        return page;
    }

    protected function requireObjectMarshallerForClass (clazz :Class) :ObjectMarshaller {
        var marshaller :ObjectMarshaller = _objectMarshallers[clazz];
        if (marshaller == null) {
            // if we can't find an exact match, see if we have a handler for a superclass that
            // can take subclasses
            for each (var candidate :ObjectMarshaller in _objectMarshallers) {
                if (candidate.handlesSubclasses && clazz is candidate.valueClass) {
                    _objectMarshallers[clazz] = candidate;
                    marshaller = candidate;
                    break;
                }
            }
        }

        if (marshaller == null) {
            throw new Error("No ObjectMarshaller for '" + Util.getClassName(clazz) + "'");
        }

        return marshaller;
    }

    protected function loadPageProps (page :MutablePage, pageData :DataElement, tmpl :Page = null) :void {
        // template's class must be equal to (or a subclass of) page's class
        if (tmpl != null && !(tmpl is Util.getClass(page))) {
            throw new LoadError("Incompatible template [pageName='" + page.name +
                "', pageClass=" + Util.getClassName(page) +
                ", templateName='" + tmpl.name +
                "', templateClass=" + Util.getClassName(tmpl), pageData);
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
                    "', class=" + Util.getClassName(prop) + "]", pageData);
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
        } else if (requiredSuperclass != null && !(clazz is requiredSuperclass)) {
            throw new LoadError("Unexpected page class [required=" +
                Util.getClassName(requiredSuperclass) + ", got=" + Util.getClassName(clazz));
        }
        return clazz;
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
import microtome.MutablePage;

class TemplatedPage {
    public function TemplatedPage (page :MutablePage, data :DataElement) {
        _page = page;
        _data = DataReader.withData(data);
    }

    public function get page () :MutablePage {
        return _page;
    }

    public function get data () :DataReader {
        return _data;
    }

    public function get templateName () :String {
        return _data.requireAttribute(TEMPLATE_ATTR);
    }

    protected var _page :MutablePage;
    protected var _data :DataReader;
}
