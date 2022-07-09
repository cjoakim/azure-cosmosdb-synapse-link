"""
Usage:
  python main_example.py cosmos
Options:
  -h --help     Show this screen.
  --version     Show version.
"""

__author__  = 'Chris Joakim'
__email__   = "chjoakim@microsoft.com"
__license__ = "MIT"
__version__ = "2022/07/09"

import json
import sys
import time
import os

import arrow 

from docopt import docopt

from pysrc.bytes import Bytes 
from pysrc.cosmos import Cosmos
from pysrc.env import Env
from pysrc.fs import FS


def print_options(msg):
    print(msg)
    arguments = docopt(__doc__, version=__version__)
    print(arguments)

def check_bytes():
    print("==========\ncheck_bytes:")
    docker_dmg_size = 707758073
    kb = Bytes.kilobyte()
    print('kb: {}'.format(kb))
    print('docker_dmg as KB: {}'.format(Bytes.as_kilobytes(docker_dmg_size)))
    print('docker_dmg as MB: {}'.format(Bytes.as_megabytes(docker_dmg_size)))
    print('docker_dmg as GB: {}'.format(Bytes.as_gigabytes(docker_dmg_size)))
    print('docker_dmg as TB: {}'.format(Bytes.as_terabytes(docker_dmg_size)))
    print('docker_dmg as PB: {}'.format(Bytes.as_petabytes(docker_dmg_size)))

def check_env():
    print("==========\ncheck_env:")
    home = Env.var('HOME')
    print('home: {}'.format(home))

def check_fs():
    print("==========\ncheck_fs:")
    pwd = FS.pwd()
    print('pwd: {}'.format(pwd))
    files = FS.walk(pwd)
    for file in files:
        if 'cj-py/pysrc' in file['dir']:
            if file['base'].endswith('.py'):
                print(file['full'])
    print('count: {}'.format(len(files)))

    infile = 'data/postal_codes_nc.csv'
    rows = FS.read_csvfile_into_rows(infile, delim=',')
    for idx, row in enumerate(rows):
        if idx < 5:
            print(row)

    objects = FS.read_csvfile_into_objects(infile, delim=',')
    for idx, obj in enumerate(objects):
        if idx < 5:
            print(obj)

def check_cosmos():
    print("==========\ncheck_cosmos:")
    opts = dict()
    opts['url'] = Env.var('AZURE_CSL_COSMOSDB_SQLDB_URI')
    opts['key'] = Env.var('AZURE_CSL_COSMOSDB_SQLDB_KEY')
    dbname, cname = 'dev', 'smoke_test'

    c = Cosmos(opts)

    print('disable/enable metrics, print_record_diagnostics:')
    c.disable_query_metrics()
    c.enable_query_metrics()
    c.reset_record_diagnostics()
    c.print_record_diagnostics()
    c.print_last_request_charge()

    print('list_databases:')
    for db in c.list_databases():
        print('database: {}'.format(db['id']))   
    c.print_last_request_charge()

    print('set_db:')
    dbproxy = c.set_db(dbname)
    c.print_last_request_charge()

    print('list_containers:')
    for con in c.list_containers():
        print('container: {}'.format(con['id']))    
    c.print_last_request_charge()

    print('delete_container:')
    c.delete_container(cname)
    c.print_last_request_charge()

    print('create_container:')
    ctrproxy = c.create_container(cname, '/pk', 500)
    c.print_last_request_charge()

    print('create_container:')
    ctrproxy = c.create_container(cname, '/pk', 500)
    c.print_last_request_charge()

    print('set_container:')
    ctrproxy = c.set_container(cname)
    c.print_last_request_charge()
    
    print('update_container_throughput:')
    offer = c.update_container_throughput(cname, 600)
    c.print_last_request_charge()

    print('get_container_offer:')
    offer = c.get_container_offer(cname)
    c.print_last_request_charge()

    infile = 'data/postal_codes_nc.csv'
    objects = FS.read_csvfile_into_objects(infile, delim=',')
    documents = list()
    ctrproxy = c.set_container(cname)

    print('upsert_docs:')
    for idx, obj in enumerate(objects):
        del obj['id']
        if idx < 10:
            obj['pk'] = obj['postal_cd']
            print(obj)
            result = c.upsert_doc(obj)
            documents.append(result)
            c.print_last_request_charge()

    for idx, doc in enumerate(documents):
        if idx < 3:
            result = c.delete_doc(doc, doc['pk'])
            print('delete result: {}'.format(result))
            c.print_last_request_charge()
        else:
            doc['updated'] = True
            result = c.upsert_doc(doc)
            print('update result: {}'.format(result))
            c.print_last_request_charge()

    sql = "select * from c where c.state_abbrv = 'NC'"
    print('query; sql: {}'.format(sql))
    items = c.query_container(cname, sql, True, 1000)
    c.print_last_request_charge()
    last_id, last_pk = None, None
    for item in items:
        last_id = item['id']
        last_pk = item['pk']
        print(json.dumps(item, sort_keys=False, indent=2))

    print('read_doc; id: {} pk: {}'.format(last_id, last_pk))
    doc = c.read_doc(cname, last_id, last_pk)
    print(doc)
    c.print_record_diagnostics()
    c.print_last_request_charge()

    print('record_diagnostics_headers_dict:')
    print(json.dumps(c.record_diagnostics_headers_dict(), sort_keys=True, indent=2))
    
    print('reset and print diagnostics')
    c.reset_record_diagnostics()
    c.print_record_diagnostics()

    print('delete container: not_there')
    c.delete_container('not_there')
    c.print_last_request_charge()

    if False:
        print('delete container: {}'.format(cname))
        c.delete_container(cname)
        c.print_last_request_charge()


if __name__ == "__main__":

    # dispatch to a main function based either on the first command-line arg,
    # or on the MAIN_PY_FUNCTION environment variable when run as a container.

    func = sys.argv[1].lower()

    if func == 'bytes':
        check_bytes()
    elif func == 'cosmos':
        check_cosmos()
    elif func == 'env':
        check_env()
    elif func == 'fs':
        check_fs()
    else:
        print_options('Error: invalid function: {}'.format(func))
