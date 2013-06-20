# GENERATED IMPORTS START
from microtome.core.prop import Prop
from microtome.core.prop import PropSpec
from microtome.page import Page
# GENERATED IMPORTS END

# GENERATED CLASS_DECL START
class PrimitiveListPage(Page):
# GENERATED CLASS_DECL END
# GENERATED CONSTRUCTOR START
    _s_inited = False
    def __init__(self, name):
        super(PrimitiveListPage, self).__init__(name)
        if not PrimitiveListPage._s_inited:
            PrimitiveListPage._s_inited = True
            PrimitiveListPage._s_stringsSpec = PropSpec("strings", None, [list, str, ])
            PrimitiveListPage._s_booleansSpec = PropSpec("booleans", None, [list, bool, ])
            PrimitiveListPage._s_intsSpec = PropSpec("ints", None, [list, int, ])
            PrimitiveListPage._s_floatsSpec = PropSpec("floats", None, [list, float, ])

        self._strings = Prop(self, PrimitiveListPage._s_stringsSpec)
        self._booleans = Prop(self, PrimitiveListPage._s_booleansSpec)
        self._ints = Prop(self, PrimitiveListPage._s_intsSpec)
        self._floats = Prop(self, PrimitiveListPage._s_floatsSpec)
# GENERATED CONSTRUCTOR END

# GENERATED PROPS START
    @property
    def strings(self):
        return self._strings.value

    @property
    def booleans(self):
        return self._booleans.value

    @property
    def ints(self):
        return self._ints.value

    @property
    def floats(self):
        return self._floats.value

    @property
    def props(self):
        return super(PrimitiveListPage, self).props + [self._strings, self._booleans, self._ints, self._floats, ]
# GENERATED PROPS END
