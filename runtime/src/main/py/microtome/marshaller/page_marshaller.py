#
# microtome

from microtome.marshaller.data_marshaller import ObjectMarshaller
from microtome.page import Page
from microtome.error import ResolveRefError

class PageMarshaller(ObjectMarshaller):
    def __init__(self):
        ObjectMarshaller.__init__(self, False)

    @property
    def value_class(self):
        return Page

    @property
    def handles_subclasses(self):
        return True

    def read_value(self, mgr, reader, name, type_info):
        return mgr.load_page(reader, type_info.clazz)

    def write_value(self, mgr, writer, page, name, type_info):
        return mgr.write_page(writer, page)

    def resolve_refs(self, mgr, page, type_info):
        for prop in page.props:
            if prop.value is not None:
                try:
                    marshaller = mgr.require_data_marshaller(prop.value_type.clazz)
                    marshaller.resolve_refs(mgr, prop.value, prop.value_type)
                except ResolveRefError:
                    raise
                except Exception as e:
                    raise ResolveRefError("Failed to resolve ref [page=%s]" % page.qualified_name, cause=e)

    def clone_object(self, mgr, page, type_info):
        clazz = page.__class__
        clone = clazz(page.name)

        for ii in range(len(page.props)):
            prop = page.props[ii]
            clone_prop = clone.props[ii]
            marshaller = mgr.require_data_marshaller(prop.value_type.clazz)
            clone_prop.value = marshaller.clone_data(mgr, prop.value, prop.value_type)
