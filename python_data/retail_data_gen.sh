#!/bin/bash

# Generate a correlated "ecommerce retail" datasets consisting
# of customers, orders, line items, and deliveries.
# Chris Joakim, Microsoft, 2021/10/05

mkdir -p data/raw/tmp
mkdir -p data/wrangled/retail

rm data/raw/tmp/*.*
rm data/wrangled/retail/customers.json
rm data/wrangled/retail/products.json
rm data/wrangled/retail/orders.json

customer_count=100000

echo 'executing retail_data_gen.py ...'
python retail_data_gen.py gen_retail_data $customer_count

echo 'wc - customers, products, orders:'
cat data/wrangled/retail/customers.json | wc 
cat data/wrangled/retail/products.json | wc 
cat data/wrangled/retail/orders.json | wc 

echo 'creating zip files ...'
cd  data/wrangled/retail
zip customers.json.zip customers.json
zip products.json.zip  products.json
zip orders.json.zip    orders.json
cd  ../../..

echo 'done'

# Output:
# $ ./retail_data_gen.sh
# executing retail_data_gen.py ...
# gen_customer_ids; 100000 created
# file written: data/raw/tmp/customer_ids.json
# gen_customer_addresses; count: 100000, excp_count: 12228
# file written: data/raw/tmp/customer_addresses.json
# file written: data/wrangled/retail/customers.json
# file written: data/wrangled/retail/products.json
# file written: data/wrangled/retail/orders.json
# wc - customers, products, orders:
#    99999 2549978 24457571
#    29549  647373 5684834
#  1049182 26768695 238262577
# creating zip files ...
# updating: customers.json (deflated 78%)
# updating: products.json (deflated 80%)
# updating: orders.json (deflated 84%)
# done
