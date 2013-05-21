#
# microtome

import microtome.core.defs as Defs
from microtome.error import MicrotomeError
from microtome.core.item import MicrotomeItem, LibraryItem

class Library(MicrotomeItem):
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

    @property
    def children(self):
        return self._items.values()

    def get_item_with_qualified_name(self, qualified_name):
        # A qualifiedName is a series of page and tome names, separated by dots
        # E.g. level1.baddies.big_boss
        item = None
        for name in qualified_name.split(Defs.NAME_SEPARATOR):
            item = item.child_named(name) if item is not None else self._items.get(name, None)
            if not isinstance(item, LibraryItem):
                return None
        return item

    def get_item(self, name):
        return self._items.get(name, None)

    def has_item(self, name):
        return name in self._items

    def add_item(self, item):
        if self.has_item(item.name):
            raise MicrotomeError("An item with that name already exists [name=%s]" % item.name)
        elif item.parent is not None:
            raise MicrotomeError("Item is already in a library [item=%s]" % str(item))

        item._parent = self
        self._items[item.name] = item

    def remove_item(self, item):
        if item.parent != self:
            raise MicrotomeError("Item is not in this library [item=%s]" % str(item))
        item._parent = None
        del self._items[item.name]

    def remove_all_items(self):
        for item in self._items:
            item._parent = None
        self._items = {}
