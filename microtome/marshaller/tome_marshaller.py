#
# microtome

from microtome.marshaller.data_marshaller import ObjectMarshaller
from microtome.tome import Tome
from microtome.error import ResolveRefError
import microtome.util as util

class TomeMarshaller(ObjectMarshaller):
    def __init__(self):
        ObjectMarshaller.__init__(self, False)

    @property
    def handles_subclasses(self):
        return True

    @property
    def value_class(self):
        return Tome

    def read_value(self, mgr, reader, name, type_info):
        return mgr.load_tome(reader, type_info.clazz)

    def write_value(self, mgr, writer, tome, name, type_info):
        mgr.write_tome(writer, tome)

    def resolve_refs(self, mgr, tome, type_info):
        # non-tome props
        for prop in (prop for prop in util.basic_props(tome) if prop.value is not None):
            try:
                marshaller = mgr.require_data_marshaller(prop.value_type.clazz)
                marshaller.resolve_refs(mgr, prop.value, prop.value_type)
            except ResolveRefError:
                raise
            except Exception as e:
                raise ResolveRefError("Failed to resolve ref [tome=%s]" % tome.qualified_name, cause=e)

        # child tomes
        for child_tome in tome.values():
            marshaller = mgr.require_data_marshaller(child_tome.type_info.clazz)
            marshaller.resolve_refs(mgr, child_tome, child_tome.type_info)

    def clone_object(self, mgr, tome, type_info):
        clone = tome.__class__(tome.name)

        # non-tome props
        my_basic_props = list(util.basic_props(tome))
        clone_basic_props = list(util.basic_props(clone))
        for ii in range(len(my_basic_props)):
            prop = my_basic_props[ii]
            clone_prop = clone_basic_props[ii]
            marshaller = mgr.require_data_marshaller(prop.value_type.clazz)
            clone_prop.value = marshaller.clone_data(mgr, prop.value, prop.value_type)

        # child tomes
        for child_tome in tome.values():
            marshaller = mgr.require_data_marshaller(child_tome.type_info.clazz)
            clone.add_tome(marshaller.clone_data(mgr, child_tome, child_tome.type_info))
        return clone
