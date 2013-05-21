#
# microtome

from microtome.error import ValidationError
from microtome.marshaller.data_marshaller import PrimitiveMarshaller
import microtome.core.defs as Defs

class FloatMarshaller(PrimitiveMarshaller):
    def __init__(self):
        PrimitiveMarshaller.__init__(self, float)

    def validate_prop(self, prop):
        min_val = prop.annotation(Defs.MIN_ANNOTATION).float_value(float('-inf'))
        if prop.value < min_val:
            raise ValidationError(prop, "value too small (%g < %g)" % (prop.value, min_val))
        max_val = prop.annotation(Defs.MAX_ANNOTATION).float_value(float('inf'))
        if prop.value > max_val:
            raise ValidationError(prop, "value too large (%g > %g)" % (prop.value, max_val))

    def read_value(self, mgr, reader, name, type_info):
        return reader.require_float(name)

    def read_default(self, mgr, type_info, annotation):
        return annotation.float_value(0.0)

    def write_value(self, mgr, writer, value, name, type_info):
        raise NotImplementedError()
