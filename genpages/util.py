#
# microtome - Tim Conkling, 2012

import re
from collections import namedtuple
import os

LineData = namedtuple("LineData", ["line_num", "col"])

def line_data_at_index (str, idx):
    '''returns the string's line number and line column number at the given index'''
    # count the number of newlines up to idx
    pattern = re.compile(r'\n')
    line_num = 0
    col = idx
    pos = 0
    while True:
        match = pattern.search(str, pos)
        if match is None or match.end() > idx:
            break
        pos = match.end()
        line_num += 1
        col = idx - pos

    return LineData(line_num = line_num, col = col)

def abspath (path):
    this_dir = os.path.dirname(os.path.abspath(__file__))
    return os.path.join(this_dir, path)

def strip_namespace (typename):
    '''com.microtome.Foo -> Foo'''
    idx = typename.rfind(".")
    return typename[idx+1:] if idx >= 0 else typename

def get_namespace (typename):
    '''com.microtome.Foo -> com.microtome'''
    idx = typename.rfind(".")
    return typename[:idx] if idx >= 0 else ""

def get_namespace_elements (typename):
    '''com.microtome.Foo -> [ 'com', 'microtome' ]'''
    package_str = get_namespace(typename)
    return package_str.split(".") if len(package_str) > 0 else []

def qualified_name (namespace, typename):
    '''appends a namespace to a typename'''
    return namespace + "." + typename if len(namespace) > 0 else typename

def namespace_to_path (namespace):
    '''com.microtome.foo -> com/microtome/foo'''
    return namespace.replace(".", "/")

def get_common_namespace (typenames):
    '''discovers the longest common namespace shared by all the typenames,
    e.g. [ com.foo.bar.Baz, com.foo.qwert.Asdf ] -> com.foo'''
    common = []
    for typename in typenames:
        elements = get_namespace_elements(typename)
        if len(common) == 0:
            common = elements
            continue
        for i in range(len(common)):
            if (i >= len(elements)) or (common[i] != elements[i]):
                common = common[:i]
                break;
        if len(common) == 0:
            break;

    return ".".join(common)


if __name__ == '__main__':
    print get_common_namespace(["com.foo.qwert.Bar", "com.foo.Asdf"])

