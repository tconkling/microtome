#
# microtome

class TypeInfo(object):
    @classmethod
    def from_classes(cls, *classes):
        last = None
        for ii in reversed(range(len(classes))):
            clazz = classes[ii]
            last = cls(clazz, last)
        return last

    def __init__(self, clazz, subtype):
        self._clazz = clazz
        self._subtype = subtype

    @property
    def clazz(self):
        return self._clazz

    @property
    def subtype(self):
        return self._subtype

    def __str__(self):
        return "TypeInfo: " + self._tostring()

    def _tostring(self):
        out = self._clazz.__name__
        if self._subtype is not None:
            out += "<" + self._subtype._tostring() + ">"
        return out


if __name__ == "__main__":
    info = TypeInfo.from_classes(list, int, bool)
    print str(info)
