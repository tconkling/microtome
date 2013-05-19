#
# microtome

import logging

from ..ctx import MicrotomeCtx
from marshaller.bool_marshaller import BoolMarshaller
from marshaller.int_marshaller import IntMarshaller

class MicrotomeMgr(MicrotomeCtx):
    def __init__(self):
        self._data_marshallers = {}
        self._page_classes = {}
        self.register_data_marshaller(BoolMarshaller())
        self.register_data_marshaller(IntMarshaller())

    def register_page_classes(self, classes):
        raise NotImplementedError()

    def register_data_marshaller(self, marshaller):
        raise NotImplementedError()

    def load(self, library, data):
        raise NotImplementedError()

    def write(self, item, writer):
        raise NotImplementedError()

    def clone(self, item):
        raise NotImplementedError()
