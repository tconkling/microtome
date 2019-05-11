#
# microtome

from abc import ABCMeta, abstractmethod

class WritableObject(object):
    __metaclass__ = ABCMeta

    @abstractmethod
    def add_child(self, name):
        """Create and return a new WritableObject with the given name"""
        return None

    @abstractmethod
    def write_bool(self, name, value):
        pass

    @abstractmethod
    def write_int(self, name, value):
        pass

    @abstractmethod
    def write_float(self, name, value):
        pass

    @abstractmethod
    def write_string(self, name, value):
        pass
