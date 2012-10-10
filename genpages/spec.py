from collections import namedtuple

Page = namedtuple("Page", ["name", "superclass", "props"])
Prop = namedtuple("Prop", ["type", "subtype", "name", "attrs"])
Attr = namedtuple("Attr", ["name", "value"])
