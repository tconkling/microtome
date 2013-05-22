#
# microtome

from microtome.page import Page
from microtome.prop.prop_spec import PropSpec
from microtome.prop.prop import Prop
from primitive_page import PrimitivePage
import types

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
