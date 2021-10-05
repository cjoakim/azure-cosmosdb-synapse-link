#!/bin/bash

# Bulk-load the generated "ecommerce retail" dataset consisting
# of customers, products, orders, line items, and deliveries.
# Chris Joakim, Microsoft, 2021/10/05

dotnet run bulk_load_container demo customers na data/customers.json 9999
dotnet run bulk_load_container demo products  na data/products.json 9999
dotnet run bulk_load_container demo orders    na data/orders.json 9999

dotnet run count_documents demo customers
dotnet run count_documents demo products
dotnet run count_documents demo orders

# CountDocuments demo customers -> 100000
# CountDocuments demo products -> 29549
# CountDocuments demo orders -> 1049182

echo 'done'
