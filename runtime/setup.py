#!/usr/bin/env python

from distutils.core import setup

setup(name='microtome',
      version='0.1.0',
      description='',
      author='Tim Conkling',
      author_email='tim@timconkling.com',
      url='https://github.com/tconkling/microtome',
      packages=['microtome', 'microtome.core', 'microtome.marshaller'],
      package_dir={'microtome': 'src/main/py/microtome'},
      )
