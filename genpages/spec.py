#
# microtome - Tim Conkling, 2012

'''
'''

from collections import namedtuple

LibrarySpec =       namedtuple("LibrarySpec", ["namespace", "header_text", "pages"])
PageSpec =          namedtuple("PageSpec", ["name", "superclass", "namespace", "props", "pos"])
PropSpec =          namedtuple("PropSpec", ["type", "name", "annotations", "pos"])
AnnotationSpec =    namedtuple("AnnotationSpec", ["name", "value", "pos"])
TypeSpec =          namedtuple("TypeSpec", ["name", "subtype"])

BoolType =      "bool"
IntType =       "int"
FloatType =     "float"
StringType =    "string"
ListType =      "List"
PageRefType =   "PageRef"
TomeType =      "Tome"

PRIMITIVE_TYPES = set([ BoolType, IntType, FloatType ])
PARAMETERIZED_TYPES = set([ ListType, PageRefType, TomeType ])
ALL_TYPES = set([ BoolType, IntType, FloatType, StringType, ListType, PageRefType, TomeType ])

# cannot be used as variable names
RESERVED_NAMES = set(["pageType", "isTome", "props", "name"])

def type_spec_to_list (type_spec):
    '''returns a flat list of the types in a TypeSpec's type chain'''
    out = [ type_spec.name ]
    if type_spec.subtype:
        out += type_spec_to_list(type_spec.subtype)
    return out
