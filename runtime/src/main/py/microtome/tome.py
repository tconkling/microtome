#
# microtome

from core.item import LibraryItemBase
from core.type_info import TypeInfo
from error import MicrotomeError

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

    @property
    def children(self):
        return self._pages.values()

    def child_named(self, name):
        return self.get_page(name)

    def has_page(self, name):
        return name in self._pages

    def get_page(self, name):
        return self._pages.get(name, None)

    def require_page(self, name):
        page = self.get_page(name)
        if page is None:
            raise MicrotomeError("Missing required page [name='%s']" % name)
        return page

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

    def __len__(self):
        return len(self._pages)
