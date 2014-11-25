#
# microtome - Tim Conkling, 2012

'''
'''

from collections import namedtuple

import microtome.core.defs as Defs

LibrarySpec =       namedtuple("LibrarySpec", ["namespace", "header_text", "tomes"])
TomeSpec =          namedtuple("TomeSpec", ["name", "superclass", "namespace", "props", "pos"])
PropSpec =          namedtuple("PropSpec", ["type", "name", "annotations", "pos"])
AnnotationSpec =    namedtuple("AnnotationSpec", ["name", "value", "pos"])
TypeSpec =          namedtuple("TypeSpec", ["name", "subtype"])

BoolType =      "bool"
IntType =       "int"
FloatType =     "float"
StringType =    "string"
ListType =      "List"
TomeRefType =   "TomeRef"
TomeType =      "Tome"

PRIMITIVE_TYPES = {BoolType, IntType, FloatType}
PARAMETERIZED_TYPES = {ListType, TomeRefType}
ALL_TYPES = {BoolType, IntType, FloatType, StringType, ListType, TomeRefType, TomeType}

# cannot be used as variable names
RESERVED_NAMES = {Defs.TOME_TYPE_ATTR, Defs.TEMPLATE_ATTR, "props", "name", "id", "library", "parent", "children"}


def type_spec_to_list(type_spec):
    '''returns a flat list of the types in a TypeSpec's type chain'''
    out = [type_spec.name]
    if type_spec.subtype:
        out += type_spec_to_list(type_spec.subtype)
    return out
