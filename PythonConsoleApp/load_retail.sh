#!/bin/bash

# Load the generated "ecommerce retail" dataset consisting
# of customers, products, sales, and line items.
# Chris Joakim, Microsoft, January 2022

mkdir -p tmp/
date > tmp/load_times.txt

python main.py load_container demo customers customer_id data/customers.json
python main.py load_container demo products  upc         data/product_catalog.json
python main.py load_container demo stores    store_id    data/stores.json
python main.py load_container demo sales     sale_id     data/sales1.json

date >> tmp/load_times.txt
cat tmp/load_times.txt

# execute during demonstration:
# python main.py load_container demo sales     sale_id     data/sales2.json

python main.py count_documents demo customers
python main.py count_documents demo products
python main.py count_documents demo stores
python main.py count_documents demo sales

echo 'done'
