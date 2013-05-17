#
# microtome

from core.item import LibraryItem, LibraryItemBase
from core.type_info import TypeInfo
import util.util

_EMPTY_LIST = []

class Page(LibraryItemBase):
    def __init__(self, name):
        LibraryItemBase.__init__(self, name)
        self._type_info = None

    @property
    def type_info(self):
        if self._type_info is None:
            self._type_info = TypeInfo(self.__class__, None)
        return self._type_info

    @property
    def children(self):
        return [prop for prop in self.props if isinstance(prop, LibraryItem)]

    def child_named(self, name):
        prop = util.util.get_prop(self, name)
        return prop

    @property
    def props(self):
        return _EMPTY_LIST

    def __str__(self):
        return self.__class__.__name__ + ":'" + self._name + "'"


if __name__ == "__main__":
    page = Page("asdf")
    print page.child_named("test")
