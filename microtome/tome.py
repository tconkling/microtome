#
# microtome

from microtome.core.item import LibraryItemBase
from microtome.core.type_info import TypeInfo
from microtome.error import MicrotomeError

_EMPTY_LIST = []

class Tome(LibraryItemBase):
    def __init__(self, name):
        LibraryItemBase.__init__(self, name)
        self._type_info = None
        self._tomes = {}

    @property
    def type_info(self):
        if self._type_info is None:
            self._type_info = TypeInfo(self.__class__, None)
        return self._type_info

    @property
    def props(self):
        return _EMPTY_LIST

    def add_tome(self, tome):
        tome._parent = self
        self._tomes[tome.name] = tome

    def remove_tome(self, tome):
        if tome.parent != self:
            raise MicrotomeError("specified Tome is not contained in this Tome [tome=%s]" % str(tome))
        tome._parent = None
        del self._tomes[tome.name]

    def __iter__(self):
        return self._tomes.__iter__()

    def __len__(self):
        return self._tomes.__len__()

    def __contains__(self, key):
        return self._tomes.__contains__(key)

    def __getitem__(self, key):
        return self._tomes.__getitem__(key)

    def __str__(self):
        return "%s:'%s'" % (self.__class__.__name__, self._name)

if __name__ == "__main__":
    Tome("qwert")
