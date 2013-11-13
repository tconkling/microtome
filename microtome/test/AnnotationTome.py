# GENERATED IMPORTS START
from microtome.core.prop import Prop
from microtome.core.prop import PropSpec
from microtome.tome import Tome
# GENERATED IMPORTS END

# GENERATED CLASS_DECL START
class AnnotationTome(Tome):
# GENERATED CLASS_DECL END
# GENERATED CONSTRUCTOR START
    _s_inited = False
    def __init__(self, name):
        super(AnnotationTome, self).__init__(name)
        if not AnnotationTome._s_inited:
            AnnotationTome._s_inited = True
            AnnotationTome._s_fooSpec = PropSpec("foo", {"min": 3.0, "max": 5.0}, [int, ])
            AnnotationTome._s_barSpec = PropSpec("bar", {"default": 3.0}, [int, ])
            AnnotationTome._s_primitivesSpec = PropSpec("primitives", {"nullable": True}, [PrimitiveTome, ])

        self._foo = Prop(self, AnnotationTome._s_fooSpec)
        self._bar = Prop(self, AnnotationTome._s_barSpec)
        self._primitives = Prop(self, AnnotationTome._s_primitivesSpec)
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
    def primitives(self):
        return self._primitives.value

    @primitives.setter
    def primitives(self, value):
        self._primitives.value = value

    @property
    def props(self):
        return super(AnnotationTome, self).props + [self._foo, self._bar, self._primitives, ]
# GENERATED PROPS END

# GENERATED POST-IMPORTS START
from microtome.test.PrimitiveTome import PrimitiveTome
# GENERATED POST-IMPORTS END
