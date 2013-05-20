#
# microtome

from core.item import MicrotomeItem, LibraryItem
import core.defs as Defs

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

if __name__ == "__main__":
    print str(isinstance(None, Library))
