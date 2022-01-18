#!/bin/bash

# Generate simulated and correlated "ecommerce retail" datasets 
# consisting of products, stores, customers, orders, and line items.
# These are for loading into CosmosDB with the DotnetConsoleApp.
# Chris Joakim, Microsoft, January 2022

mkdir -p data/retail
rm data/retail/*.*

source venv/bin/activate
python --version

python retail_data_gen.py create_product_catalog 12 20 90 
python retail_data_gen.py create_stores 100
python retail_data_gen.py create_customers 10000
python retail_data_gen.py create_sales_data 2021-01-01 2022-01-26 75 3

echo 'creating dataset.zip ...'
cd data/retail
rm *.zip
zip dataset.zip *.*
cd ../..

echo 'copying to ../DotnetConsoleApp/data/ data directory...'
mkdir -p ../DotnetConsoleApp/data/
cp data/retail/*.json ../DotnetConsoleApp/data/ 
ls -al ../DotnetConsoleApp/data/

echo 'copying to ../PythonConsoleApp/data/ data directory...'
mkdir -p ../PythonConsoleApp/data/
cp data/retail/*.json ../PythonConsoleApp/data/ 
ls -al ../PythonConsoleApp/data/

echo 'product_catalog:'
head -1 data/retail/product_catalog.json
wc -l   data/retail/product_catalog.json

echo 'stores:'
head -1 data/retail/stores.json
wc -l   data/retail/stores.json

echo 'customers:'
head -1 data/retail/customers.json
wc -l   data/retail/customers.json

echo 'sales:'
head -1 data/retail/sales.json
wc -l   data/retail/sales.json

echo 'done; next steps:'
echo '  1.  edit and execute slice_sales_data.sh'
echo '  2.  execute ./retail_data_zip.sh'
