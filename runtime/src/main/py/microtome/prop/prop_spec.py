#
# microtome

from microtome.core.type_info import TypeInfo

class PropAnnotation(object):
    def __init__(self, value):
        self._value = value

    def bool_value(self, default):
        return self._typed_value(bool, default)

    def int_value(self, default):
        return self._typed_value(int, default)

    def float_value(self, default):
        return self._typed_value(float, default)

    def string_value(self, default):
        return self._value if isinstance(self._value, basestring) else default

    def _typed_value(self, the_type, default):
        return self._value if type(self._value) == the_type else default

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
