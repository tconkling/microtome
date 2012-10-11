#
# microtome - Tim Conkling, 2012

from collections import namedtuple

PageSpec = namedtuple("PageSpec", ["name", "superclass", "props", "pos"])
PropSpec = namedtuple("PropSpec", ["type", "name", "attrs", "pos"])
AttrSpec = namedtuple("AttrSpec", ["name", "value", "pos"])
TypeSpec = namedtuple("TypeSpec", ["type", "subtype"])

Type = namedtuple("Type", ["name", "is_primitive", "has_subtype"])

BoolType =      Type(name = "bool", is_primitive = True, has_subtype = False)
IntType =       Type(name = "int", is_primitive = True, has_subtype = False)
FloatType =     Type(name = "float", is_primitive = True, has_subtype = False)
StringType =    Type(name = "string", is_primitive = False, has_subtype = False)
PageRefType =   Type(name = "PageRef", is_primitive = False, has_subtype = True)
TomeType =      Type(name = "Tome", is_primitive = False, has_subtype = True)

def typeDictionary (*types):
    theDict = {}
    for theType in types:
        theDict[theType.name] = theType
    return theDict

BASE_TYPES = typeDictionary(BoolType, IntType, FloatType, StringType, PageRefType, TomeType)
