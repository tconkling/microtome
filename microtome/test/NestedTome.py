# GENERATED IMPORTS START
from microtome.core.prop import Prop
from microtome.core.prop import PropSpec
from microtome.tome import Tome
# GENERATED IMPORTS END

# GENERATED CLASS_DECL START
class NestedTome(Tome):
# GENERATED CLASS_DECL END
# GENERATED CONSTRUCTOR START
    _s_inited = False
    def __init__(self, name):
        super(NestedTome, self).__init__(name)
        if not NestedTome._s_inited:
            NestedTome._s_inited = True
            NestedTome._s_nestedSpec = PropSpec("nested", None, [PrimitiveTome, ])

        self._nested = Prop(self, NestedTome._s_nestedSpec)
# GENERATED CONSTRUCTOR END

# GENERATED CLASS_BODY START
    @property
    def nested(self):
        return self._nested.value

    @nested.setter
    def nested(self, value):
        self._nested.value = value

    @property
    def props(self):
        return super(NestedTome, self).props + [self._nested, ]
# GENERATED CLASS_BODY END

# GENERATED POST-IMPORTS START
from microtome.test.PrimitiveTome import PrimitiveTome
# GENERATED POST-IMPORTS END
