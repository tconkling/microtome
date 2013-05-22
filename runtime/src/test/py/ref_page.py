#
# microtome

from microtome.page import Page
from microtome.core.prop import Prop, PropSpec
from microtome.core.page_ref import PageRef
from primitive_page import PrimitivePage

class RefPage(Page):
    def __init__(self, name):
        super(RefPage, self).__init__(name)
        self._nested = Prop(self, RefPage._s_nestedSpec)

    @property
    def nested(self):
        return self._nested.value.page if self._nested.value is not None else None

    @property
    def props(self):
        return super(RefPage, self).props + [self._nested]

    _s_nestedSpec = PropSpec("nested", None, [PageRef, PrimitivePage, ])
