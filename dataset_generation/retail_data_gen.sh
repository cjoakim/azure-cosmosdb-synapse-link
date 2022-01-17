#!/bin/bash

# Generate simulated and correlated "ecommerce retail" datasets 
# consisting of products, stores, customers, orders, and line items.
# These are for loading into CosmosDB with the DotnetConsoleApp.
# Chris Joakim, Microsoft, January 2022

mkdir -p data/products
rm data/products/*.*

source venv/bin/activate
python --version

python retail_data_gen.py create_product_catalog 12 20 90 
python retail_data_gen.py create_stores 100
python retail_data_gen.py create_customers 10000
python retail_data_gen.py create_sales_data 2021-01-01 2022-01-26 75 3

echo 'creating dataset.zip ...'
zip data/products/dataset.zip data/products/*.*

echo 'copying to ../DotnetConsoleApp/data/ data directory...'
mkdir -p ../DotnetConsoleApp/data/
cp data/products/*.json ../DotnetConsoleApp/data/ 
ls -al ../DotnetConsoleApp/data/

echo 'copying to ../PythonConsoleApp/data/ data directory...'
mkdir -p ../PythonConsoleApp/data/
cp data/products/*.json ../PythonConsoleApp/data/ 
ls -al ../PythonConsoleApp/data/

echo 'product_catalog:'
head -1 data/products/product_catalog.json
wc -l   data/products/product_catalog.json

echo 'stores:'
head -1 data/products/stores.json
wc -l   data/products/stores.json

echo 'customers:'
head -1 data/products/customers.json
wc -l   data/products/customers.json

echo 'sales:'
head -1 data/products/sales.json
wc -l   data/products/sales.json

echo 'done'
