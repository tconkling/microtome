# GENERATED IMPORTS START
from microtome.core.prop import Prop
from microtome.core.prop import PropSpec
from microtome.tome import Tome
# GENERATED IMPORTS END

# GENERATED CLASS_DECL START
class PrimitiveTome(Tome):
# GENERATED CLASS_DECL END
# GENERATED CONSTRUCTOR START
    _s_inited = False
    def __init__(self, name):
        super(PrimitiveTome, self).__init__(name)
        if not PrimitiveTome._s_inited:
            PrimitiveTome._s_inited = True
            PrimitiveTome._s_fooSpec = PropSpec("foo", None, [bool, ])
            PrimitiveTome._s_barSpec = PropSpec("bar", None, [int, ])
            PrimitiveTome._s_bazSpec = PropSpec("baz", None, [float, ])

        self._foo = Prop(self, PrimitiveTome._s_fooSpec)
        self._bar = Prop(self, PrimitiveTome._s_barSpec)
        self._baz = Prop(self, PrimitiveTome._s_bazSpec)
# GENERATED CONSTRUCTOR END

# GENERATED PROPS START
    @property
    def foo(self):
        return self._foo.value

    @foo.setter
    def foo(self, value):
        self._foo.value = value

    @property
    def bar(self):
        return self._bar.value

    @bar.setter
    def bar(self, value):
        self._bar.value = value

    @property
    def baz(self):
        return self._baz.value

    @baz.setter
    def baz(self, value):
        self._baz.value = value

    @property
    def props(self):
        return super(PrimitiveTome, self).props + [self._foo, self._bar, self._baz, ]
# GENERATED PROPS END

# GENERATED POST-IMPORTS START
# GENERATED POST-IMPORTS END
