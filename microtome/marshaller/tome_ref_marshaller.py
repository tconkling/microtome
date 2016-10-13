#
# microtome

from microtome.marshaller.data_marshaller import ObjectMarshaller
from microtome.core.tome_ref import TomeRef


class TomeRefMarshaller(ObjectMarshaller):
    def __init__(self):
        ObjectMarshaller.__init__(self, True)

    @property
    def value_class(self):
        return TomeRef

    def read_value(self, mgr, reader, name, type_info):
        return TomeRef(reader.require_string(name))

    def read_default(self, mgr, type_info, anno):
        return TomeRef(anno.string_value(None))

    def write_value(self, mgr, writer, tome_ref, name, type_info):
        writer.write_string(name, tome_ref.tome_id)

    def resolve_refs(self, mgr, tome_ref, type_info):
        tome_ref.resolve(mgr.library, type_info.subtype.clazz)

    def clone_object(self, mgr, tome_ref, type_info):
        return tome_ref.clone()
