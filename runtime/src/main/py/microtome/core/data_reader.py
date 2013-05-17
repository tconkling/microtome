#
# microtome

from abc import ABCMeta, abstractmethod, abstractproperty

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
