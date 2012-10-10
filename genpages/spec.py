#
# spec.py

from collections import namedtuple

Page = namedtuple("Page", ["name", "superclass", "props", "pos"])
Prop = namedtuple("Prop", ["type", "subtype", "name", "attrs", "pos"])
Attr = namedtuple("Attr", ["name", "value", "pos"])
