#
# microtome

from abc import abstractproperty
from collections import Mapping

from microtome.error import MicrotomeError
import microtome.core.defs as Defs

class MicrotomeItem(Mapping):
    @abstractproperty
    def name(self):
        return ""

    @abstractproperty
    def library(self):
        return None

    @abstractproperty
    def parent(self):
        return None

    def __eq__(self, other):
        return self is other


class LibraryItem(MicrotomeItem):
    @abstractproperty
    def id(self):
        """the item's fully qualified name, used during TomeRef resolution"""
        return ""

    @abstractproperty
    def type_info(self):
        return None


class LibraryItemBase(LibraryItem):
    def __init__(self, name):
        self._name = name
        self._parent = None

    @property
    def id(self):
        if self.library is None:
            raise MicrotomeError("item must be in a library to have an ID [item=%s]" % self)

        out = self._name
        cur_item = self._parent
        while cur_item and cur_item.library != cur_item:
            out = cur_item.name + Defs.ID_SEPARATOR + out
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
