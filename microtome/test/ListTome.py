# GENERATED IMPORTS START
from microtome.core.prop import Prop
from microtome.core.prop import PropSpec
from microtome.tome import Tome
# GENERATED IMPORTS END

# GENERATED CLASS_DECL START
class ListTome(Tome):
# GENERATED CLASS_DECL END
# GENERATED CONSTRUCTOR START
    _s_inited = False
    def __init__(self, name):
        super(ListTome, self).__init__(name)
        if not ListTome._s_inited:
            ListTome._s_inited = True
            ListTome._s_kidsSpec = PropSpec("kids", None, [list, PrimitiveTome, ])

        self._kids = Prop(self, ListTome._s_kidsSpec)
# GENERATED CONSTRUCTOR END

# GENERATED CLASS_BODY START
    @property
    def kids(self):
        return self._kids.value

    @kids.setter
    def kids(self, value):
        self._kids.value = value

    @property
    def props(self):
        return super(ListTome, self).props + [self._kids, ]
# GENERATED CLASS_BODY END

# GENERATED POST-IMPORTS START
from microtome.test.PrimitiveTome import PrimitiveTome
# GENERATED POST-IMPORTS END
