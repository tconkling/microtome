#
# microtome

def page_typename(page_class):
    '''return the page typename for the given page class'''
    return page_class.__name__

def valid_library_item_name(name):
    # items cannot have '.' in the name
    return len(name) > 0 and not '.' in name

def get_prop(page, name):
    return next((prop for prop in page.props if prop.name == name), None)
