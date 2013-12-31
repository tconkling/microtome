# GENERATED IMPORTS START
from microtome.core.prop import Prop
from microtome.core.prop import PropSpec
from microtome.tome import Tome
# GENERATED IMPORTS END

# GENERATED CLASS_DECL START
class ObjectTome(Tome):
# GENERATED CLASS_DECL END
# GENERATED CONSTRUCTOR START
    _s_inited = False
    def __init__(self, name):
        super(ObjectTome, self).__init__(name)
        if not ObjectTome._s_inited:
            ObjectTome._s_inited = True
            ObjectTome._s_fooSpec = PropSpec("foo", None, [str, ])

        self._foo = Prop(self, ObjectTome._s_fooSpec)
# GENERATED CONSTRUCTOR END

# GENERATED CLASS_BODY START
    @property
    def foo(self):
        return self._foo.value

    @foo.setter
    def foo(self, value):
        self._foo.value = value

    @property
    def props(self):
        return super(ObjectTome, self).props + [self._foo, ]
# GENERATED CLASS_BODY END

# GENERATED POST-IMPORTS START
# GENERATED POST-IMPORTS END
