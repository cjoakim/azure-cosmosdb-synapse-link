#!/bin/bash

# Generate a correlated "ecommerce retail" datasets consisting
# of customers, orders, line items, and deliveries.
# Chris Joakim, Microsoft, 2021/10/23

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

cp *.json ../../../../DotnetConsoleApp/data/
cp *.zip  ../../../../DotnetConsoleApp/data/

cd  ../../..

echo 'done'
