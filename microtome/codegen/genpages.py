#
# microtome - Tim Conkling, 2012

import argparse
import os
import errno
import re
import logging

import microtome.codegen.sourcemerger as sourcemerger
import microtome.codegen.parser as parser
import microtome.codegen.spec as s
import microtome.codegen.generator_objc as generator_objc
import microtome.codegen.generator_as as generator_as
import microtome.codegen.generator_py as generator_py

LOG = logging.getLogger(__name__)
EXTENSION = "microtome"
INPUT_FILE = re.compile(r'.*\.%s$' % EXTENSION)
GENERATORS = {"objc": generator_objc, "as": generator_as, "py": generator_py}


def main():
    ap = argparse.ArgumentParser()
    # optional args
    ap.add_argument("--header", help="header text to include in generated source")
    ap.add_argument("--library_namespace", help="namespace that the library file should use")
    # required args
    ap.add_argument("input_dir", type=readable_dir)
    ap.add_argument("output_dir")
    ap.add_argument("language", help="generated source language", choices=GENERATORS.keys())
    args = ap.parse_args()

    input_dir = os.path.abspath(args.input_dir)
    output_dir = os.path.abspath(args.output_dir)
    header_text = args.header or ""
    library_namespace = args.library_namespace or ""

    # select our generator
    generator = GENERATORS[args.language]
    merger = sourcemerger.GeneratedSourceMerger(generator.comment_prefix())
    page_specs = []

    logging.basicConfig(level=logging.INFO)

    # parse files in our input dir
    for (path, dirs, files) in os.walk(input_dir):
        for in_name in [os.path.join(path, candidate) for candidate in files if INPUT_FILE.match(candidate)]:
            LOG.info("Processing %s..." % os.path.abspath(in_name))
            # open the file, parse it, and run it through the generator
            with open(in_name, 'r') as in_file:
                try:
                    page_specs += parser.parse_document(in_file.read())
                except parser.ParseError, e:
                    e.filename = in_name
                    #LOG.error(str(e))
                    raise

    # generate page files
    library = s.LibrarySpec(namespace=library_namespace, header_text=header_text, pages=page_specs)
    for page_spec in page_specs:
        # this can result in multiple generated files (e.g. a .h and .m file for objc)
        # merge each of our generated files
        for out_name, out_contents in generator.generate_page(library, page_spec):
            out_name = os.path.join(output_dir, out_name)
            merge_and_write(merger, out_name, out_contents)

    # now generate and save the library file
    for out_name, out_contents in generator.generate_library(library):
        out_name = os.path.join(output_dir, out_name)
        merge_and_write(merger, out_name, out_contents)


def merge_and_write(merger, filename, file_contents):
    # merge with existing file?
    if os.path.isfile(filename):
        with open(filename, 'r') as existing_file:
            file_contents = merger.merge(file_contents, existing_file.read())

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
        LOG.info("Writing generated file '%s'" % filename)
        out_file.write(file_contents)


def readable_dir(d):
    if not os.path.isdir(d):
        raise argparse.ArgumentTypeError("'%s' is not a valid path" % d)
    elif not os.access(d, os.R_OK):
        raise argparse.ArgumentTypeError("'%s' is not a readable directory" % d)
    else:
        return d

if __name__ == "__main__":
    main()
