#
# microtome

from microtome.tome import Tome

def tome_typename(tome_class):
    """return the page typename for the given page class"""
    return tome_class.__name__

def valid_library_item_name(name):
    # items cannot have '.' in the name
    return len(name) > 0 and not '.' in name

def get_prop(page, name):
    return next((prop for prop in page.props if prop.name == name), None)

def basic_props(tome):
    """Returns all non-Tome-storing props"""
    for prop in tome.props:
        if not issubclass(prop.value_type.clazz, Tome):
            yield prop
