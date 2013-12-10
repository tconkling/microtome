//
// microtome

package microtome.core {

import flash.utils.Dictionary;

import microtome.Library;
import microtome.MicrotomeCtx;
import microtome.MutableTome;
import microtome.Tome;
import microtome.error.LoadError;
import microtome.error.MicrotomeError;
import microtome.marshaller.BoolMarshaller;
import microtome.marshaller.DataMarshaller;
import microtome.marshaller.IntMarshaller;
import microtome.marshaller.ListMarshaller;
import microtome.marshaller.NumberMarshaller;
import microtome.marshaller.StringMarshaller;
import microtome.marshaller.TomeMarshaller;
import microtome.marshaller.TomeRefMarshaller;
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
        registerDataMarshaller(new TomeMarshaller());
        registerDataMarshaller(new TomeRefMarshaller());
        registerDataMarshaller(new StringMarshaller());

        registerTomeClasses(new <Class>[ MutableTome ]);
    }

    public final function get library () :Library {
        return _loadTask.library;
    }

    public function registerTomeClasses (classes :Vector.<Class>) :void {
        for each (var clazz :Class in classes) {
            if (!ClassUtil.isAssignableAs(MutableTome, clazz)) {
                throw new MicrotomeError("Class must extend " + ClassUtil.getClassName(MutableTome),
                    "tomeClass", ClassUtil.getClassName(clazz));
            }

            _tomeClasses[Util.tomeTypeName(clazz)] = clazz;
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

    public function getTomeClass (name :String) :Class {
        return _tomeClasses[name];
    }

    public function requireTomeClass (name :String, requiredSuperclass :Class = null) :Class {
        var clazz :Class = getTomeClass(name);
        if (clazz == null) {
            throw new LoadError(null, "No such tome class", "name", name);
        } else if (requiredSuperclass != null && !ClassUtil.isAssignableAs(requiredSuperclass, clazz)) {
            throw new LoadError(null, "Unexpected tome class",
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
                    _loadTask.addTome(loadTome(itemReader));
                }
            }

            addLoadedItems(_loadTask);

            // Resolve all templated items:
            // Iterate through the array as many times as it takes to resolve all template-dependent
            // tomes (some templates may themselves have templates in the pendingTemplatedTomes).
            var foundTemplate :Boolean = true;
            while (foundTemplate) {
                foundTemplate = false;
                for (var ii :int = 0; ii < _loadTask.pendingTemplatedTomes.length; ++ii) {
                    var tTome :TemplatedTome = _loadTask.pendingTemplatedTomes[ii];
                    var tmpl :MutableTome = _loadTask.library.getTomeWithQualifiedName(tTome.templateName);
                    if (tmpl != null && !_loadTask.isPendingTemplatedTome(tmpl)) {
                        loadTomeNow(tTome.tome, tTome.reader, tmpl);
                        _loadTask.pendingTemplatedTomes.splice(ii--, 1);
                        foundTemplate = true;
                        break;
                    }
                }
            }

            // throw an error if we're missing a template
            if (_loadTask.pendingTemplatedTomes.length > 0) {
                const missing :TemplatedTome = _loadTask.pendingTemplatedTomes[0];
                throw new LoadError(missing.reader.data, "Missing template",
                    "name", missing.templateName);
            }

            // finalize the load, which resolves all TomeRefs
            finalizeLoadedItems(_loadTask);

        } catch (e :Error) {
            abortLoad(_loadTask);
            throw e;

        } finally {
            _loadTask = null;
        }
    }

    public function loadTome (reader :DataReader, requiredSuperclass :Class = null) :MutableTome {
        const name :String = reader.name;
        if (!Util.validLibraryItemName(name)) {
            throw new LoadError(reader.data, "Invalid tome name", "name", name);
        }

        const typename :String = reader.getString(Defs.TOME_TYPE_ATTR, Defs.MUTABLE_TOME_NAME);
        const tomeClass :Class = requireTomeClass(typename, requiredSuperclass);

        const tome :MutableTome = new tomeClass(name);

        if (reader.hasValue(Defs.TEMPLATE_ATTR)) {
            // if this tome has a template, we defer its loading until the end
            _loadTask.pendingTemplatedTomes.push(new TemplatedTome(tome, reader));
        } else {
            loadTomeNow(tome, reader);
        }

        return tome;
    }

    public function write (item :Tome, writer :WritableObject) :void {
        writeTome(writer.addChild(item.name), MutableTome(item));
    }

    public function writeTome (writer :WritableObject, tome :MutableTome) :void {
        writer.writeString(Defs.TOME_TYPE_ATTR, Util.tomeTypeName(ClassUtil.getClass(tome)));

        // TODO: template suppport...

        // Write out non-Tome props
        for each (var prop :Prop in tome.props) {
            if (prop.value === null || prop.value is MutableTome) {
                continue;
            }
            var marshaller :DataMarshaller = requireDataMarshaller(prop.valueType.clazz);
            var childWriter :WritableObject =
                (marshaller.isSimple ? writer : writer.addChild(prop.name));
            marshaller.writeValue(this, childWriter, prop.value, prop.name, prop.valueType);
        }

        // Write out all Tomes
        for each (var tome :MutableTome in tome.children.sortOn("name")) {
            writeTome(writer.addChild(tome.name), tome);
        }
    }

    public function clone (tome :Tome) :* {
        const clazz :Class = ClassUtil.getClass(tome);
        const marshaller :DataMarshaller = requireDataMarshaller(clazz);
        return marshaller.cloneData(this, tome, tome.typeInfo);
    }

    protected function loadTomeNow (tome :MutableTome, reader :DataReader, tmpl :MutableTome = null) :void {
        // props
        loadTomeProps(tome, reader, tmpl);

        // additional non-prop tomes
        for each (var tomeReader :DataReader in reader.children) {
            if (Util.getProp(tome, tomeReader.name) == null) {
                tome.addTome(loadTome(tomeReader));
            }
        }

        // clone any additional tomes inside our template
        if (tmpl != null) {
            tmpl.forEachTome(function (tmplChild :Tome) :void {
                if (!tome.hasTome(tmplChild.name)) {
                    tome.addTome(clone(tmplChild));
                }
            });
        }
    }

    protected function loadTomeProps (tome :MutableTome, reader :DataReader, tmpl :MutableTome = null) :void {
        // template's class must be equal to (or a subclass of) tome's class
        if (tmpl != null && !(tmpl is ClassUtil.getClass(tome))) {
            throw new LoadError(reader.data, "Incompatible template", "tomeName", tome.name,
                "tomeClass", ClassUtil.getClassName(tome), "templateName", tmpl.name,
                "templateClass", ClassUtil.getClassName(tmpl));
        }

        for each (var prop :Prop in tome.props) {
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
                loadTomeProp(tome, prop, tProp, reader);
            } catch (loadErr :LoadError) {
                throw loadErr;
            } catch (err :Error) {
                throw new LoadError(reader.data, "Error loading prop", "name", prop.name)
                    .initCause(err);
            }
        }
    }

    protected function loadTomeProp (tome :Tome, prop :Prop, tProp :Prop, tomeReader :DataReader) :void {
        // 1. Read the value from the DataReader, if it exists
        // 2. Else, clone the value from the template, if it exists
        // 3. Else, read the value from its 'default' annotation, if it exists
        // 3. Else, set the value to null if it's nullable
        // 4. Else, fail.

        const name :String = prop.name;
        const marshaller :DataMarshaller = requireDataMarshaller(prop.valueType.clazz);

        const canRead :Boolean =
            (marshaller.isSimple ? tomeReader.hasValue(name) : tomeReader.hasChild(name));
        const useTemplate :Boolean = !canRead && (tProp != null);

        if (canRead) {
            const reader :DataReader =
                (marshaller.isSimple ? tomeReader : tomeReader.requireChild(name));
            prop.value = marshaller.readValue(this, reader, name, prop.valueType);
            marshaller.validateProp(prop);
        } else if (useTemplate) {
            prop.value = marshaller.cloneData(this, tProp.value, tProp.valueType);
        } else if (prop.hasDefault) {
            prop.value = marshaller.readDefault(this, prop.valueType, prop.annotation(Defs.DEFAULT_ANNOTATION));
        } else if (prop.nullable) {
            prop.value = null;
        } else {
            throw new LoadError(tomeReader.data, "Missing required value or child", "name", name);
        }
    }

    protected function addLoadedItems (task :LoadTask) :void {
        if (task.state != LoadTask.LOADING) {
            throw new MicrotomeError("task.state != LOADING");
        }

        for each (var item :Tome in task.libraryItems) {
            if (task.library.hasTome(item.name)) {
                task.state = LoadTask.ABORTED;
                throw new LoadError(null, "An item named '" + item.name + "' is already loaded");
            }
        }

        for each (item in task.libraryItems) {
            task.library.addTome(item);
        }

        task.state = LoadTask.ADDED_ITEMS;
    }

    protected function finalizeLoadedItems (task :LoadTask) :void {
        if (task.state != LoadTask.ADDED_ITEMS) {
            throw new MicrotomeError("task.state != ADDED_ITEMS");
        }

        try {
            for each (var item :Tome in task.libraryItems) {
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

        for each (var item :Tome in task.libraryItems) {
            if (task.library == item.library) {
                task.library.removeTome(item);
            }
        }
        task.state = LoadTask.ABORTED;
    }

    protected var _tomeClasses :Dictionary = new Dictionary();  // <String, Class>
    protected var _dataMarshallers :Dictionary = new Dictionary(); // <Class, DataMarshaller>

    protected var _loadTask :LoadTask;
}
}
