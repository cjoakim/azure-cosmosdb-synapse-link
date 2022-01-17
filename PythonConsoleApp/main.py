"""
Usage:
    python main.py list_databases
    python main.py list_containers demo
    python main.py count_documents demo stores
    python main.py load_container dbname cname pkattr infile
    python main.py load_container demo stores store_id data/stores.json
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


def list_databases():
    print('list_databases ...')
    opts = dict()
    opts['conn_string'] = os.environ['AZURE_CSL_COSMOSDB_MONGODB_CONN_STRING']

    m = Mongo(opts)
    print(m.list_databases())

def list_containers(dbname):
    print('list_containers in {} ...'.format(dbname))
    opts = dict()
    opts['conn_string'] = os.environ['AZURE_CSL_COSMOSDB_MONGODB_CONN_STRING']

    m = Mongo(opts)
    m.set_db(dbname)
    print(m.list_collections())

def count_documents(dbname, cname):
    print('count_documents, db: {}, cname: {}'.format(dbname, cname))

    opts = dict()
    opts['conn_string'] = os.environ['AZURE_CSL_COSMOSDB_MONGODB_CONN_STRING']
    m = Mongo(opts)
    m.set_db(dbname)
    m.set_coll(cname)
    print(m.count_docs({}))

def truncate_documents(dbname, cname):
    print('truncate_documents, db: {}, cname: {}'.format(dbname, cname))

    opts = dict()
    opts['conn_string'] = os.environ['AZURE_CSL_COSMOSDB_MONGODB_CONN_STRING']
    m = Mongo(opts)
    m.set_db(dbname)
    m.set_coll(cname)

def load_container(dbname, cname, pkattr, infile):
    print('load_container, db: {}, cname: {}, pk: {}, infile: {}'.format(
        dbname, cname, pkattr, infile))

    opts = dict()
    opts['conn_string'] = os.environ['AZURE_CSL_COSMOSDB_MONGODB_CONN_STRING']
    m = Mongo(opts)
    m.set_db(dbname)
    m.set_coll(cname)

    it = FS.text_file_iterator(infile)
    for i, line in enumerate(it):
        doc = json.loads(line.strip())
        doc['id'] = str(uuid.uuid4())
        doc['pk'] = str(doc[pkattr])
        print(json.dumps(doc)) #, sort_keys=False, indent=2))
        print(m.insert_doc(doc))

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

        if func == 'list_databases':
            list_databases()

        elif func == 'list_containers':
            dbname = sys.argv[2]
            list_containers(dbname)

        elif func == 'count_documents':
            dbname = sys.argv[2]
            cname  = sys.argv[3]
            count_documents(dbname, cname)

        elif func == 'load_container':
            dbname = sys.argv[2]
            cname  = sys.argv[3]
            pkattr = sys.argv[4]
            infile = sys.argv[5]
            load_container(dbname, cname, pkattr, infile)

        else:
            print_options('Error: invalid function: {}'.format(func))
    else:
            print_options('Error: no command-line args entered')
