#
# microtome

class MicrotomeError(Exception):
    def __init__(self, message):
        self.message = message

    def __str__(self):
        return self.message


class ValidationError(MicrotomeError):
    def __init__(self, prop, message):
        MicrotomeError.__init__(self, "Error validating '" + prop.name + "': " + message)


class LoadError(MicrotomeError):
    def __init__(self, bad_obj, msg):
        if bad_obj is not None:
            msg += "\ndata: " + bad_obj.debug_description
        MicrotomeError.__init__(self, msg)


class ResolveRefError(MicrotomeError):
    def __init__(self, message):
        MicrotomeError.__init__(self, message)
