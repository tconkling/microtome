#
# microtome - Tim Conkling, 2012
import numbers
import os

try:
    from collections.abc import namedtuple  # Python 3
except ImportError:
    from collections import namedtuple  # Python 2

import pystache

import microtome.codegen.spec as s
import microtome.codegen.util as util


PY_TYPENAMES = {
    s.BoolType: "bool",
    s.IntType: "int",
    s.FloatType: "float",
    s.StringType: "str",
    s.ListType: "list",
    s.TomeRefType: "microtome.core.tome_ref.TomeRef",
    s.TomeType: "microtome.tome.Tome",
}

LIBRARY_FILENAME = "MicrotomeTypes.py"
TOME_TEMPLATE_NAME = "Tome.py"
TEMPLATES_DIR = util.abspath("templates/py")

# stuff we always import
BASE_IMPORTS = {"microtome.core.prop.Prop", "microtome.core.prop.PropSpec"}
# stuff we never import (packageless typenames: bool, int, etc)
DISCARD_IMPORTS = {name for name in PY_TYPENAMES.values() if util.get_namespace(name) == ""}

def comment_prefix():
    return "#"

def generate_library(lib):
    """Returns a list of (filename, filecontents) tuples representing the generated files to
    be written to disk"""

    # "escape" param disables html-escaping
    stache = pystache.Renderer(search_dirs=TEMPLATES_DIR, escape=lambda u: u)

    tome_imports = [ImportView.from_qualified_name(lib, util.qualified_name(spec.namespace, spec.name)) for spec in lib.tomes]

    library_view = {
        "tome_imports": sorted(set(tome_imports)),
        "header": lib.header_text}

    class_contents = stache.render(stache.load_template(LIBRARY_FILENAME), library_view)

    path = util.namespace_to_path(lib.namespace)

    return [(os.path.join(path, LIBRARY_FILENAME), class_contents)]


def generate_tome(lib, tome_spec):
    """Returns a list of (filename, filecontents) tuples representing the generated files to
    be written to disk"""
    tome_view = TomeView(lib, tome_spec)

     # "escape" param disables html-escaping
    stache = pystache.Renderer(search_dirs=TEMPLATES_DIR, escape=lambda u: u)

    class_name = tome_view.class_filename
    class_contents = stache.render(stache.load_template(TOME_TEMPLATE_NAME), tome_view)

    return [(class_name, class_contents)]


def is_tome_name(lib, the_type):
    return (util.strip_namespace(the_type) in [tome_spec.name for tome_spec in lib.tomes])


def get_py_typename(lib, the_type):
    """converts a microtome typename to a Python typename"""
    if the_type in PY_TYPENAMES:
        return PY_TYPENAMES[the_type]
    else:
        return the_type


def to_bool(val):
    return "True" if val else "False"

class ImportView(namedtuple("ImportView", ["package", "name"])):
    @classmethod
    def from_qualified_name(cls, lib, name):
        namespace = util.get_namespace(name)
        name = util.strip_namespace(name)
        # In the python microtome runtime, tomes are stored in their own individual modules -
        # e.g. 'from game.data.BaddieTome import BaddieTome' - so we account for that here
        if is_tome_name(lib, name):
            namespace += "." + name
        return ImportView(namespace, name)


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
    def is_tomeref(self):
        return self.type.name == s.TomeRefType

    @property
    def name(self):
        return util.strip_namespace(self.get_qualified_name())

    @property
    def all_typenames(self):
        return [util.strip_namespace(name) for name in self.qualified_typenames()]

    def get_qualified_name(self):
        if self.type.name == s.TomeRefType:
            return get_py_typename(self.lib, self.type.subtype.name)
        else:
            return get_py_typename(self.lib, self.type.name)

    def qualified_typenames(self):
        """namespace-qualified typenames of all types used by this Type"""
        return [get_py_typename(self.lib, name) for name in s.type_spec_to_list(self.type)]


class PropView(object):
    def __init__(self, lib, prop):
        self.prop = prop
        self.value_type = TypeView(lib, prop.type)
        self.annotations = [AnnotationView(lib, a) for a in prop.annotations]

    @property
    def name(self):
        return self.prop.name

    @property
    def annotation_text(self):
        # avoid obnoxious mustache markup
        if not self.has_annos:
            return "None"
        out = "{"
        needs_separator = False
        for a in self.annotations:
            if needs_separator:
                out += ", "
            out += '"' + a.name + '"' + ": " + str(a.value)
            needs_separator = True
        out += "}"
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
        return self.tome.name

    @property
    def namespace(self):
        return self.tome.namespace

    @property
    def qualified_name(self):
        return util.qualified_name(self.namespace, self.class_name)

    @property
    def superclass(self):
        return util.strip_namespace(self.qualified_superclass)

    @property
    def qualified_superclass(self):
        return self.tome.superclass if self.tome.superclass is not None else PY_TYPENAMES[s.TomeType]

    @property
    def class_filename(self):
        return os.path.join(util.namespace_to_path(self.namespace), self.class_name + ".py")

    @property
    def class_imports(self):
        # our superclass
        imp_list = [self.qualified_superclass]

        # remove the imports we never want; add the imports we always want
        imports = set(imp_list) - DISCARD_IMPORTS | BASE_IMPORTS
        imports.discard(self.qualified_name)

        return [ImportView.from_qualified_name(self.lib, imp) for imp in sorted(imports)]

    @property
    def post_imports(self):
        # we import all prop types in the POST-IMPORTS section, at the end of the file,
        # to prevent circular import issues
        imp_list = []
        for prop in self.props:
            imp_list += prop.value_type.qualified_typenames()
        imports = set(imp_list) - DISCARD_IMPORTS
        imports.discard(self.qualified_name)

        return [ImportView.from_qualified_name(self.lib, imp) for imp in sorted(imports)]

    def same_namespace(self, typename):
        return self.namespace == util.get_namespace(typename)

if __name__ == "__main__":
    NAMESPACE = "microtome.test"
    ANOTHER_TOME_TYPE = s.TypeSpec("microtome.test.AnotherTome", None)

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
            s.PropSpec(type=s.TypeSpec(s.TomeRefType, ANOTHER_TOME_TYPE), name="bar", annotations=[], pos=0)
        ],
        pos=0)

    LIB = s.LibrarySpec(namespace=NAMESPACE, header_text="", tomes=[TOME, ANOTHER_TOME])

    for filename, file_contents in generate_library(LIB):
        print(filename + ':')
        print(file_contents)

    for filename, file_contents in generate_tome(LIB, TOME):
        print(filename + ':')
        print(file_contents)
