#
# microtome - Tim Conkling, 2012

'''

'''

from collections import namedtuple

PageSpec = namedtuple("PageSpec", ["name", "superclass", "props", "pos"])
PropSpec = namedtuple("PropSpec", ["type", "name", "attrs", "pos"])
AttrSpec = namedtuple("AttrSpec", ["name", "value", "pos"])
TypeSpec = namedtuple("TypeSpec", ["type", "subtype"])

Type = namedtuple("Type", ["name", "is_primitive", "has_subtype"])

BoolType =      Type(name = "BoolType", is_primitive = True, has_subtype = False)
IntType =       Type(name = "IntType", is_primitive = True, has_subtype = False)
FloatType =     Type(name = "FloatType", is_primitive = True, has_subtype = False)
StringType =    Type(name = "StringType", is_primitive = False, has_subtype = False)
PageRefType =   Type(name = "PageRefType", is_primitive = False, has_subtype = True)
TomeType =      Type(name = "TomeType", is_primitive = False, has_subtype = True)

def type_dict (*types):
    the_dict = {}
    for the_type in types:
        the_dict[the_type.name] = the_type
    return the_dict

BASE_TYPES = type_dict(BoolType, IntType, FloatType, StringType, PageRefType, TomeType)
