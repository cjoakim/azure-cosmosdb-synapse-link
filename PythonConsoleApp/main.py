"""
Usage:
    python main.py aaa <infile> <format>
"""

__author__  = 'Chris Joakim'
__email__   = "chjoakim@microsoft.com"
__license__ = "MIT"
__version__ = "January 2022"

import json
import os
import pprint
import sys
import time
import uuid
import xml.sax

import arrow

from docopt import docopt
from operator import itemgetter

from pysrc.fs import FS
from pysrc.mongo import Mongo

def aaa(infile, format):
    print('{}/{}'.format(infile, format))

def write(outfile, s, verbose=True):
    with open(outfile, 'w') as f:
        f.write(s)
        if verbose:
            print('file written: {}'.format(outfile))

def print_options(msg):
    print(msg)
    arguments = docopt(__doc__, version='Nov 2021')
    print(arguments)


if __name__ == "__main__":

    if len(sys.argv) > 1:
        func = sys.argv[1].lower()

        if func == 'aaa':
            infile =  sys.argv[2]
            format =  sys.argv[3]
            aaa(infile, format)

        else:
            print_options('Error: invalid function: {}'.format(func))
    else:
            print_options('Error: no command-line args entered')
