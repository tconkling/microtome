
# GENERATED IMPORTS START
from microtome.core.page_ref import PageRef
from microtome.core.prop import Prop
from microtome.core.prop import PropSpec
from microtome.page import Page
from microtome.test import PrimitivePage
# GENERATED IMPORTS END

class RefPage(Page):
# GENERATED CONSTRUCTOR START
    def __init__(self, name):
        super(RefPage, self).__init__(name)
        self._nested = Prop(self, RefPage._s_nestedSpec)
# GENERATED CONSTRUCTOR END

# GENERATED PROPS START
    @property
    def nested(self):
        return self._nested.value.page if self._nested.value is not None else None

    @property
    def props(self):
        return super(RefPage, self).props + [self._nested, ]
# GENERATED PROPS END

# GENERATED STATICS START
    _s_nestedSpec = PropSpec("nested", None, [PageRef, PrimitivePage, ])
# GENERATED STATICS END