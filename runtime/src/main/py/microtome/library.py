#
# microtome

from collections import MutableMapping

import microtome.core.defs as Defs
from microtome.error import MicrotomeError
from microtome.core.item import MicrotomeItem, LibraryItem

class Library(MicrotomeItem, MutableMapping):
    def __init__(self):
        MicrotomeItem.__init__(self)
        self._items = {}

    @property
    def name(self):
        return None

    @property
    def library(self):
        return self

    @property
    def parent(self):
        return None

    def get_item_with_qualified_name(self, qualified_name):
        # A qualifiedName is a series of page and tome names, separated by dots
        # E.g. level1.baddies.big_boss
        cur_item = self
        for name in qualified_name.split(Defs.NAME_SEPARATOR):
            cur_item = cur_item.get(name)
            if not isinstance(cur_item, LibraryItem):
                return None
        return cur_item

    def add(self, item):
        if item.name in self._items:
            raise MicrotomeError("An item with that name already exists [name=%s]" % item.name)
        elif item.parent is not None:
            raise MicrotomeError("Item is already in a library [item=%s]" % str(item))

        item._parent = self
        self._items[item.name] = item

    def remove(self, item):
        if item.parent != self:
            raise MicrotomeError("Item is not in this library [item=%s]" % str(item))
        item._parent = None
        del self._items[item.name]

    def clear(self):
        for item in self._items:
            item._parent = None
        self._items = {}

    def __len__(self):
        return len(self._items)

    def __getitem__(self, key):
        return self._items[key]

    def __setitem__(self, key, value):
        raise NotImplementedError("Use Library.add_item")

    def __delitem__(self, key):
        item = self._items.pop(key)
        item._parent = None

    def __iter__(self):
        return self._items.__iter__()

    def __reversed__(self):
        return self._items.__reversed__()

    def __contains__(self, item):
        return self._items.__contains__(item)

if __name__ == "__main__":
    lib = Library()
