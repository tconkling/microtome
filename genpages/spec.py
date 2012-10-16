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
EnumType =      "Enum"
ListType =      "List"
PageType =      "Page"
PageRefType =   "PageRef"
TomeType =      "Tome"

PRIMITIVE_TYPES = set([ BoolType, IntType, FloatType ])
PARAMETERIZED_TYPES = set([ EnumType, ListType, PageType, PageRefType, TomeType ])
ALL_TYPES = set([ EnumType, BoolType, IntType, FloatType, StringType, ListType, PageType, PageRefType, TomeType ])
