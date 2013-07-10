#
# microtome

from microtome.marshaller.data_marshaller import ObjectMarshaller

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

    def write_value(self, mgr, writer, value, name, type_info):
        writer.write_string(name, value)

    def clone_object(self, mgr, data, type_info):
        # strings don't need cloning
        return data
