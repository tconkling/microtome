
# GENERATED IMPORTS START
from microtome.core.prop import Prop
from microtome.core.prop import PropSpec
from microtome.page import Page
from microtome.test.PrimitivePage import PrimitivePage
# GENERATED IMPORTS END

class ListPage(Page):
# GENERATED CONSTRUCTOR START
    def __init__(self, name):
        super(ListPage, self).__init__(name)
        self._list = Prop(self, ListPage._s_listSpec)
# GENERATED CONSTRUCTOR END

# GENERATED PROPS START
    @property
    def list(self):
        return self._list.value

    @property
    def props(self):
        return super(ListPage, self).props + [self._list, ]
# GENERATED PROPS END

# GENERATED STATICS START
    _s_listSpec = PropSpec("list", None, [list, PrimitivePage, ])
# GENERATED STATICS END
