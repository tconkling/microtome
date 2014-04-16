#
# microtome

from microtome.error import ResolveRefError

class TomeRef(object):
    @classmethod
    def from_tome(cls, tome):
        ref = TomeRef(tome.id)
        ref._tome = tome
        return ref

    def __init__(self, tome_id):
        self._tome_id = tome_id
        self._tome = None

    @property
    def tome_id(self):
        return self._tome_id

    @property
    def tome(self):
        return self._tome if self._tome is not None and self._tome.library is not None else None

    def resolve(self, library, tome_class):
        item = library.get_tome(self._tome_id)
        if item is None:
            raise ResolveRefError("No such Tome [id=%s]" % self._tome_id)
        elif not isinstance(item, tome_class):
            raise ResolveRefError("Wrong tome type [id=%s, expectedType=%s, actualType=%s" %
                                 (self._tome_id, str(tome_class), str(item.__class__)))
        self._tome = item

    def clone(self):
        out = TomeRef(self._tome_id)
        out._tome = self._tome
        return out
