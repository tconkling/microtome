#
# microtome

from microtome.page import Page
from microtome.prop.prop_spec import PropSpec
from microtome.prop.prop import Prop

class PrimitivePage(Page):
    def __init__(self, name):
        super(PrimitivePage, self).__init__(name)
        self._foo = Prop(self, PrimitivePage._s_fooSpec)
        self._bar = Prop(self, PrimitivePage._s_barSpec)
        self._baz = Prop(self, PrimitivePage._s_bazSpec)

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
        return super(PrimitivePage, self).props + [self._foo, self._bar, self._baz]

    _s_fooSpec = PropSpec("foo", None, [bool, ])
    _s_barSpec = PropSpec("bar", None, [int, ])
    _s_bazSpec = PropSpec("baz", None, [float, ])
