#!/bin/bash

# Transform the generated JSON files, for CosmosDB, into CSV equivalents.
# Chris Joakim, Microsoft, 2021/10/23

echo 'removing output csv files ...'
rm data/wrangled/retail/*.csv

echo ''
echo 'products ...'
python retail_data_gen.py json_to_csv product   data/wrangled/retail/products.json  > data/wrangled/retail/products.csv
head -2 data/wrangled/retail/products.csv
wc data/wrangled/retail/products.csv

echo ''
echo 'customers ...'
python retail_data_gen.py json_to_csv customer  data/wrangled/retail/customers.json > data/wrangled/retail/customers.csv
head -2 data/wrangled/retail/customers.csv
wc data/wrangled/retail/customers.csv

echo ''
echo 'orders ...'
python retail_data_gen.py json_to_csv order     data/wrangled/retail/orders.json  > data/wrangled/retail/orders.csv
head -2 data/wrangled/retail/orders.csv
wc data/wrangled/retail/orders.csv

echo ''
echo 'line_items ...'
python retail_data_gen.py json_to_csv line_item data/wrangled/retail/orders.json  > data/wrangled/retail/line_items.csv
head -2 data/wrangled/retail/line_items.csv
wc data/wrangled/retail/line_items.csv

echo ''
echo 'deliveries ...'
python retail_data_gen.py json_to_csv delivery  data/wrangled/retail/orders.json  > data/wrangled/retail/deliveries.csv
head -2 data/wrangled/retail/deliveries.csv
wc data/wrangled/retail/deliveries.csv

echo ''
echo 'done'
