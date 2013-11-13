#
# microtome

from microtome.error import ResolveRefError

class TomeRef(object):
    @classmethod
    def from_tome(cls, tome):
        ref = TomeRef(tome.qualified_name)
        ref._tome = tome
        return ref

    def __init__(self, tome_name):
        self._tome_name = tome_name
        self._tome = None

    @property
    def tome_name(self):
        return self._tome_name

    @property
    def tome(self):
        return self._tome if self._tome is not None and self._tome.library is not None else None

    def resolve(self, library, tome_class):
        item = library.get_tome_with_qualified_name(self._tome_name)
        if item is None:
            raise ResolveRefError("No such item [name=%s]" % self._tome_name)
        elif not isinstance(item, tome_class):
            raise ResolveRefError("Wrong tome type [name=%s, expectedType=%s, actualType=%s" %
                                 (self._tome_name, str(tome_class), str(item.__class__)))
        self._tome = item

    def clone(self):
        out = TomeRef(self._tome_name)
        out._tome = self._tome
        return out
