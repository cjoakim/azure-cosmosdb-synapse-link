"""
Usage:
    python main.py list_databases
    python main.py list_containers demo
    python main.py count_documents demo stores
    python main.py load_container dbname cname pkattr infile
    python main.py load_container demo stores store_id data/stores.json --verbose
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

from docopt import docopt
from operator import itemgetter

from pysrc.fs import FS
from pysrc.mongo import Mongo

def mongo_opts():
    # Obtain the connection string from an environment variable.
    # See your CosmosDB/Mongo account in Azure Portal for this value.
    # It will look similar to the following:
    # mongodb://cjoakimcslcosmosmongo:...<secret>...==@cjoakimcslcosmosmongo.mongo.cosmos.azure.com:10255/?ssl=true&replicaSet=globaldb&retrywrites=false&maxIdleTimeMS=120000&appName=@cjoakimcslcosmosmongo@
    opts = dict()
    opts['conn_string'] = os.environ['AZURE_CSL_COSMOSDB_MONGODB_CONN_STRING']
    opts['verbose'] = verbose()
    return opts

def verbose():
    for arg in sys.argv:
        if arg == '--verbose':
            return True
    return False

def list_databases():
    print('list_databases ...')
    m = Mongo(mongo_opts())
    print(m.list_databases())

def list_containers(dbname):
    print('list_containers in {} ...'.format(dbname))
    m = Mongo(mongo_opts())
    m.set_db(dbname)
    print(m.list_collections())
    if verbose():
        print('RU charge: {}'.format(m.last_request_request_charge()))

def count_documents(dbname, cname):
    print('count_documents, db: {}, cname: {}'.format(dbname, cname))
    m = Mongo(mongo_opts())
    m.set_db(dbname)
    m.set_coll(cname)
    print(m.count_docs({}))
    if verbose():
        print('RU charge: {}'.format(m.last_request_request_charge()))

def load_container(dbname, cname, pkattr, infile):
    print('load_container, db: {}, cname: {}, pk: {}, infile: {}'.format(
        dbname, cname, pkattr, infile))

    m = Mongo(mongo_opts())
    m.set_db(dbname)
    m.set_coll(cname)

    it = FS.text_file_iterator(infile)
    for i, line in enumerate(it):
        doc = json.loads(line.strip())
        doc['id'] = str(uuid.uuid4())
        doc['pk'] = str(doc[pkattr])
        print(json.dumps(doc)) #, sort_keys=False, indent=2))
        print(m.insert_doc(doc))
        if verbose():
            print('RU charge: {}'.format(m.last_request_request_charge()))

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
