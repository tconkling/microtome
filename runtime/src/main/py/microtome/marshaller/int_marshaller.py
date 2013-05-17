#
# microtome

from error import ValidationError
from data_marshaller import PrimitiveMarshaller
import core.defs as Defs

class IntMarshaller(PrimitiveMarshaller):
    def __init__(self):
        PrimitiveMarshaller.__init__(self, int)

    def validate_prop(self, prop):
        min_val = prop.annotation(Defs.MIN_ANNOTATION).int_value(float('-inf'))
        if prop.value < min_val:
            raise ValidationError(prop, "value too small (%d < %d)" % (prop.value, min_val))
        max_val = prop.annotation(Defs.MAX_ANNOTATION).int_value(float('inf'))
        if prop.value > max_val:
            raise ValidationError(prop, "value too large (%d > %d)" % (prop.value, max_val))

    def read_value(self, mgr, reader, name, type_info):
        return reader.require_int(name)

    def read_default(self, mgr, type_info, annotation):
        return annotation.int_value(0)

    def write_value(self, mgr, writer, value, name, type_info):
        raise NotImplementedError()
