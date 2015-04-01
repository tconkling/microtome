#!/usr/bin/env python

from setuptools import setup, find_packages

setup(
    name='microtome',
    version='0.1.0',
    packages=find_packages(exclude=['microtome.test', 'microtome.test.*']),
    package_data={'microtome.codegen': ['templates/**/*.mustache']},

    install_requires=["pystache>=0.5.2"],

    # scripts
    entry_points={
        'console_scripts': [
            'gentomes = microtome.codegen.gentomes:main'
        ]
    },

    # metadata for upload to PyPI
    author='Tim Conkling',
    author_email='tim@timconkling.com',
    description='Parse and manage game data in your favorite game development language',
    url='https://github.com/tconkling/microtome',
)
