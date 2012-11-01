#
# microtome - Tim Conkling, 2012

import argparse
import sys
import os
import errno
import re

import parser
import generator_objc

import sourcemerger

INPUT_FILE = re.compile(r'.*\.mt')

GENERATORS = { "objc": generator_objc }

MERGER = sourcemerger.GeneratedSourceMerger()

def main ():
    ap = argparse.ArgumentParser()
    # optional args
    ap.add_argument("--header", help = "header text to include in generated source")
    # required args
    ap.add_argument("input_dir", type = readable_dir)
    ap.add_argument("output_dir")
    ap.add_argument("language", help = "generated source language", choices = GENERATORS.keys())
    args = ap.parse_args()

    input_dir = os.path.abspath(args.input_dir)
    output_dir = os.path.abspath(args.output_dir)
    header_text = args.header or ""

    # select our generator
    generator = GENERATORS[args.language];
    page_names = []

    # process files in our input dir
    for (path, dirs, files) in os.walk(input_dir):
        # get the component of the path relative to the input_dir
        relative_path = path[len(input_dir):].lstrip("/")
        for in_name in [os.path.join(path, candidate) for candidate in files if INPUT_FILE.match(candidate)]:
            print("Processing " + os.path.abspath(in_name) + "...")
            # open the file, parse it, and run it through the generator
            with open(in_name, 'r') as in_file:
                try:
                    page_spec = parser.parse(in_file.read())
                except parser.ParseError, e:
                    e.filename = in_name
                    raise
                generated = generator.generate_page(page_spec, header_text)

            # this can result in multiple generated files (e.g. a .h and .m file for objc)
            # merge each of our generated files
            for out_name, out_contents in generated:
                out_name = os.path.join(output_dir, relative_path, out_name)
                merge_and_write(out_name, out_contents)

            # save all our page names
            page_names.append(page_spec.name)

    # now generate and save the library file
    generated = generator.generate_library(page_names, header_text)
    for out_name, out_contents in generated:
        out_name = os.path.join(output_dir, out_name)
        merge_and_write(out_name, out_contents)

def merge_and_write (filename, file_contents):
    # merge with existing file?
    if os.path.isfile(filename):
        with open(filename, 'r') as existing_file:
            MERGER.merge(file_contents, existing_file.read())

    # generate output directories
    full_path = os.path.split(filename)[0]
    try:
        os.makedirs(full_path)
    except OSError as e:
        if e.errno == errno.EEXIST:
            pass
        else:
            raise

    # write out
    with open(filename, 'w') as out_file:
        print("Writing generated file '%s'" % filename)
        out_file.write(file_contents)


def readable_dir (d):
    if not os.path.isdir(d):
        raise argparse.ArgumentTypeError("'%s' is not a valid path" % d)
    elif not os.access(d, os.R_OK):
        raise argparse.ArgumentTypeError("'%s' is not a readable directory" % d)
    else:
        return d

if __name__ == "__main__":
    sys.argv.append("--header")
    sys.argv.append("// It's a header!")
    sys.argv.append("test")
    sys.argv.append("test-out")
    sys.argv.append("objc")
    main()
