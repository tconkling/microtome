#
# microtome

from abc import ABCMeta, abstractmethod, abstractproperty

from microtome.error import ValidationError


class DataMarshaller(object):
    __metaclass__ = ABCMeta

    @abstractproperty
    def value_class(self):
        '''the class that this marshaller handles'''
        return None

    @abstractproperty
    def handles_subclasses(self):
        '''True if this marshaller handles subclasses of its value_class'''
        return False

    @abstractproperty
    def is_simple(self):
        '''True if this marshaller represents a "simple" data type.
        A simple type is one that can be parsed from a single value. Generally,
        composite objects are likely to be non-simple (thought, for example, a Tuple object
        could be made simple if you were to parse it from a comma-delimited string).
        '''
        return False

    @abstractmethod
    def read_value(self, mgr, reader, name, type_info):
        '''return data read using a data reader

        mgr -- the MicrotomeMgr in use
        reader -- the DataReader to read the value from
        name -- the value's name
        type_info -- TypeInfo for the value

        raise a LoadError if the data cannot be loaded
        '''
        pass

    @abstractmethod
    def read_default(self, mgr, type_info, annotation):
        '''return the value from the given annotation.

        mgr - the MicrotomeMgr in use
        type_info -- TypeInfo for the data
        annotation - the annotation to read from

        raise a LoadError if the annotation's value cannot be used
        '''
        pass

    @abstractmethod
    def write_value(self, mgr, writer, value, name, type_info):
        '''Write an object's value'''
        pass

    @abstractmethod
    def resolve_refs(self, mgr, value, type_info):
        '''Resolve the PageRefs contained within the given value'''
        pass

    @abstractmethod
    def validate_prop(self, prop):
        '''Validate a prop's value, possibly using the annotations on the prop.

        raise a ValidationError on failure
        '''
        pass

    @abstractmethod
    def clone_data(self, mgr, data, type_info):
        '''return a clone of the given data'''
        return None


class PrimitiveMarshaller(DataMarshaller):
    '''a marshaller for datatypes that can't be null'''
    def __init__(self, value_class):
        self._value_class = value_class

    @property
    def value_class(self):
        return self._value_class

    @property
    def handles_subclasses(self):
        return False

    @property
    def is_simple(self):
        return True

    def resolve_refs(self, mgr, value, type_info):
        # primitives don't store refs
        pass

    def clone_data(self, mgr, data, type_info):
        # primitives don't need cloning
        return data


class ObjectMarshaller(DataMarshaller):
    def __init__(self, is_simple):
        '''create an ObjectMarshaller.

        is_simple -- True if this marshaller represents a "simple" data type.
        A simple type is one that can be parsed from a single value.
        Generally, composite objects are likely to be non-simple (though, for example, a Tuple
        object could be made simple if you were to parse it from a comma-delimited string).
        '''
        self._is_simple = is_simple

    @property
    def is_simple(self):
        return self._is_simple

    @property
    def handles_subclasses(self):
        return False

    def resolve_refs(self, mgr, obj, type_info):
        # do nothing by default
        pass

    def clone_data(self, mgr, data, type_info):
        # handle null data
        return self.clone_object(mgr, data, type_info) if data else None

    def read_default(self, mgr, type_info, annotation):
        raise NotImplementedError()

    @abstractmethod
    def clone_object(self, mgr, obj, type_info):
        '''Clone the given object. It is guaranteed not to be None'''
        return None

    def validate_prop(self, prop):
        if not prop.nullable and prop.value is None:
            raise ValidationError(prop, "null value for non-nullable prop")
        elif prop.value and not isinstance(prop.value, self.value_class):
            raise ValidationError(prop, "incompatible value type [required=%s, actual=%s]" %
                                  (self.value_class.__name__, prop.value.__class__.__name__))
