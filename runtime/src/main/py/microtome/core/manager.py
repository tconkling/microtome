#
# microtome

import logging

from ctx import MicrotomeCtx

class MicrotomeMgr(MicrotomeCtx):
    def __init__(self):
        pass

    def registerPageClasses(self, classes):
        raise NotImplementedError()

    def registerDataMarshaller(self, marshaller):
        raise NotImplementedError()

    def load(self, library, data):
        raise NotImplementedError()

    def write(self, item, writer):
        raise NotImplementedError()

    def clone(self, item):
        raise NotImplementedError()
