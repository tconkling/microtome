#
# microtome

def get_prop(page, name):
    return next((prop for prop in page.props if prop.name == name), None)
