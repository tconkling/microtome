#
# microtome - Tim Conkling, 2012
import numbers
import os

import pystache

import microtome.codegen.spec as s
import microtome.codegen.util as util


AS3_TYPENAMES = {
    s.BoolType: "Boolean",
    s.IntType: "int",
    s.FloatType: "Number",
    s.StringType: "String",
    s.ListType: "Array",
    s.TomeRefType: "microtome.core.TomeRef",
    s.TomeType: "microtome.Tome",
}

AS3_MUTABLE_TYPENAMES = {
    s.TomeType: "microtome.MutableTome",
}

PRIMITIVE_PROPNAMES = {
    s.BoolType: "microtome.prop.BoolProp",
    s.IntType: "microtome.prop.IntProp",
    s.FloatType: "microtome.prop.NumberProp"
}

OBJECT_PROPNAME = "microtome.prop.ObjectProp"

LIBRARY_FILENAME = "MicrotomeTypes.as"
TOME_TEMPLATE_NAME = "Tome.as"
MUTABLE_TOME_TEMPLATE_NAME = "MutableTome.as"
TEMPLATES_DIR = util.abspath("templates/as")

# stuff we always import
BASE_CLASS_IMPORTS = {"microtome.prop.Prop", "microtome.prop.PropSpec"}
BASE_INTERFACE_IMPORTS = set()
# stuff we never import (packageless typenames: Boolean, int, etc)
DISCARD_IMPORTS = {name for name in AS3_TYPENAMES.values() if util.get_namespace(name) == ""}


def comment_prefix():
    return "//"

def generate_library(lib):
    '''Returns a list of (filename, filecontents) tuples representing the generated files to
    be written to disk'''

    # "escape" param disables html-escaping
    stache = pystache.Renderer(search_dirs=TEMPLATES_DIR, escape=lambda u: u)

    tome_types = [util.qualified_name(spec.namespace, mutable_tome_name(spec.name)) for spec in lib.tomes]

    library_view = {
        "namespace": lib.namespace,
        "tome_types": sorted(set(tome_types)),
        "header": lib.header_text}

    class_contents = stache.render(stache.load_template(LIBRARY_FILENAME), library_view)

    path = util.namespace_to_path(lib.namespace)

    return [(os.path.join(path, LIBRARY_FILENAME), class_contents)]


def generate_tome(lib, tome_spec):
    '''Returns a list of (filename, filecontents) tuples representing the generated files to
    be written to disk'''
    tome_view = TomeView(lib, tome_spec)

     # "escape" param disables html-escaping
    stache = pystache.Renderer(search_dirs=TEMPLATES_DIR, escape=lambda u: u)

    iface_name = tome_view.interface_filename
    iface_contents = stache.render(stache.load_template(TOME_TEMPLATE_NAME), tome_view)

    class_name = tome_view.class_filename
    class_contents = stache.render(stache.load_template(MUTABLE_TOME_TEMPLATE_NAME), tome_view)

    return [(iface_name, iface_contents), (class_name, class_contents)]


def is_tome_name(lib, the_type):
    return (util.strip_namespace(the_type) in [tome_spec.name for tome_spec in lib.tomes])


def get_as3_typename(lib, the_type, mutable=False):
    '''converts a microtome typename to an actionscript typename'''
    if mutable and the_type in AS3_MUTABLE_TYPENAMES:
        return AS3_MUTABLE_TYPENAMES[the_type]
    elif the_type in AS3_TYPENAMES:
        return AS3_TYPENAMES[the_type]
    elif mutable and is_tome_name(lib, the_type):
        return mutable_tome_name(the_type)
    else:
        return the_type


def get_prop_typename(the_type):
    '''returns the prop typename for the given typename'''
    if the_type in PRIMITIVE_PROPNAMES:
        return PRIMITIVE_PROPNAMES[the_type]
    else:
        return OBJECT_PROPNAME


def to_bool(val):
    return "true" if val else "false"


def mutable_tome_name(tome_name):
    return util.qualified_name(util.get_namespace(tome_name),
                               "Mutable" + util.strip_namespace(tome_name))


class AnnotationView(object):
    def __init__(self, lib, annotation):
        self.annotation = annotation

    @property
    def name(self):
        return self.annotation.name

    @property
    def value(self):
        # bools are Numbers, so do the bool check first
        if isinstance(self.annotation.value, bool):
            return to_bool(self.annotation.value)
        elif isinstance(self.annotation.value, numbers.Number):
            return self.annotation.value
        else:
            return '"' + self.annotation.value + '"'


class TypeView(object):
    def __init__(self, lib, type):
        self.type = type
        self.lib = lib

    @property
    def is_mutable(self):
        return self.type.name == s.TomeRefType or \
            self.type.name in AS3_MUTABLE_TYPENAMES or \
            is_tome_name(self.lib, self.type.name)

    @property
    def is_primitive(self):
        return self.type.name in s.PRIMITIVE_TYPES

    @property
    def is_tomeref(self):
        return self.type.name == s.TomeRefType

    @property
    def name(self):
        return util.strip_namespace(self.get_qualified_name(False))

    @property
    def mutable_name(self):
        return util.strip_namespace(self.get_qualified_name(True))

    @property
    def all_typenames(self):
        return [util.strip_namespace(name) for name in self.qualified_typenames(True)]

    def get_qualified_name(self, mutable):
        if self.type.name == s.TomeRefType:
            return get_as3_typename(self.lib, self.type.subtype.name, mutable)
        else:
            return get_as3_typename(self.lib, self.type.name, mutable)

    def qualified_typenames(self, mutable):
        '''namespace-qualified typenames of all types used by this Type'''
        return [get_as3_typename(self.lib, name, mutable) for name in s.type_spec_to_list(self.type)]


class PropView(object):
    def __init__(self, lib, prop):
        self.prop = prop
        self.value_type = TypeView(lib, prop.type)
        self.annotations = [AnnotationView(lib, a) for a in prop.annotations]

    @property
    def typename(self):
        return util.strip_namespace(self.qualified_typename)

    @property
    def qualified_typename(self):
        return get_prop_typename(self.prop.type.name)

    @property
    def name(self):
        return self.prop.name

    @property
    def mutable_name(self):
        return "mutable" + util.uppercase_first(self.name)

    @property
    def annotation_text(self):
        # avoid obnoxious mustache markup
        if not self.has_annos:
            return "null"
        out = "{ "
        needs_separator = False
        for a in self.annotations:
            if needs_separator:
                out += ", "
            out += '"' + a.name + '"' + ": " + str(a.value)
            needs_separator = True
        out += " }"
        return out

    @property
    def has_annos(self):
        return len(self.annotations) > 0


class TomeView(object):
    def __init__(self, lib, tome):
        self.lib = lib
        self.tome = tome
        self.header = lib.header_text
        self.props = [PropView(lib, prop) for prop in self.tome.props]

    @property
    def class_name(self):
        return mutable_tome_name(self.tome.name)

    @property
    def interface_name(self):
        return self.tome.name

    @property
    def superclass(self):
        return util.strip_namespace(self.qualified_superclass)

    @property
    def qualified_superclass(self):
        if self.tome.superclass is None:
            return AS3_MUTABLE_TYPENAMES[s.TomeType]
        else:
            super_namespace = util.get_namespace(self.tome.superclass)
            super_name = mutable_tome_name(util.strip_namespace(self.tome.superclass))
            return util.qualified_name(super_namespace, super_name)

    @property
    def parent_interface(self):
        return util.strip_namespace(self.qualified_parent_interface)

    @property
    def qualified_parent_interface(self):
        return self.tome.superclass or AS3_TYPENAMES[s.TomeType]

    @property
    def namespace(self):
        return self.tome.namespace

    @property
    def class_filename(self):
        return os.path.join(util.namespace_to_path(self.namespace), self.class_name + ".as")

    @property
    def interface_filename(self):
        return os.path.join(util.namespace_to_path(self.namespace), self.interface_name + ".as")

    @property
    def class_imports(self):
        # prop classes
        imp_list = [prop.qualified_typename for prop in self.props]
        # our own superclass
        imp_list.append(self.qualified_superclass)
        # prop value typenames
        for prop in self.props:
            imp_list += prop.value_type.qualified_typenames(False)
            if prop.value_type.is_mutable:
                imp_list += prop.value_type.qualified_typenames(True)

        # strip out anything in our namespace
        imp_list = [imp for imp in imp_list if not self.same_namespace(imp)]

        # remove the imports we never want; add the imports we always want
        imports = set(imp_list) - DISCARD_IMPORTS | BASE_CLASS_IMPORTS

        return sorted(imports)

    def interface_imports(self):
        # prop value classes
        imp_list = [prop.value_type.get_qualified_name(False) for prop in self.props]
        # our own superclass
        imp_list.append(self.qualified_parent_interface)

        # strip out anything in our namespace
        imp_list = [imp for imp in imp_list if not self.same_namespace(imp)]

        # remove the imports we never want; add the imports we always want
        imports = set(imp_list) - DISCARD_IMPORTS | BASE_INTERFACE_IMPORTS

        return sorted(imports)

    def same_namespace(self, typename):
        return self.namespace == util.get_namespace(typename)

if __name__ == "__main__":
    NAMESPACE = "com.microtome.test"
    ANOTHER_TOME_TYPE = s.TypeSpec("com.microtome.test.AnotherTome", None)

    ANOTHER_TOME = s.TomeSpec(name="AnotherTome",
                              namespace=NAMESPACE,
                              superclass=None,
                              props=[],
                              pos=0)

    TOME = s.TomeSpec(name="TestTome",
        namespace=NAMESPACE,
        superclass=None,
        props=[
            s.PropSpec(type=s.TypeSpec(s.BoolType, None), name="foo", annotations=[
                s.AnnotationSpec(name="default", value="test", pos=0),
                s.AnnotationSpec(name="nullable", value=True, pos=0)
            ], pos=0),
            s.PropSpec(type=s.TypeSpec(s.TomeRefType, ANOTHER_TOME_TYPE), name="bar", annotations=[], pos=0),
            s.PropSpec(type=s.TypeSpec(s.TomeType, None), name="baz", annotations=[], pos=0),
        ],
        pos=0)

    LIB = s.LibrarySpec(namespace=NAMESPACE, header_text="", tomes=[TOME, ANOTHER_TOME])

    for filename, file_contents in generate_tome(LIB, TOME):
        print filename + ":"
        print file_contents
