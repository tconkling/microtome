# GENERATED IMPORTS START
from microtome.core.prop import Prop
from microtome.core.prop import PropSpec
from microtome.tome import Tome
# GENERATED IMPORTS END

# GENERATED CLASS_DECL START
class RefTome(Tome):
# GENERATED CLASS_DECL END
# GENERATED CONSTRUCTOR START
    _s_inited = False
    def __init__(self, name):
        super(RefTome, self).__init__(name)
        if not RefTome._s_inited:
            RefTome._s_inited = True
            RefTome._s_nestedSpec = PropSpec("nested", None, [TomeRef, PrimitiveTome, ])

        self._nested = Prop(self, RefTome._s_nestedSpec)
# GENERATED CONSTRUCTOR END

# GENERATED PROPS START
    @property
    def nested(self):
        return self._nested.value.tome if self._nested.value is not None else None

    @nested.setter
    def nested(self, value):
        self._nested.value = TomeRef.from_tome(value) if value is not None else None

    @property
    def props(self):
        return super(RefTome, self).props + [self._nested, ]
# GENERATED PROPS END

# GENERATED POST-IMPORTS START
from microtome.core.tome_ref import TomeRef
from microtome.test.PrimitiveTome import PrimitiveTome
# GENERATED POST-IMPORTS END
