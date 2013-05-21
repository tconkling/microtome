#
# microtome

from abc import ABCMeta, abstractmethod, abstractproperty

from microtome.error import LoadError

class DataReader(object):
    def __init__(self, readable_object):
        self._data = readable_object
        self._children = None
        self._childrenByName = None

    @property
    def data(self):
        return self._data

    @property
    def name(self):
        return self._data.name

    def has_value(self, name):
        return self._data.has_value(name)

    @property
    def children(self):
        if self._children is None:
            self._children = [DataReader(child) for child in self._data.children]
        return self._children

    def has_child(self, name):
        return self.get_child(name) is not None

    def get_child(self, name):
        if self._childrenByName is None:
            self._childrenByName = {child.name: child for child in self.children}
        return self._childrenByName.get(name, None)

    def require_child(self, name):
        child = self.get_child(name)
        if child is None:
            raise LoadError(self._data, "Missing required child [name=%s]" % name)
        return child

    def get_string(self, name, default=None):
        return self._data.get_string(name) if self._data.has_value(name) else default

    def get_bool(self, name, default=False):
        return self._data.get_bool(name) if self._data.has_value(name) else default

    def get_int(self, name, default=0):
        return self._data.get_int(name) if self._data.has_value(name) else default

    def get_float(self, name, default=0.0):
        return self._data.get_float(name) if self._data.has_value(name) else default

    def require_string(self, name):
        return self._data.get_string(name)

    def require_bool(self, name):
        return self._data.get_bool(name)

    def require_int(self, name):
        return self._data.get_int(name)

    def require_float(self, name):
        return self._data.get_float(name)


class ReadableObject(object):
    __metaclass__ = ABCMeta

    @abstractproperty
    def name(self):
        return ""

    @abstractproperty
    def debug_description(self):
        return ""

    @abstractproperty
    def children(self):
        return []

    @abstractmethod
    def has_value(self, name):
        return False

    @abstractmethod
    def get_bool(self, name):
        return False

    @abstractmethod
    def get_int(self, name):
        return 0

    @abstractmethod
    def get_float(self, name):
        return 0

    @abstractmethod
    def get_string(self, name):
        return ""

