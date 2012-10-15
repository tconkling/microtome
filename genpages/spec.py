#
# microtome - Tim Conkling, 2012

'''
'''

from collections import namedtuple

PageSpec = namedtuple("PageSpec", ["name", "superclass", "props", "pos"])
PropSpec = namedtuple("PropSpec", ["type", "name", "attrs", "pos"])
AttrSpec = namedtuple("AttrSpec", ["name", "value", "pos"])
TypeSpec = namedtuple("TypeSpec", ["name", "subtype"])

BoolType =      "bool"
IntType =       "int"
FloatType =     "float"
StringType =    "string"
PageType =      "Page"
PageRefType =   "PageRef"
TomeType =      "Tome"

PRIMITIVE_TYPES = set([ BoolType, IntType, FloatType ])
PARAMETERIZED_TYPES = set([ PageType, PageRefType, TomeType ])
ALL_TYPES = set([ BoolType, IntType, FloatType, StringType, PageType, PageRefType, TomeType ])
