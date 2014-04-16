#
# microtome

from collections import MutableMapping
import logging

import microtome.core.defs as Defs
from microtome.error import MicrotomeError
from microtome.core.item import MicrotomeItem, LibraryItem

LOG = logging.getLogger(__name__)

class Library(MicrotomeItem, MutableMapping):
    def __init__(self):
        MicrotomeItem.__init__(self)
        self._tomes = {}

    @property
    def name(self):
        return None

    @property
    def library(self):
        return self

    @property
    def parent(self):
        return None

    def get_tome(self, tome_id):
        # A tome_id is a series of tome names, separated by dots
        # E.g. level1.baddies.big_boss
        cur_item = self
        for name in tome_id.split(Defs.ID_SEPARATOR):
            cur_item = cur_item.get(name)
            if not isinstance(cur_item, LibraryItem):
                return None
        return cur_item

    def require_tome(self, tome_id):
        tome = self.get_tome(tome_id)
        if tome is None:
            raise MicrotomeError("No such tome [id=%s]" % tome_id)
        return tome

    def add(self, tome):
        if tome.name in self._tomes:
            raise MicrotomeError("A tome with that name already exists [name=%s]" % tome.name)
        elif tome.parent is not None:
            raise MicrotomeError("Item is already in a library [tome=%s]" % str(tome))

        tome._parent = self
        self._tomes[tome.name] = tome

    def remove(self, tome):
        if tome.parent != self:
            raise MicrotomeError("Item is not in this library [tome=%s]" % str(tome))
        tome._parent = None
        del self._tomes[tome.name]

    def clear(self):
        for tome in self._tomes:
            tome._parent = None
        self._tomes = {}

    def __len__(self):
        return len(self._tomes)

    def __getitem__(self, key):
        return self._tomes[key]

    def __setitem__(self, key, value):
        raise NotImplementedError("Use Library.add_item")

    def __delitem__(self, key):
        item = self._tomes.pop(key)
        item._parent = None

    def __iter__(self):
        return self._tomes.__iter__()

    def __contains__(self, item):
        return self._tomes.__contains__(item)

if __name__ == "__main__":
    lib = Library()
