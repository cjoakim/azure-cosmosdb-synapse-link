#!/bin/bash

# "head" the csv files, for use in PostgreSQL DDL generation
# Chris Joakim, Microsoft, October 2021

echo 'products' > csv_head.txt
head -2 data/wrangled/retail/products.csv   >> csv_head.txt

echo 'customers' >> csv_head.txt
head -2 data/wrangled/retail/customers.csv  >> csv_head.txt

echo 'orders' >> csv_head.txt
head -2 data/wrangled/retail/orders.csv     >> csv_head.txt

echo 'line_items' >> csv_head.txt
head -2 data/wrangled/retail/line_items.csv >> csv_head.txt

echo 'deliveries' >> csv_head.txt
head -2 data/wrangled/retail/deliveries.csv >> csv_head.txt

cat csv_head.txt

echo 'done'
