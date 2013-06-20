# GENERATED IMPORTS START
from microtome.core.prop import Prop
from microtome.core.prop import PropSpec
from microtome.page import Page
from microtome.test.PrimitivePage import PrimitivePage
# GENERATED IMPORTS END

class NestedPage(Page):# GENERATED CONSTRUCTOR START
    _s_inited = False
    def __init__(self, name):
        super(NestedPage, self).__init__(name)
        if not NestedPage._s_inited:
            NestedPage._s_inited = True
            NestedPage._s_nestedSpec = PropSpec("nested", None, [PrimitivePage, ])

        self._nested = Prop(self, NestedPage._s_nestedSpec)
# GENERATED CONSTRUCTOR END

# GENERATED PROPS START
    @property
    def nested(self):
        return self._nested.value

    @property
    def props(self):
        return super(NestedPage, self).props + [self._nested, ]
# GENERATED PROPS END

# GENERATED CLASS_DECL START
class NestedPage(Page):
# GENERATED CLASS_DECL END
