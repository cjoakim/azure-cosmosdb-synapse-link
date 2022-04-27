"""
Usage:
    python main.py list_databases
    python main.py list_containers demo
    python main.py count_documents demo stores
    python main.py load_container dbname cname pkattr infile
    python main.py load_container demo stores store_id data/stores.json --verbose
    python main.py execute_query demo stores find_by_pk --pk 2 
    python main.py execute_query demo stores find_by_pk_id --pk 2 --id 61e6d8407a0af4624aaf0212 --verbose
"""

__author__  = 'Chris Joakim'
__email__   = "chjoakim@microsoft.com"
__license__ = "MIT"
__version__ = "April 2022"

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

    start_epoch = time.time()
    count = 0

    m = Mongo(mongo_opts())
    m.set_db(dbname)
    m.set_coll(cname)

    it = FS.text_file_iterator(infile)
    for i, line in enumerate(it):
        stripped = line.strip()
        if len(stripped) > 10:
            doc = json.loads(line.strip())
            doc['id'] = str(uuid.uuid4())
            doc['pk'] = str(doc[pkattr])
            doc['epoch'] = time.time()
            print(json.dumps(doc)) #, sort_keys=False, indent=2))
            print(m.insert_doc(doc))
            count = count + 1
            if verbose():
                print('RU charge: {}'.format(m.last_request_request_charge()))

    print('{} documents written, start_epoch {}'.format(count, start_epoch))

def execute_query(dbname, cname, qname):
    spec = query_spec(qname)
    print('dbname: {}, cname: {}, query: {}, spec: {}'.format(
        dbname, cname, qname, spec))
    m = Mongo(mongo_opts())
    m.set_db(dbname)
    m.set_coll(cname)
    for doc in m.find(spec):
        print(doc)
    if verbose():
        print('RU charge: {}'.format(m.last_request_request_charge()))

def query_spec(qname):
    spec = dict()
    if qname == 'find_by_pk':
        spec['pk'] = cli_flag_arg('--pk')
    elif qname == 'find_by_pk_id':
        spec['pk'] = cli_flag_arg('--pk')
        spec['_id'] = cli_flag_arg('--id')
    elif qname == 'find_by_id_pk':
        spec['pk'] = cli_flag_arg('--pk')
        spec['id'] = cli_flag_arg('--id')
    return spec

def write(outfile, s, verbose=True):
    with open(outfile, 'w') as f:
        f.write(s)
        if verbose:
            print('file written: {}'.format(outfile))

def cli_flag_arg(flag):
    for idx, arg in enumerate(sys.argv):
        if arg == flag:
            return sys.argv[idx + 1]
    return ''

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

        elif func == 'execute_query':
            dbname = sys.argv[2]
            cname  = sys.argv[3]
            qname  = sys.argv[4]
            execute_query(dbname, cname, qname)

        else:
            print_options('Error: invalid function: {}'.format(func))
    else:
            print_options('Error: no command-line args entered')
