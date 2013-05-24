#
# microtome

from microtome.core.item import LibraryItem, LibraryItemBase
from microtome.core.type_info import TypeInfo

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
    def props(self):
        return _EMPTY_LIST

    def __len__(self):
        return len(self.props)

    def __iter__(self):
        return self._children.__iter__()

    def __contains__(self, val):
        return self._children.__contains(val)

    def __str__(self):
        return self.__class__.__name__ + ":'" + self._name + "'"

    @property
    def _children(self):
        return [prop for prop in self.props if isinstance(prop, LibraryItem)]


if __name__ == "__main__":
    page = Page("asdf")
