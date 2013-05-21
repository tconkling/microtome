#
# microtome

import microtome.util as util
import microtome.core.defs as Defs
from microtome.ctx import MicrotomeCtx
from microtome.page import Page
from microtome.tome import Tome
from microtome.error import MicrotomeError, LoadError
from microtome.core.reader import DataReader
from microtome.marshaller.bool_marshaller import BoolMarshaller
from microtome.marshaller.int_marshaller import IntMarshaller
from microtome.marshaller.float_marshaller import FloatMarshaller
from microtome.marshaller.list_marshaller import ListMarshaller
from microtome.marshaller.page_marshaller import PageMarshaller
from microtome.marshaller.page_ref_marshaller import PageRefMarshaller
from microtome.marshaller.string_marshaller import StringMarshaller
from microtome.marshaller.tome_marshaller import TomeMarshaller

class MicrotomeMgr(MicrotomeCtx):
    def __init__(self):
        self._load_task = None
        self._data_marshallers = {}
        self._page_classes = {}
        self.register_data_marshaller(BoolMarshaller())
        self.register_data_marshaller(IntMarshaller())
        self.register_data_marshaller(FloatMarshaller())
        self.register_data_marshaller(ListMarshaller())
        self.register_data_marshaller(PageMarshaller())
        self.register_data_marshaller(PageRefMarshaller())
        self.register_data_marshaller(StringMarshaller())
        self.register_data_marshaller(TomeMarshaller())

    def register_page_classes(self, classes):
        for clazz in classes:
            if not issubclass(clazz, Page):
                raise MicrotomeError("Class must extend %s [page_class=%s]" % (str(Page), str(clazz)))
        self._page_classes[util.page_typename(clazz)] = clazz

    def register_data_marshaller(self, marshaller):
        self._data_marshallers[marshaller.value_class] = marshaller

    def require_data_marshaller(self, clazz):
        marshaller = self._data_marshallers.get(clazz, None)
        if marshaller is None:
            # if we can't find an exact match, see if we have a handler for a superclass that can
            # take subclasses
            for candidate in self._data_marshallers.values():
                if candidate.handles_subclasses and issubclass(clazz, candidate.value_class):
                    self._data_marshallers[clazz] = candidate
                    marshaller = candidate
                    break

        if marshaller is None:
            raise MicrotomeError("No DataMarshaller for '%s'" % str(clazz))

        return marshaller

    def get_page_class(self, name):
        return self._page_classes.get(name, None)

    def require_page_class(self, name, required_superclass=None):
        clazz = self.get_page_class(name)
        if clazz is None:
            raise LoadError(None, "No such page class [name=%s]", name)
        elif required_superclass is not None and not issubclass(clazz, required_superclass):
            raise LoadError(None, "Unexpected page class [required=%s, got=%s]" %
                            (str(required_superclass), str(clazz)))
        return clazz

    def load(self, library, readable_objects):
        if self._load_task is not None:
            raise MicrotomeError("Load already in progress")

        self._load_task = LoadTask(library)

        try:
            for obj in readable_objects:
                for item_reader in DataReader(obj).children:
                    self._load_task.add_item(self._load_library_item(item_reader))

            self._add_loaded_items(self._load_task)

            # Resolve all templated items:
            # Iterate through the array as many times as it takes to resolve all template-dependent
            # pages (some templates may themselves have templates in the pendingTemplatedPages).
            # _pendingTemplatedPages can have items added to it during this process.
            found_template = True
            while found_template:
                found_template = False
                for ii in range(len(self._load_task.pending_templated_pages)):
                    templated_page = self._load_task.pending_templated_pages[ii]
                    template = self._load_task.library.get_item_with_qualified_name(templated_page.template_name)
                    if template is None:
                        continue
                    self.load_page_props(templated_page.page, templated_page.reader, template)
                    self._load_task.pending_templated_pages.pop(ii)
                    found_template = True

            # throw an error if we're missing a template
            if len(self._load_task.pending_templated_pages) > 0:
                missing = self._load_task.pending_templated_pages[0]
                raise LoadError(missing.reader.data, "Missing template [name=%s]" % missing.template_name)

            # finalize the load, which resolves all PageRefs
            self._finalize_loaded_items(self._load_task)

        except:
            self._abort_load(self._load_task)
            raise
        finally:
            self._load_task = None

    def load_tome(self, reader, page_class):
        name = reader.name
        if not util.valid_library_item_name(name):
            raise LoadError(reader.data, "Invalid tome name [name=%s]" % name)

        tome = Tome(name, page_class)
        for page_reader in reader.children:
            tome.add_page(self.load_page(page_reader, page_class))

        return tome

    def load_page(self, reader, required_superclass=None):
        name = reader.name
        if not util.valid_library_item_name(name):
            raise LoadError(reader.data, "Invalid tome name [name=%s]" % name)

        typename = reader.require_string(Defs.PAGE_TYPE_ATTR)
        page_class = self.require_page_class(typename, required_superclass)
        page = page_class(name)

        if reader.has_value(Defs.TEMPLATE_ATTR):
            # if this page has a template, we defer its loading until the end
            self._load_task.pending_templated_pages.append(TemplatedPage(page, reader))
        else:
            self._load_page_props(page, reader)

    def write(self, item, writer):
        raise NotImplementedError()

    def clone(self, item):
        raise NotImplementedError()

    def _load_page_props(self, page, reader, template=None):
        # template's class must be equal to, or subclass of, page's class
        if template is not None and not isinstance(template, page.__class__):
            raise LoadError(reader.data, "Incompatible template [page_name=%s, page_class=%s, template_name=%s, template_class=%s" %
                            (page.name, str(page.__class__), template.name, str(template.__class__)))

        for prop in page.props:
            # if we have a page template, get its corresponding prop
            t_prop = None
            if template is not None:
                t_prop = util.get_prop(template, prop.name)
            if t_prop is None:
                raise LoadError(reader.data, "Missing prop in template [template=%s, prop=%s]" % (template.name, prop.name))

            # load the prop
            try:
                self._load_page_prop(page, prop, t_prop, reader)
            except LoadError:
                raise
            except Exception as e:
                raise LoadError(reader.data, "Error loading prop [name=%s, cause=%s]" % (prop.name, str(e)))

    def _load_page_prop(self, page, prop, t_prop, page_reader):
        # 1. Read the value from the DataReader, if it exists
        # 2. Else, copy the value from the template, if it exists
        # 3. Else, read the value from its 'default' annotation, if it exists
        # 3. Else, set the value to null if it's nullable
        # 4. Else, fail.
        name = prop.name
        marshaller = self.require_data_marshaller(prop.value_type.clazz)

        can_read = page_reader.has_value(name) if marshaller.is_simple else page_reader.has_child(name)
        use_template = not can_read and t_prop is not None

        if can_read:
            reader = page_reader if marshaller.is_simple else page_reader.require_child(name)
            prop.value = marshaller.read_value(self, reader, name, prop.value_type)
            marshaller.validate_prop(prop)
        elif use_template:
            prop.value = t_prop.value
        elif prop.has_default:
            prop.value = marshaller.read_default(self, prop.value_type, prop.annotation(Defs.DEFAULT_ANNOTATION))
        elif prop.nullable:
            prop.value = None
        else:
            raise LoadError(page_reader.data, "Missing required child or value [name=%s]" % name)

    def _load_library_item(self, reader):
        # a tome or a page
        page_typename = reader.require_string(Defs.PAGE_TYPE_ATTR)
        if reader.get_bool(Defs.IS_TOME_ATTR, False):
            # it's a tome!
            return self.load_tome(reader, self.require_page_class(page_typename))
        else:
            # it's a page!
            return self.load_page(reader)

    def _add_loaded_items(self, load_task):
        if load_task.state != LoadTask.LOADING:
            raise MicrotomeError("task.state != LOADING")

        for item in load_task.library_items:
            if load_task.library.has_item(item.name):
                load_task.state = LoadTask.ABORTED
                raise LoadError(None, "An item named '%s' is already loaded" % item.name)

        for item in load_task.library_items:
            load_task.library.add_item(item)

        load_task.state = LoadTask.ADDED_ITEMS

    def _finalize_loaded_items(self, load_task):
        if load_task.state != LoadTask.ADDED_ITEMS:
            raise MicrotomeError("task.state != ADDED_ITEMS")

        try:
            for item in load_task.library_items:
                self.require_data_marshaller(item._class__).resolve_refs(self, item, item.type_info)
        except:
            self._abort_load(load_task)
            raise

        load_task.state = LoadTask.FINALIZED

    def _abort_load(self, load_task):
        if load_task.state == LoadTask.ABORTED:
            return

        for item in load_task.library_items:
            if load_task.library == item.library:
                load_task.library.remove_item(item)

        load_task.state = LoadTask.ABORTED


class LoadTask(object):
    LOADING = 0
    ADDED_ITEMS = 1
    FINALIZED = 2
    ABORTED = 3

    def __init__(self, library):
        self._library = library
        self._library_items = []
        self.state = LoadTask.LOADING
        self.pending_templated_pages = []

    @property
    def library(self):
        return self._library

    @property
    def library_items(self):
        return self._library_items

    def add_item(self, item):
        if self.state != LoadTask.LOADING:
            raise MicrotomeError("state != LOADING")
        self._library_items.append(item)


class TemplatedPage(object):
    def __init__(self, page, reader):
        self.page = page
        self.reader = reader

    @property
    def template_name(self):
        return self.reader.require_string(Defs.TEMPLATE_ATTR)

if __name__ == "__main__":
    mgr = MicrotomeMgr()

