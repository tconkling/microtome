#
# microtome

from microtome.core.item import LibraryItemBase
from microtome.core.type_info import TypeInfo
import microtome.core.defs as Defs

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

    def __str__(self):
        return "[name=%s, value_type=%s, value=%s]" % (self.name, self.value_type, str(self.value))

class PropAnnotation(object):
    def __init__(self, value):
        self._value = value

    def bool_value(self, default):
        return self._value if type(self._value) == bool else default

    def int_value(self, default):
        return int(self.number_value(default))

    def float_value(self, default):
        return float(self.number_value(default))

    def number_value(self, default):
        return self._value if isinstance(self._value, int) or isinstance(self._value, float) else default

    def string_value(self, default):
        return self._value if isinstance(self._value, basestring) else default

class PropSpec(object):
    def __init__(self, name, annotations, value_classes):
        self.name = name
        if annotations is not None:
            self._annotations = {item[0]: PropAnnotation(item[1]) for item in annotations.items()}
        else:
            self._annotations = PropSpec._EMPTY_DICT
        self.value_type = TypeInfo.from_classes(*value_classes) if value_classes else None

    def has_annotation(self, name):
        return name in self._annotations

    def get_annotation(self, name):
        anno = self._annotations.get(name, None)
        return anno if anno else PropSpec._NULL_ANNO

    _EMPTY_DICT = {}
    _NULL_ANNO = PropAnnotation(None)


if __name__ == "__main__":
    anno = PropAnnotation(u'Hello')
    print anno.int_value(55)
    print anno.bool_value(False)
    print anno.string_value("whoops")

    print PropSpec._NULL_ANNO

    spec = PropSpec("my prop", {"qwert": 3}, None)
    print spec._annotations
