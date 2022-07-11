"""
Usage:
    python main.py list_databases
    python main.py list_containers demo
    python main.py count_documents demo stores
    python main.py load_container dbname cname pkattr infile
    python main.py load_container demo stores store_id data/stores.json --verbose
    python main.py stream_sales demo sales sale_id data/sales1.json 999999 0.5 
    python main.py epoch
"""

__author__  = 'Chris Joakim'
__email__   = "chjoakim@microsoft.com"
__license__ = "MIT"
__version__ = "July 2022"

import json
import os
import pprint
import sys
import time
import uuid

import arrow 

from docopt import docopt

from pysrc.bytes import Bytes 
from pysrc.cosmos import Cosmos
from pysrc.env import Env
from pysrc.fs import FS

def cosmos_opts():
    opts = dict()
    opts['url'] = Env.var('AZURE_CSL_COSMOSDB_SQLDB_URI')
    opts['key'] = Env.var('AZURE_CSL_COSMOSDB_SQLDB_KEY')
    return opts

def verbose():
    for arg in sys.argv:
        if arg == '--verbose':
            return True
    return False

def list_databases():
    print('list_databases ...')
    c = Cosmos(cosmos_opts())
    for db in c.list_databases():
        print('database: {}'.format(db['id']))   

def list_containers(dbname):
    print('list_containers in {} ...'.format(dbname))
    c = Cosmos(cosmos_opts())
    dbproxy = c.set_db(dbname)
    for con in c.list_containers():
        print('container: {}'.format(con['id']))   

def count_documents(dbname, cname):
    print('count_documents, db: {}, cname: {}'.format(dbname, cname))
    c = Cosmos(cosmos_opts())
    dbproxy = c.set_db(dbname)
    ctrproxy = c.set_container(cname)

    sql = "select value count(1) from c"
    print('query; sql: {}'.format(sql))
    items = c.query_container(cname, sql, True, 1000)
    for item in items:
        print(json.dumps(item, sort_keys=False, indent=2))

def load_container(dbname, cname, pkattr, infile):
    print('load_container, db: {}, cname: {}, pk: {}, infile: {}'.format(
        dbname, cname, pkattr, infile))

    start_epoch = time.time()
    count = 0

    c = Cosmos(cosmos_opts())
    dbproxy = c.set_db(dbname)
    ctrproxy = c.set_container(cname)

    it = FS.text_file_iterator(infile)
    for i, line in enumerate(it):
        stripped = line.strip()
        if len(stripped) > 10:
            print('---')
            doc = json.loads(line.strip())
            doc['id'] = str(uuid.uuid4())
            doc['pk'] = str(doc[pkattr])
            doc['epoch'] = time.time()
            #print(json.dumps(doc))
            result = c.upsert_doc(doc)
            print(result)
            count = count + 1
            if verbose():
                c.print_last_request_charge()

    print('{} documents written'.format(count))

def stream_sales(dbname, cname, pkattr, infile, maxdocs, sec_delay):
    print('stream_sales, db: {}, cname: {}, pk: {}, infile: {}, maxdocs: {}, sec_delay: {}'.format(
        dbname, cname, pkattr, infile, maxdocs, sec_delay))

    start_epoch = time.time()
    count = 0

    c = Cosmos(cosmos_opts())
    dbproxy = c.set_db(dbname)
    ctrproxy = c.set_container(cname)

    it = FS.text_file_iterator(infile)
    for i, line in enumerate(it):
        if count < maxdocs:
            stripped = line.strip()
            if len(stripped) > 10:
                print('---')
                doc = json.loads(line.strip())
                doc['id'] = str(uuid.uuid4())
                doc['pk'] = str(doc[pkattr])
                doc['epoch'] = time.time()
                #print(json.dumps(doc))
                result = c.upsert_doc(doc)
                print(result)
                count = count + 1
                if verbose():
                    c.print_last_request_charge()
                time.sleep(sec_delay)

    print('{} documents written'.format(count))


def execute_query(dbname, cname, qname):
    print('execute_query is not yet implemented, see count_documents')

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

        elif func == 'stream_sales':
            dbname = sys.argv[2]
            cname  = sys.argv[3]
            pkattr = sys.argv[4]
            infile = sys.argv[5]
            maxdocs = int(sys.argv[6])
            sec_delay = float(sys.argv[7])
            stream_sales(dbname, cname, pkattr, infile, maxdocs, sec_delay)

        elif func == 'execute_query':
            dbname = sys.argv[2]
            cname  = sys.argv[3]
            qname  = sys.argv[4]
            execute_query(dbname, cname, qname)
        
        elif func == 'epoch':
            print('current epoch time is: {}'.format(time.time()))

        else:
            print_options('Error: invalid function: {}'.format(func))
    else:
            print_options('Error: no command-line args entered')
