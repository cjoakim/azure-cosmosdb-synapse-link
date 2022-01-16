#!/bin/bash

# Generate simulated and correlated "ecommerce retail" datasets 
# consisting of customers, orders, line items, and deliveries.
# These are for loading into CosmosDB with the DotnetConsoleApp.
# Chris Joakim, Microsoft, January 2022

mkdir -p data/products

source venv/bin/activate
python --version

python retail_data_gen_v2.py create_product_catalog 12 20 90 
python retail_data_gen_v2.py create_stores 100
python retail_data_gen_v2.py create_customers 10000
python retail_data_gen_v2.py create_sales_data 2020-01-01 2022-01-15 1000 4

# python retail_data_gen_v2.py create_sales_data 2020-12-01 2022-01-15 10 4

echo 'product_catalog:'
head -3 data/products/product_catalog.csv
wc -l   data/products/product_catalog.csv

echo 'stores:'
head -3 data/products/stores.csv
wc -l   data/products/stores.csv

echo 'customers:'
head -3 data/products/customers.csv
wc -l   data/products/customers.csv

echo 'done'
