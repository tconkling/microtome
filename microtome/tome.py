#
# microtome

from microtome.core.item import LibraryItemBase
from microtome.core.type_info import TypeInfo
from microtome.error import MicrotomeError

class Tome(LibraryItemBase):
    def __init__(self, name, page_class):
        LibraryItemBase.__init__(self, name)
        self._type_info = TypeInfo.from_classes(Tome, page_class)
        self._pages = {}

    @property
    def type_info(self):
        return self._type_info

    @property
    def page_class(self):
        return self._type_info.subtype.clazz

    def add_page(self, page):
        if not isinstance(page, self.page_class):
            raise MicrotomeError("Incorrect page type [required=%s, got=%s]" %
                                (str(self.page_class), str(page.__class__)))

        page._parent = self
        self._pages[page.name] = page

    def remove_page(self, page):
        if page.parent != self:
            raise MicrotomeError("Page is not in the Tome [page=%s]" % str(page))
        page._parent = None
        del self._pages[page.name]

    def __iter__(self):
        return self._pages.__iter__()

    def __len__(self):
        return self._pages.__len__()

    def __contains__(self, key):
        return self._pages.__contains__(key)

    def __getitem__(self, key):
        return self._pages.__getitem__(key)

    def __str__(self):
        return "Tome<%s>:'%s'" % (self.page_class.__name__, self._name)

if __name__ == "__main__":
    Tome("qwert", int)
