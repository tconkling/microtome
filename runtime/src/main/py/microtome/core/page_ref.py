#
# microtome

from microtome.error import ResolveRefError

class PageRef(object):
    @classmethod
    def from_page(cls, page):
        ref = PageRef(page.qualified_name)
        ref._page = page
        return ref

    def __init__(self, page_name):
        self._page_name = page_name
        self._page = None

    @property
    def page_name(self):
        return self._page_name

    @property
    def page(self):
        return self._page if self._page is not None and self._page.library is not None else None

    def resolve(self, library, page_class):
        item = library.get_item_with_qualified_name(self._page_name)
        if item is None:
            raise ResolveRefError("No such item [name=%s]", self._page_name)
        elif not isinstance(item, page_class):
            raise ResolveRefError("Wrong page type [name=%s, expectedType=%s, actualType=%s" %
                                 (self._page_name, str(page_class), str(item.__class__)))
        self._page = item

    def clone(self):
        out = PageRef(self._page_name)
        out._page = self._page
        return out
