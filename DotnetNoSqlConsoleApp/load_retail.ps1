#!/bin/bash

# Bulk-load CosmosDB/SQL database with the generated "ecommerce retail" dataset
# consisting of customers, products, sales, and line items.
# Chris Joakim, Microsoft

mkdir -p tmp/
date > tmp/load_times.txt

# dotnet run bulk_load_container retail customers customer_id data/customers.json 9999
# dotnet run bulk_load_container retail products  upc         data/product_catalog.json 9999
# dotnet run bulk_load_container retail stores    store_id    data/stores.json 9999
dotnet run bulk_load_container retail sales     sale_id     data/sales1.json 9999

date >> tmp/load_times.txt
cat tmp/load_times.txt

# execute during demonstration:
# dotnet run bulk_load_container retail sales     sale_id     data/sales2.json 9999

# dotnet run count_documents retail customers
# dotnet run count_documents retail products
# dotnet run count_documents retail stores
dotnet run count_documents retail sales

echo 'done'

# Output with 2022/02/06 dataset:
# Sun Feb  6 11:50:49 EST 2022
# Sun Feb  6 11:56:05 EST 2022
# CountDocuments retail customers -> 10000
# CountDocuments retail products -> 21167
# CountDocuments retail stores -> 100
# CountDocuments retail sales -> 110025
