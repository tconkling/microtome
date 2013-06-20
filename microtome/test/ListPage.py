# GENERATED IMPORTS START
from microtome.core.prop import Prop
from microtome.core.prop import PropSpec
from microtome.page import Page
from microtome.test.PrimitivePage import PrimitivePage
# GENERATED IMPORTS END

class ListPage(Page):# GENERATED CONSTRUCTOR START
    _s_inited = False
    def __init__(self, name):
        super(ListPage, self).__init__(name)
        if not ListPage._s_inited:
            ListPage._s_inited = True
            ListPage._s_kidsSpec = PropSpec("kids", None, [list, PrimitivePage, ])

        self._kids = Prop(self, ListPage._s_kidsSpec)
# GENERATED CONSTRUCTOR END

# GENERATED PROPS START
    @property
    def kids(self):
        return self._kids.value

    @property
    def props(self):
        return super(ListPage, self).props + [self._kids, ]
# GENERATED PROPS END

# GENERATED CLASS_DECL START
class ListPage(Page):
# GENERATED CLASS_DECL END
