"""
Usage:
    python retail_data_gen.py gen_retail_data 10000
    python retail_data_gen.py random 10000
    python retail_data_gen.py gen_date_range
    python retail_data_gen.py json_to_csv product   data/wrangled/retail/products.json  > data/wrangled/retail/products.csv
    python retail_data_gen.py json_to_csv customer  data/wrangled/retail/customers.json > data/wrangled/retail/customers.csv
    python retail_data_gen.py json_to_csv order     data/wrangled/retail/orders.json  > data/wrangled/retail/orders.csv
    python retail_data_gen.py json_to_csv line_item data/wrangled/retail/orders.json  > data/wrangled/retail/line_items.csv
    python retail_data_gen.py json_to_csv delivery  data/wrangled/retail/orders.json  > data/wrangled/retail/deliveries.csv
"""

__author__  = 'Chris Joakim'
__email__   = "chjoakim@microsoft.com"
__license__ = "MIT"
__version__ = "2021.10.23"

import arrow
import csv
import datetime
import json
import os
import random
import sys
import time
import traceback
import uuid

import numpy as np
import pandas as pd

from docopt import docopt
from faker  import Faker  # https://faker.readthedocs.io/en/master/index.html

def gen_retail_data(cust_count):
    customer_ids = gen_customer_ids(cust_count)
    write_obj_as_json_file('data/raw/tmp/customer_ids.json', customer_ids)

    order_dates = gen_date_range()
    write_obj_as_json_file('data/wrangled/retail/date_range.json', order_dates)

    gen_customers(cust_count, customer_ids)
    gen_orders(cust_count * 3, customer_ids, order_dates)

def gen_customer_ids(count):
    ids_list, ids_dict = list(), dict()
    f = Faker()
    f.random
    while len(ids_list) < count:
        cust_id = f.ean(prefixes=('00', ))
        if cust_id in ids_dict.keys():
            pass
        else:
            ids_list.append(cust_id)
    print('gen_customer_ids; {} created'.format(len(ids_list)))
    return ids_list

def gen_customers(count, customer_ids):
    customer_addresses = gen_customer_addresses(count)
    write_obj_as_json_file('data/raw/tmp/customer_addresses.json', customer_addresses)
    customer_keys = dict()
    last_idx = count - 1
    f = Faker()
    f.random

    outfile = 'data/wrangled/retail/customers.json'
    with open(outfile, 'wt') as out:
        for cust_idx, cust_id in enumerate(customer_ids):
            name_tup = gen_unique_customer_name(f, customer_keys, cust_idx)
            cust_obj = dict()
            cust_obj['id'] = str(uuid.uuid4())
            cust_obj['pk'] = cust_id
            cust_obj['doctype'] = 'customer'
            cust_obj['customer_id'] = cust_id
            cust_obj['name']  = name_tup[2]
            cust_obj['first'] = name_tup[0]
            cust_obj['last']  = name_tup[1]
            cust_obj['address'] = customer_addresses[cust_idx]
            out.write(json.dumps(cust_obj))
            if cust_idx < last_idx:
                out.write("\n")
    print("file written: " + outfile)

def gen_unique_customer_name(f, customer_keys, cust_idx):
    unique, name = 0, None
    while unique < 1:
        first = f.first_name()
        last  = f.last_name()
        name  = '{} {}'.format(first, last)
        if name in customer_keys.keys():
            pass
        else:
            unique = 1
            customer_keys[name] = cust_idx
    return (first, last, name)

def gen_customer_addresses(count):
    addr_list, addr_dict, excp_count = list(), dict(), 0
    f = Faker()
    f.random
    while len(addr_list) < count:
        addr = f.address()
        if addr in addr_dict.keys():
            pass
        else:
            try:
                tokens = addr.split('\n')
                city_st_zip = tokens[1].strip()
                city_st_zip_tokens = city_st_zip.split(',')
                city  = city_st_zip_tokens[0]
                state = city_st_zip_tokens[1].split()[0].strip()
                pcode = city_st_zip_tokens[1].split()[1].strip()
                addr_obj = dict()
                #addr_obj['address'] = addr
                addr_obj['street'] = tokens[0]
                addr_obj['city']  = city
                addr_obj['state'] = state
                addr_obj['zip']   = pcode
                addr_list.append(addr_obj)
            except:
                excp_count = excp_count + 1

    print('gen_customer_addresses; count: {}, excp_count: {}'.format(
        len(addr_list), excp_count))
    return addr_list

def gen_orders(count, customer_ids, order_dates):
    products_list = read_product_csv_data()
    outfile = 'data/wrangled/retail/products.json'
    with open(outfile, 'wt') as out:
        for product in products_list:
            out.write(json.dumps(product))
            out.write("\n")
    print("file written: " + outfile)

    ids_max_idx = len(customer_ids) - 1
    ids_product_idx = len(products_list) - 1
    order_id = str(uuid.uuid4())
    order_count, excp_count = 0, 0

    outfile = 'data/wrangled/retail/orders.json'
    with open(outfile, 'wt') as out:
        while order_count < count:
            try:
                ridx = random.randint(0, ids_max_idx)
                cust_id  = customer_ids[ridx]
                order_id = str(uuid.uuid4())
                nitems   = random.randint(1, 3)
                order_total = 0.0
                delivery_count = 0
                order_date = random_order_date(order_dates)

                order_obj = dict()
                order_obj['pk'] = order_id
                order_obj['doctype'] = 'order'
                order_obj['order_id'] = order_id
                order_obj['customer_id'] = cust_id
                order_obj['order_date'] = order_date
                order_obj['item_count'] = nitems
                order_obj['version']    = 'v2'

                for i in range(nitems):
                    line_num = i + 1
                    item_obj = dict()
                    item_obj['pk'] = order_id
                    item_obj['doctype'] = 'line_item'
                    item_obj['order_id'] = order_id
                    item_obj['line_num'] = line_num
                    item_obj['customer_id'] = cust_id
                    item_obj['order_date'] = order_date
                    item_obj['version']    = 'v2'

                    pidx = random.randint(0, ids_product_idx)
                    product = products_list[pidx]
                    qty = random.randint(1, 4)
                    price = product['price']
                    item_total = round(price * qty, 2)
                    order_total = order_total + item_total
                    item_obj['sku'] = product['sku']
                    item_obj['name'] = product['name']
                    item_obj['qty']  = qty
                    item_obj['price'] = price
                    item_obj['item_total'] = item_total
                    out.write(json.dumps(item_obj))
                    out.write("\n")

                    didx = random.randint(0, 3)  # approx 25% of items are delivered
                    if didx < 1:
                        delivery_count = delivery_count + 1
                        delivery = dict()
                        delivery['pk'] = order_id
                        delivery['doctype'] = 'delivery'
                        delivery['order_id'] = order_id
                        delivery['line_num'] = line_num
                        delivery['customer_id'] = cust_id
                        delivery['sku']     = product['sku']
                        delivery['status']  = 'not shipped'
                        delivery['version'] = 'v2'
                        out.write(json.dumps(delivery))
                        out.write("\n")  

                order_obj['order_total'] = round(order_total, 2)
                order_obj['delivery_count'] = delivery_count
                out.write(json.dumps(order_obj))
                out.write("\n")
                order_count = order_count + 1
            except:
                traceback.print_exc()
                return

    print("file written: " + outfile)

def read_product_csv_data():
    products = list()
    infile = 'data/raw/kaggle/walmart_com-ecommerce_product_details.csv'
    df = pd.read_csv(infile, delimiter=",")
    #describe_df(df, 'df walmart products')

    for row_idx, row in df.iterrows():
        try:
            id    = row['Uniq Id'].strip()
            gtin  = int(row['Gtin'])
            name  = row['Product Name']
            price = row['List Price']
            if len(id) > 0:
                if len(str(name)) > 0:
                    if price > 0:
                        if gtin > 0:
                            product = dict()
                            product['id'] = id
                            product['pk'] = gtin
                            product['sku'] = gtin
                            product['name'] = name
                            product['price'] = price
                            products.append(product)
        except:
            pass
    return products 

def gen_date_range():
    data  = list()
    start = datetime.datetime(2020, 10, 24)
    end   = datetime.datetime(2021, 10, 24)
    for r in arrow.Arrow.span_range('day', start, end):
        yyyymmdd = r[0].format('YYYY-MM-DD')
        data.append(yyyymmdd)
    return data

def random_order_date(order_dates):
    idx = random.randint(0, len(order_dates) - 1)
    return order_dates[idx]

def json_to_csv(doctype, infile):
    if doctype.lower() == 'product':
        json_to_csv_products(infile)

    elif doctype.lower() == 'customer':
        json_to_csv_customers(infile)

    elif doctype.lower() == 'order':
        json_to_csv_orders(infile, doctype)

    elif doctype.lower() == 'line_item':
        json_to_csv_line_items(infile, doctype)

    elif doctype.lower() == 'delivery':
        json_to_csv_deliveries(infile, doctype)

def json_to_csv_products(infile):
    header = 'id|pk|sku|name|price'
    attrs  = header.split('|')
    it = text_file_iterator(infile)
    print(header)
    for i, line in enumerate(it):
        doc = json.loads(line.strip())
        values = list()
        for attr in attrs:
            values.append(str(doc[attr]))
        print('|'.join(values))

def json_to_csv_customers(infile):
    header_part1 = 'pk|customer_id|name|first|last'
    header_part2 = 'street|city|state|zip'
    main_attrs = header_part1.split('|')
    addr_attrs = header_part2.split('|')
    print('{}|{}'.format(header_part1, header_part2))
    # {
    #   "pk": "0086334760179",
    #   "doctype": "customer",
    #   "customer_id": "0086334760179",
    #   "name": "Alexis Dalton",
    #   "first": "Alexis",
    #   "last": "Dalton",
    #   "address": {
    #     "street": "775 Gonzalez Forge",
    #     "city": "Port Ryantown",
    #     "state": "ND",
    #     "zip": "80488"
    #   }
    # }
    it = text_file_iterator(infile)
    for i, line in enumerate(it):
        doc = json.loads(line.strip())
        values = list()
        for attr in main_attrs:
            values.append(str(doc[attr]))
        for attr in addr_attrs:
            values.append(str(doc['address'][attr]))
        print('|'.join(values))

def json_to_csv_orders(infile, doctype):
    # {
    #   "pk": "b3d9b582-4653-4437-949c-c38b080e36c8",
    #   "doctype": "order",
    #   "order_id": "b3d9b582-4653-4437-949c-c38b080e36c8",
    #   "customer_id": "0010435500402",
    #   "order_date": "2021-07-04",
    #   "item_count": 1,
    #   "version": "v2",
    #   "order_total": 21.94,
    #   "delivery_count": 0
    # }
    header = 'pk|doctype|order_id|customer_id|order_date|item_count|version|order_total|delivery_count'
    attrs  = header.split('|')
    it = text_file_iterator(infile)
    print(header)
    it = text_file_iterator(infile)
    for i, line in enumerate(it):
        doc = json.loads(line.strip())
        if doc['doctype'] == doctype:
            values = list()
            for attr in attrs:
                values.append(str(doc[attr]))
            print('|'.join(values))

def json_to_csv_line_items(infile, doctype):
    # {
    #   "pk": "b3d9b582-4653-4437-949c-c38b080e36c8",
    #   "doctype": "line_item",
    #   "order_id": "b3d9b582-4653-4437-949c-c38b080e36c8",
    #   "line_num": 1,
    #   "customer_id": "0010435500402",
    #   "order_date": "2021-07-04",
    #   "version": "v2",
    #   "sku": 630509582716,
    #   "name": "Speak Out Kids vs Parents Game",
    #   "qty": 2,
    #   "price": 10.97,
    #   "item_total": 21.94
    # }
    header = 'pk|doctype|order_id|line_num|customer_id|order_date|version|sku|name|qty|price|item_total'
    attrs  = header.split('|')
    it = text_file_iterator(infile)
    print(header)
    it = text_file_iterator(infile)
    for i, line in enumerate(it):
        doc = json.loads(line.strip())
        if doc['doctype'] == doctype:
            values = list()
            for attr in attrs:
                values.append(str(doc[attr]))
            print('|'.join(values))

def json_to_csv_deliveries(infile, doctype):
    # {
    #   "pk": "b4c3a0a4-7e52-4b3f-96b4-8089a69ea89b",
    #   "doctype": "delivery",
    #   "order_id": "b4c3a0a4-7e52-4b3f-96b4-8089a69ea89b",
    #   "line_num": 3,
    #   "customer_id": "0077214149894",
    #   "sku": 49123524,
    #   "status": "not shipped",
    #   "version": "v2"
    # }
    header = 'pk|doctype|order_id|line_num|customer_id|sku|status|version'
    attrs  = header.split('|')
    it = text_file_iterator(infile)
    print(header)
    it = text_file_iterator(infile)
    for i, line in enumerate(it):
        doc = json.loads(line.strip())
        if doc['doctype'] == doctype:
            values = list()
            for attr in attrs:
                values.append(str(doc[attr]))
            print('|'.join(values))

def describe_df(df, msg):
    print('=== describe df: {}'.format(msg))
    print('--- df.head(3)')
    print(df.head(3))
    print('--- df.dtypes')
    print(df.dtypes)
    print('--- df.shape')
    print(df.shape)

def text_file_iterator(infile):
    # return a line generator that can be iterated with iterate()
    with open(infile, 'rt') as f:
        for line in f:
            yield line.strip()

def read_json(infile):
    with open(infile, 'rt') as f:
        return json.loads(f.read())

def write_obj_as_json_file(outfile, obj):
    txt = json.dumps(obj, sort_keys=False, indent=2)
    with open(outfile, 'wt') as f:
        f.write(txt)
    print("file written: " + outfile)

def print_options(msg):
    print(msg)
    arguments = docopt(__doc__, version=__version__)
    print(arguments)


if __name__ == "__main__":
    if len(sys.argv) > 1:
        func = sys.argv[1].lower()
        if func == 'gen_retail_data':
            cust_count = int(sys.argv[2])
            gen_retail_data(cust_count)
        elif func == 'random':
            count = int(sys.argv[2])
            for i in range(count):
                r = random.randint(0, 100)
                print('_{}_'.format(r))
        elif func == 'gen_date_range':
            order_dates = gen_date_range()
            for i in range(10000):
                print(random_order_date(order_dates))
        elif func == 'json_to_csv':
            doctype = sys.argv[2]
            infile  = sys.argv[3]
            json_to_csv(doctype, infile)
        else:
            print_options('Error: invalid function: {}'.format(func))
    else:
            print_options('Error: no command-line args entered')
