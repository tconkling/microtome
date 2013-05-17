#
# microtome

from core.item import LibraryItemBase
from prop_spec import PropSpec
import core.defs as Defs

class Prop(object):
    def __init__(self, page, spec):
        self._page = page
        self._spec = spec
        self._value = None

    @property
    def value(self):
        return self._value

    @value.setter
    def value(self, val):
        if self._value == val:
            return

        if isinstance(self._value, LibraryItemBase):
            self._value._parent = None
        self._value = val
        if isinstance(self._value, LibraryItemBase):
            self._value._parent = self._page

    @property
    def value_type(self):
        return self._spec.value_type

    @property
    def nullable(self):
        return self.annotation(Defs.NULLABLE_ANNOTATION).bool_value(False)

    @property
    def has_default(self):
        return self.has_annotation(Defs.DEFAULT_ANNOTATION)

    @property
    def name(self):
        return self._spec.name

    def has_annotation(self, name):
        return self._spec.has_annotation(name)

    def annotation(self, name):
        return self._spec.get_annotation(name)
