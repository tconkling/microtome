#
# microtome

from data_marshaller import ObjectMarshaller
from tome import Tome

class TomeMarshaller(ObjectMarshaller):
    def __init__(self):
        ObjectMarshaller.__init__(self, False)

    @property
    def value_class(self):
        return Tome

    def read_value(self, mgr, reader, name, type_info):
        return mgr.load_tome(reader, type_info.subtype.clazz)

    def write_value(self, mgr, writer, tome, name, type_info):
        mgr.write_tome(writer, tome)

    def resolve_refs(self, mgr, tome, type_info):
        page_marshaller = mgr.require_data_marshaller(tome.page_class)
        for page in tome.children:
            page_marshaller.resolve_refs(mgr, page, type_info.subtype)

    def clone_object(self, mgr, tome, type_info):
        page_marshaller = mgr.require_data_marshaller(tome.page_class)
        clone = Tome(tome.name, tome.page_class)
        for page in tome.children:
            clone.add_page(page_marshaller.clone_data(mgr, page, type_info.subtype))
        return clone
