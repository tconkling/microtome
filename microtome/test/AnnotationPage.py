
# GENERATED IMPORTS START
from microtome.core.prop import Prop
from microtome.core.prop import PropSpec
from microtome.page import Page
from microtome.test import PrimitivePage
# GENERATED IMPORTS END

class AnnotationPage(Page):
# GENERATED CONSTRUCTOR START
    def __init__(self, name):
        super(AnnotationPage, self).__init__(name)
        self._foo = Prop(self, AnnotationPage._s_fooSpec)
        self._bar = Prop(self, AnnotationPage._s_barSpec)
        self._primitives = Prop(self, AnnotationPage._s_primitivesSpec)
# GENERATED CONSTRUCTOR END

# GENERATED PROPS START
    @property
    def foo(self):
        return self._foo.value

    @property
    def bar(self):
        return self._bar.value

    @property
    def primitives(self):
        return self._primitives.value

    @property
    def props(self):
        return super(AnnotationPage, self).props + [self._foo, self._bar, self._primitives, ]
# GENERATED PROPS END

# GENERATED STATICS START
    _s_fooSpec = PropSpec("foo", {"min": 3.0, "max": 5.0}, [int, ])
    _s_barSpec = PropSpec("bar", {"default": 3.0}, [int, ])
    _s_primitivesSpec = PropSpec("primitives", {"nullable": True}, [PrimitivePage, ])
# GENERATED STATICS END
