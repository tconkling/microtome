
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

# GENERATED STATICS START
    _s_kidsSpec = PropSpec("kids", None, [list, PrimitivePage, ])
# GENERATED STATICS END
