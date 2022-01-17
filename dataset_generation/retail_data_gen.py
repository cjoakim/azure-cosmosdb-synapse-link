"""
Usage:
    python retail_data_gen.py create_product_catalog <l1-count> <l2-avg-count> <l3-avg-count>
    python retail_data_gen.py create_product_catalog 12 20 90 
    python retail_data_gen.py create_stores 100
    python retail_data_gen.py create_customers 10000
    python retail_data_gen.py create_sales_data 2020-01-01 2022-01-26 1000 4
"""

__author__  = 'Chris Joakim'
__email__   = "chjoakim@microsoft.com"
__license__ = "MIT"
__version__ = "January 2022"

import csv
import datetime
import json
import os
import random
import sys
import time
import traceback
import uuid

import pandas as pd

from docopt import docopt
from faker  import Faker  # https://faker.readthedocs.io/en/master/index.html


def create_product_catalog(l1_count, l2_avg_count, l3_avg_count):
    fake     = Faker()
    upc_dict  = dict()
    seq_num   = 0
    json_lines = list()

    print('create_product_catalog {} {} {} -> {}'.format(
        l1_count, l2_avg_count, l3_avg_count, (l1_count * l2_avg_count * l3_avg_count)))

    for l1_idx in range(l1_count):
        l1_name = str(l1_idx + 1).zfill(8)
        l2_actual_count = randomize_count(l2_avg_count, 0.2)

        for l2_idx in range(l2_actual_count):
            l2_name = str(l2_idx + 101).zfill(8)
            l3_actual_count = randomize_count(l3_avg_count, 0.4)

            for l3_idx in range(l3_actual_count):
                seq_num = seq_num + 1
                upc   = random_upc(upc_dict, fake)
                price = random_price(fake)

                obj = dict()
                obj['seq_num'] = seq_num
                obj['level_1_category'] = l1_name
                obj['level_2_category'] = l2_name
                obj['upc']   = upc
                obj['price'] = price
                json_lines.append(json.dumps(obj))

    write_lines('data/products/product_catalog.json', json_lines)

def randomize_count(count, multiplier):
    i1 = int(float(count) * (1.0 - multiplier))
    i2 = int(float(count) * (1.0 + multiplier))
    return random.randint(i1, i2)

def random_upc(upc_dict, fake):
    continue_to_process = True
    while continue_to_process:
        ean = fake.localized_ean13()
        if ean in upc_dict.keys():
            pass # try again
        else:
            upc_dict[ean] = ean
            continue_to_process = False
            return ean

def random_price(fake):
    # pyfloat(left_digits=None, right_digits=None, positive=False, min_value=None, max_value=None)
    return fake.pyfloat(positive=True, min_value=1, max_value=1500)

def create_stores(count):
    fake = Faker()
    json_lines = list()

    obj = dict()
    obj['store_id'] = 1
    obj['name']     = 'eCommerce'
    obj['address']  = '2048 Peachtree St'
    obj['state']    = 'GA'
    json_lines.append(json.dumps(obj))

    for idx in range(1,count):
        obj = dict()
        obj['store_id'] = idx + 1
        obj['name']     = fake.city()
        obj['address']  = fake.street_address().replace(',',' ')
        obj['state']    = fake.state_abbr()
        json_lines.append(json.dumps(obj))

    write_lines('data/products/stores.json', json_lines)

def create_customers(count):
    fake = Faker()
    json_lines = list()

    for idx in range(count):
        first = fake.first_name().replace(',',' ')
        last  = fake.last_name().replace(',',' ')
        obj = dict()
        obj['customer_id'] = 1
        obj['first_name'] = first
        obj['last_name'] = last
        obj['full_name'] = '{} {}'.format(first, last)
        obj['address'] = fake.street_address().replace(',',' ')
        obj['city'] = fake.city()
        obj['state'] = fake.state_abbr()
        json_lines.append(json.dumps(obj))

    write_lines('data/products/customers.json', json_lines)

def create_sales_data(start_date, end_date, avg_count_day, avg_item_count):
    fake = Faker()
    day_count, line_item_count = 0, 0

    sale_id = 0

    products  = read_json_objects('data/products/product_catalog.json')
    stores    = read_json_objects('data/products/stores.json')
    customers = read_json_objects('data/products/customers.json')
    print('products loaded; count:  {}'.format(len(products)))
    print('stores loaded; count:    {}'.format(len(stores)))
    print('customers loaded; count: {}'.format(len(customers)))

    days = calendar_days(start_date, end_date)

    outfile = 'data/products/sales.json'
    with open(outfile, 'wt') as out:
        for day in days:
            day_count = day_count + 1
            # {'seq': 756, 'date': '2022-01-26', 'daynum': 3, 'dow': 'Wed'}
            day_sales_count = randomize_count(avg_count_day, 0.4)
            print('generating {} sales for {} {}'.format(
                day_sales_count, day['date'], day['dow']))

            for sale_idx in range(day_sales_count):
                sale_obj = dict()
                sale_id  = sale_id + 1
                customer = random_object(customers)
                store    = random_object(stores)
                customer_id = customer['customer_id']
                store_id    = store['store_id']

                item_count = randomize_count(avg_item_count, 0.25)

                sale_obj['pk'] = sale_id
                sale_obj['id'] = str(uuid.uuid4())
                sale_obj['sale_id'] = sale_id
                sale_obj['doctype'] = 'sale'
                sale_obj['date'] = day['date']
                sale_obj['dow']  = day['dow'].lower()
                sale_obj['customer_id'] = customer_id
                sale_obj['store_id'] = store_id
                sale_obj['item_count'] = item_count
                sale_obj['total_cost'] = 0.0

                for i in range(item_count):
                    line_item_count = line_item_count + 1
                    product = random_object(products)
                    qty  = random.randint(1,3)
                    cost = float(product['price']) * qty
                    item_obj = dict()
                    item_obj['pk'] = sale_id
                    item_obj['id'] = str(uuid.uuid4())
                    item_obj['sale_id'] = sale_id

                    item_obj['doctype'] = 'line_item'
                    item_obj['date'] = day['date']
                    item_obj['line_num'] = i + 1
                    item_obj['customer_id'] = customer_id
                    item_obj['store_id'] = store_id
                    item_obj['upc'] = product['upc']
                    item_obj['price'] = float(product['price'])
                    item_obj['qty'] = qty
                    item_obj['cost'] = float('{:.2f}'.format(cost))
                    out.write(json.dumps(item_obj) + "\n")

                    sale_obj['total_cost'] = sale_obj['total_cost'] + cost

                sale_obj['total_cost'] = float('{:.2f}'.format(sale_obj['total_cost']))
                out.write(json.dumps(sale_obj) + "\n")

    print('file created: {}'.format(outfile))
    print('days: {}, sales: {}, line_items: {}'.format(
        day_count, sale_id, line_item_count))

def random_object(objects):
    max = len(objects)
    idx = random.randint(0, len(objects) - 1)
    return objects[idx]

def calendar_days(start_date, end_date):
    days = list()
    date1 = parse_yyyymmdd(start_date)
    date2 = parse_yyyymmdd(end_date)
    dates = inclusive_dates_between(date1, date2, 1000)
    for idx, d in enumerate(dates):
        day = dict()
        day['seq']    = idx
        day['date']   = str(d)
        day['daynum'] = d.isoweekday()
        day['dow']    = d.strftime('%a')
        days.append(day)
    return days

def parse_yyyymmdd(date_str):
    # parse the given 'yyyy-mm-dd' string to a datetime.date
    tokens = date_str.split('-')
    for idx, token in enumerate(tokens):
        tokens[idx] = int(token)
    return datetime.date(tokens[0], tokens[1], tokens[2])

def inclusive_dates_between(start_date, end_date, max_count):
    # return a list of datetime.date objects
    dates = list()
    curr_date = start_date
    end_date_str = str(end_date)
    one_day = datetime.timedelta(days=1)
    continue_to_process = True

    for idx, token in enumerate(range(int(max_count))):
        if continue_to_process:
            dates.append(curr_date)
            if str(curr_date) == end_date_str:
                continue_to_process = False
            else:
                curr_date = curr_date + one_day
    return dates

def read_json_objects(infile):
    objects = list()
    it = text_file_iterator(infile)
    for i, line in enumerate(it):
        obj = json.loads(line.strip())
        objects.append(obj)        
    return objects

def text_file_iterator(infile):
    # return a line generator that can be iterated with iterate()
    with open(infile, 'rt') as f:
        for line in f:
            yield line.strip()

def write_lines(outfile, lines):
    with open(outfile, 'wt') as out:
        for line in lines:
            out.write(line)
            out.write(os.linesep)
    print('file_written: {}'.format(outfile))

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
        if func == 'create_product_catalog':
            l1_count     = int(sys.argv[2])
            l2_avg_count = int(sys.argv[3])
            l3_avg_count = int(sys.argv[4])
            create_product_catalog(l1_count, l2_avg_count, l3_avg_count)

        elif func == 'create_stores':
            count = int(sys.argv[2])
            create_stores(count)

        elif func == 'create_customers':
            count = int(sys.argv[2])
            create_customers(count)

        elif func == 'create_sales_data':
            start_date = sys.argv[2]
            end_date   = sys.argv[3]
            avg_count_day  = float(sys.argv[4])
            avg_item_count = float(sys.argv[5])
            create_sales_data(start_date, end_date, avg_count_day, avg_item_count)

        else:
            print_options('Error: invalid function: {}'.format(func))
    else:
            print_options('Error: no command-line args entered')
