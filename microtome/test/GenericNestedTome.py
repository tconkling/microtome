# GENERATED IMPORTS START
from microtome.core.prop import Prop
from microtome.core.prop import PropSpec
from microtome.tome import Tome
# GENERATED IMPORTS END

# GENERATED CLASS_DECL START
class GenericNestedTome(Tome):
# GENERATED CLASS_DECL END
# GENERATED CONSTRUCTOR START
    _s_inited = False
    def __init__(self, name):
        super(GenericNestedTome, self).__init__(name)
        if not GenericNestedTome._s_inited:
            GenericNestedTome._s_inited = True
            GenericNestedTome._s_genericSpec = PropSpec("generic", None, [Tome, ])

        self._generic = Prop(self, GenericNestedTome._s_genericSpec)
# GENERATED CONSTRUCTOR END

# GENERATED CLASS_BODY START
    @property
    def generic(self):
        return self._generic.value

    @generic.setter
    def generic(self, value):
        self._generic.value = value

    @property
    def props(self):
        return super(GenericNestedTome, self).props + [self._generic, ]
# GENERATED CLASS_BODY END

# GENERATED POST-IMPORTS START
from microtome.tome import Tome
# GENERATED POST-IMPORTS END
