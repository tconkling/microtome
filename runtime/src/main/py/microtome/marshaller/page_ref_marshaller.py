#
# microtome

from microtome.marshaller.data_marshaller import ObjectMarshaller
from microtome.core.page_ref import PageRef

class PageRefMarshaller(ObjectMarshaller):
    def __init__(self):
        ObjectMarshaller.__init__(self, True)

    @property
    def value_class(self):
        return PageRef

    def read_value(self, mgr, reader, name, type_info):
        return PageRef(reader.require_string(name))

    def write_value(self, mgr, writer, page_ref, name, type_info):
        writer.write_string(name, page_ref.page_name)

    def resolve_refs(self, mgr, page_ref, type_info):
        page_ref.resolve(mgr.library, type_info.subtype.clazz)

    def clone_object(self, mgr, page_ref, type_info):
        return page_ref.clone()
