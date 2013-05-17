#
# microtome

from data_marshaller import PrimitiveMarshaller

class BoolMarshaller(PrimitiveMarshaller):
    def __init__(self):
        PrimitiveMarshaller.__init__(self, bool)

    def validate_prop(self, prop):
        # no validation necessary
        pass

    def read_value(self, mgr, reader, name, type_info):
        return reader.require_bool(name)

    def read_default(self, mgr, type_info, annotation):
        return annotation.bool_value(False)

    def write_value(self, mgr, writer, value, name, type_info):
        raise NotImplementedError()
