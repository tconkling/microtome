#
# microtome

from abc import ABCMeta, abstractmethod, abstractproperty

from microtome.error import MicrotomeError
import microtome.core.defs as Defs

class MicrotomeItem(object):
    __metaclass__ = ABCMeta

    @abstractproperty
    def name(self):
        return ""

    @abstractproperty
    def library(self):
        return None

    @abstractproperty
    def parent(self):
        return None

    @abstractproperty
    def children(self):
        return []


class LibraryItem(MicrotomeItem):
    @abstractproperty
    def qualified_name(self):
        '''the item's fully qualified name, used during PageRef resolution'''
        return ""

    @abstractproperty
    def type_info(self):
        return None

    @abstractmethod
    def child_named(self, name):
        return None


class LibraryItemBase(LibraryItem):
    def __init__(self, name):
        self._name = name
        self._parent = None

    @property
    def qualified_name(self):
        if self.library is None:
            raise MicrotomeError("item must be in a library to have a qualified_name [item=%s]" % self)

        out = self._name
        cur_item = self._parent
        while cur_item and cur_item.library != cur_item:
            out = cur_item.name + Defs.NAME_SEPARATOR + out
            cur_item = cur_item.parent

        return out

    @property
    def name(self):
        return self._name

    @property
    def parent(self):
        return self._parent

    @property
    def library(self):
        return self._parent.library if self._parent else None
