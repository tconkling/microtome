#
# microtome - Tim Conkling, 2012

import parser
import objc_generator

def main ():
    pass # todo

def process_file (filename):
    with open(filename, 'r') as f:
        page_spec =  parser.parse(f.read())
        print page_spec
        generated = objc_generator.generate(page_spec)
        for name, contents in generated:
            print contents

if __name__ == "__main__":
    process_file("test/BasicPage.mt")
