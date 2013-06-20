# GENERATED IMPORTS START
from microtome.core.prop import Prop
from microtome.core.prop import PropSpec
from microtome.page import Page
# GENERATED IMPORTS END

class ObjectPage(Page):# GENERATED CONSTRUCTOR START
    _s_inited = False
    def __init__(self, name):
        super(ObjectPage, self).__init__(name)
        if not ObjectPage._s_inited:
            ObjectPage._s_inited = True
            ObjectPage._s_fooSpec = PropSpec("foo", None, [str, ])

        self._foo = Prop(self, ObjectPage._s_fooSpec)
# GENERATED CONSTRUCTOR END

# GENERATED PROPS START
    @property
    def foo(self):
        return self._foo.value

    @property
    def props(self):
        return super(ObjectPage, self).props + [self._foo, ]
# GENERATED PROPS END

# GENERATED CLASS_DECL START
class ObjectPage(Page):
# GENERATED CLASS_DECL END
