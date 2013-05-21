#
# microtome

from microtome.marshaller.data_marshaller import ObjectMarshaller
from microtome.core.item import MicrotomeItem

class ListMarshaller(ObjectMarshaller):
    def __init__(self):
        ObjectMarshaller.__init__(self, False)

    @property
    def value_class(self):
        return list

    def read_value(self, mgr, reader, name, type_info):
        out = []
        child_marshaller = mgr.require_data_marshaller(type_info.subtype.clazz)
        for child_reader in reader.children:
            out.append(child_marshaller.read_value(mgr, child_reader, child_reader.name, type_info.subtype))
        return out

    def write_value(self, mgr, writer, the_list, name, type_info):
        child_marshaller = mgr.require_data_marshaller(type_info.subtype.clazz)
        for child in the_list:
            name = child.name if isinstance(child, MicrotomeItem) else "item"
            child_marshaller.write_value(mgr, writer.add_child(name), child, name, type_info.subtype)

    def resolve_refs(self, mgr, the_list, type_info):
        child_marshaller = mgr.require_data_marshaller(type_info.subtype.clazz)
        for child in the_list:
            child_marshaller.resolve_refs(mgr, child, type_info.subtype)

    def clone_object(self, mgr, the_list, type_info):
        child_marshaller = mgr.require_data_marshaller(type_info.subtype.clazz)
        return [child_marshaller.clone_data(mgr, child, type_info.subtype) for child in the_list]
