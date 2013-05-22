#
# microtome

from abc import ABCMeta, abstractmethod


def create_ctx():
    import microtome.core.manager
    return microtome.core.manager.MicrotomeMgr()


class MicrotomeCtx(object):
    __metaclass__ = ABCMeta

    @abstractmethod
    def register_page_classes(self, classes):
        pass

    @abstractmethod
    def register_data_marshallers(self, marshallers):
        pass

    @abstractmethod
    def load(self, library, readable_objects):
        pass

    @abstractmethod
    def write(self, item, writer):
        pass

    @abstractmethod
    def clone(self, item):
        return None
