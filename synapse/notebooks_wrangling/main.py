"""
Usage:
    python main.py ipynb_to_md <infile>
    python main.py ipynb_to_md cosmos_mongo_sales_processing.ipynb
    -
    python main.py notebooks_to_md <infile>
    python main.py notebooks_to_md tmp/notebooks_list.txt
"""

__author__  = 'Chris Joakim'
__license__ = "MIT"
__version__ = "February 2022"

import json
import os
import pprint
import sys
import time
import uuid

from docopt import docopt
from operator import itemgetter

from pysrc.env import Env
from pysrc.fs import FS

def ipynb_to_md(basename):
    infile = '../notebooks/{}'.format(basename)
    print('ipynb_to_md {}'.format(basename))

    obj = FS.read_json(infile)
    json_outfile = 'tmp/{}.json'.format(basename)
    md_outfile   = 'tmp/{}.md'.format(basename)
    FS.write_json(obj, json_outfile, pretty=True, verbose=True)

    md_lines = list()
    md_lines.append("")
    md_lines.append("---")
    md_lines.append("---")
    md_lines.append("")
    md_lines.append("# Notebook {}".format(basename))

    for cidx, cell in enumerate(obj['cells']):
        ctype  = cell['cell_type']
        source = cell['source'] 
        md_lines.append("")
        md_lines.append("---")
        md_lines.append("")
        md_lines.append("## Cell {}, type: {}".format(cidx + 1, ctype))
        md_lines.append("")
        md_lines.append("```")
        for line in source:
            md_lines.append(line.rstrip())
        md_lines.append("```")

    FS.write_lines(md_outfile, md_lines)

def notebooks_to_md(listfile):
    lines = FS.read_lines(listfile)
    for line in lines:
        basename = line.strip().split('/')[-1]
        ipynb_to_md(basename)

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

        if func == 'ipynb_to_md':
            basename = sys.argv[2]
            ipynb_to_md(basename)
        elif func == 'notebooks_to_md':
            listfile = sys.argv[2]
            notebooks_to_md(listfile)
        else:
            print_options('Error: invalid function: {}'.format(func))
    else:
            print_options('Error: no command-line args entered')
