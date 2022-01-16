"""
Usage:
    python main.py aaa <infile> <format>
"""

__author__  = 'Chris Joakim'
__license__ = "MIT"
__version__ = "November 2021"

import json
import os
import pprint
import sys
import time
import uuid

import arrow

from docopt import docopt
from operator import itemgetter

from pysrc.env import Env
from pysrc.fs import FS
from pysrc.mongo import Mongo


def aaa(infile, format):
    print('{}/{}'.format(infile, format))


def check_mongo():
    print("==========\ncheck_mongo:")
    opts = dict()
    opts['host'] = 'localhost'
    opts['port'] = 27017
    m = Mongo(opts)
    db = m.set_db('dev')
    coll = m.set_coll('movies')
    movies = FS.read_json('data/movies.json')
    keys = sorted(movies.keys())
    for idx, key in enumerate(keys):
        if idx < 100:
            data = dict()
            data['title_id'] = key
            data['title'] = movies[key]
            data['doctype'] = 'movie'
            if idx < 12:
                data['top10'] = True
            else:
                data['top10'] = False
            result = m.insert_doc(data)
            #print('{} -> {}'.format(str(result.inserted_id), str(data)))
            print(data)
    print(m.list_collections())
    print(m.list_databases())
    print(m.find_one({"title": 'Footloose'}))
    print(m.find_one({"title": 'Not There'}))
    print(m.find_by_id('5ea575f08bd3a96405ea6366'))

    um = m.update_many({"top10": True}, {'$set': {"rating": 100, "bacon": False}}, False)
    print(um)
    fl2 = m.update_one({"title": 'Footloose'}, {'$set': {"rating": 100, "bacon": True}}, False) # update_one(filter, update, upsert)
    print(fl2)
    fl3 = m.find_one({"title": 'Footloose'})
    print(fl3)
    cursor = m.find({"top10": True})
    for doc in cursor:
        print(doc)

    print(m.count_docs({}))
    print(m.count_docs({"title": 'Footloose'}))
    print(m.delete_by_id('5ea575f08bd3a96405ea6366'))
    print(m.count_docs({}))
    print(m.delete_one({"title": 'The Money Pit'}))
    print(m.count_docs({}))
    print(m.delete_many({"doctype": 'movie'}))
    print(m.count_docs({}))

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
