# GENERATED IMPORTS START
from microtome.core.prop import Prop
from microtome.core.prop import PropSpec
from microtome.page import Page
# GENERATED IMPORTS END

# GENERATED CLASS_DECL START
class PrimitivePage(Page):
# GENERATED CLASS_DECL END
# GENERATED CONSTRUCTOR START
    _s_inited = False
    def __init__(self, name):
        super(PrimitivePage, self).__init__(name)
        if not PrimitivePage._s_inited:
            PrimitivePage._s_inited = True
            PrimitivePage._s_fooSpec = PropSpec("foo", None, [bool, ])
            PrimitivePage._s_barSpec = PropSpec("bar", None, [int, ])
            PrimitivePage._s_bazSpec = PropSpec("baz", None, [float, ])

        self._foo = Prop(self, PrimitivePage._s_fooSpec)
        self._bar = Prop(self, PrimitivePage._s_barSpec)
        self._baz = Prop(self, PrimitivePage._s_bazSpec)
# GENERATED CONSTRUCTOR END

# GENERATED PROPS START
    @property
    def foo(self):
        return self._foo.value

    @property
    def bar(self):
        return self._bar.value

    @property
    def baz(self):
        return self._baz.value

    @property
    def props(self):
        return super(PrimitivePage, self).props + [self._foo, self._bar, self._baz, ]
# GENERATED PROPS END
