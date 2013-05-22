#
# microtome

from microtome.page import Page
from microtome.core.prop import Prop, PropSpec
from primitive_page import PrimitivePage
import types

class AnnotationPage(Page):
    def __init__(self, name):
        super(AnnotationPage, self).__init__(name)
        self._foo = Prop(self, AnnotationPage._s_fooSpec)
        self._bar = Prop(self, AnnotationPage._s_barSpec)
        self._primitives = Prop(self, AnnotationPage._s_primitivesSpec)

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
        return super(AnnotationPage, self).props + [self._foo, self._bar, self._primitives]

    _s_fooSpec = PropSpec("foo", {"min": 3.0, "max": 5.0}, [types.IntType, ])
    _s_barSpec = PropSpec("bar", {"default": 3.0}, [types.IntType, ])
    _s_primitivesSpec = PropSpec("primitives", {"nullable": True}, [PrimitivePage, ])

if __name__ == "__main__":
    print AnnotationPage._s_barSpec._annotations
