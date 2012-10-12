#
# microtome - Tim Conkling, 2012

import argparse
import sys
import os
import re

import parser
import objc_generator

import sourcemerger

INPUT_FILE = re.compile(r'.*\.mt')

def main ():
    ap = argparse.ArgumentParser()
    ap.add_argument("input_dir", type = readable_dir)
    ap.add_argument("output_dir")
    args = ap.parse_args()

    input_dir = os.path.abspath(args.input_dir)
    output_dir = os.path.abspath(args.output_dir)

    merger = sourcemerger.GeneratedSourceMerger()

    # process files in our input dir
    for in_name in [os.path.join(input_dir, fn) for fn in os.listdir(input_dir) if INPUT_FILE.match(fn)]:
        print("Processing " + os.path.abspath(in_name) + "...")
        # open the file, parse it, and run it through the generator
        with open(in_name, 'r') as in_file:
            page_spec = parser.parse(in_file.read())
            generated = objc_generator.generate(page_spec)

        # this can result in multiple generated files (e.g. a .h and .m file for objc)
        # merge each of our generated files
        for out_name, out_contents in generated:
            out_name = os.path.join(output_dir, out_name)

            # merge with existing file?
            if os.path.isfile(out_name):
                with open(out_name, 'r') as existing_file:
                    merger.merge(out_contents, existing_file.read())

            # write out
            with open(out_name, 'w') as out_file:
                print("Writing generated file '%s'" % out_name)
                out_file.write(out_contents)

def readable_dir (d):
    if not os.path.isdir(d):
        raise argparse.ArgumentTypeError("'%s' is not a valid path" % d)
    elif not os.access(d, os.R_OK):
        raise argparse.ArgumentTypeError("'%s' is not a readable directory" % d)
    else:
        return d

if __name__ == "__main__":
    sys.argv.append("test")
    sys.argv.append("test")
    main()
