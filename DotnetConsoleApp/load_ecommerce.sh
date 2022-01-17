#!/bin/bash

# Bulk-load the generated "ecommerce retail" dataset consisting
# of customers, products, orders, line items, and deliveries.
# Chris Joakim, Microsoft, January 2022

mkdir -p tmp/
date > tmp/ecomm_load_start_date.txt

dotnet run bulk_load_container demo customers customer_id data/customers.json 9999
dotnet run bulk_load_container demo products  upc         data/product_catalog.json 9999
dotnet run bulk_load_container demo stores    store_id    data/stores.json 9999
dotnet run bulk_load_container demo sales     sale_id     data/sales.json 9999

dotnet run count_documents demo customers
dotnet run count_documents demo products
dotnet run count_documents demo stores
dotnet run count_documents demo sales

date > tmp/ecomm_load_finish_date.txt

echo 'done'
