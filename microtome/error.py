#
# microtome

import traceback
import re
import sys

def ancestor_class_depth(base_clazz, clazz, depth=0):
    '''returns the depth of the ancestry tree from base_clazz to clazz, or -1 if base_clazz
    is not a superclass of clazz'''
    if clazz is base_clazz:
        return depth
    elif clazz is not object:
        for base in clazz.__bases__:
            base_depth = ancestor_class_depth(base_clazz, base, depth+1)
            if base_depth >= 0:
                return base_depth
    return -1

class ChainableError(Exception):
    def __init__(self, *args, **kwargs):
        if len(args) == 1 and not kwargs and isinstance(args[0], Exception):
            # we shall just wrap a non-caused exception
            self.stack = (
                traceback.format_stack()[:-2] +
                traceback.format_tb(sys.exc_info()[2]))
            # ^^^ let's hope the information is still there; caller must take
            #     care of this.
            self.wrapped = args[0]
            self.cause = ()
            super(ChainableError, self).__init__(repr(args[0]))
            # ^^^ to display what it is wrapping, in case it gets printed or similar
            return

        self.wrapped = None
        # cut off frames we don't care about
        class_depth = max(ancestor_class_depth(ChainableError, self.__class__), 0)
        self.stack = traceback.format_stack()[:-(class_depth+1)]

        try:
            cause = kwargs['cause']
            del kwargs['cause']
        except:
            cause = ()

        if isinstance(cause, Exception) and not isinstance(cause, ChainableError):
            cause = ChainableError(cause)
        self.cause = cause if isinstance(cause, tuple) else (cause,)
        super(ChainableError, self).__init__(*args, **kwargs)

    @property
    def stacktrace(self):
        return "".join([line for line in self._causeTree()])

    def _causeTree(self, indentation='  ', alreadyMentionedTree=[]):
        yield "Traceback (most recent call last):\n"
        ellipsed = 0
        for i, line in enumerate(self.stack):
            if (ellipsed is not False and i < len(alreadyMentionedTree) and line == alreadyMentionedTree[i]):
                ellipsed += 1
            else:
                if ellipsed:
                    yield "  ... (%d frame%s repeated)\n" % (
                        ellipsed, "" if ellipsed == 1 else "s")
                    ellipsed = False  # marker for "given out"
                yield line
        exc = self if self.wrapped is None else self.wrapped
        for line in traceback.format_exception_only(exc.__class__, exc):
            yield line
        if self.cause:
            yield ("caused by: %d exception%s\n" % (len(self.cause), "" if len(self.cause) == 1 else "s"))
            for causePart in self.cause:
                for line in causePart._causeTree(indentation, self.stack):
                    yield re.sub(r'([^\n]*\n)', indentation + r'\1', line)


class MicrotomeError(ChainableError):
    def __init__(self, message, **kwargs):
        super(MicrotomeError, self).__init__(message, **kwargs)


class ValidationError(MicrotomeError):
    def __init__(self, prop, message, **kwargs):
        message = "Error validating '%s': %s" % (prop.name, message)
        super(ValidationError, self).__init__(message, **kwargs)


class LoadError(MicrotomeError):
    def __init__(self, bad_obj, msg, **kwargs):
        if bad_obj is not None:
            msg += "\ndata: " + bad_obj.debug_description
        super(LoadError, self).__init__(msg, **kwargs)


class ResolveRefError(MicrotomeError):
    def __init__(self, message, **kwargs):
        super(ResolveRefError, self).__init__(message, **kwargs)
