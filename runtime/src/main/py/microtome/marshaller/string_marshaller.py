#
# microtome

from data_marshaller import ObjectMarshaller

class StringMarshaller(ObjectMarshaller):
    def __init__(self):
        ObjectMarshaller.__init__(self, True)

    @property
    def value_class(self):
        return str

    def read_value(self, mgr, reader, name, type_info):
        return reader.require_string(name)

    def read_default(self, mgr, type_info, annotation):
        return annotation.string_value("")

    def write_value(self, mgr, writer, obj, name, type_info):
        raise NotImplementedError()

    def clone_object(self, mgr, data, type_info):
        # strings don't need cloning
        return data
