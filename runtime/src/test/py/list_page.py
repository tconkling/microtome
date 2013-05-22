#
# microtome

import types

from microtome.page import Page
from microtome.core.prop import Prop, PropSpec
from primitive_page import PrimitivePage

class ListPage(Page):
    def __init__(self, name):
        super(ListPage, self).__init__(name)
        self._kids = Prop(self, ListPage._s_kidsSpec)

    @property
    def kids(self):
        return self._kids.value

    @property
    def props(self):
        return super(ListPage, self).props + [self._kids]

    _s_kidsSpec = PropSpec("kids", None, [types.ListType, PrimitivePage])
