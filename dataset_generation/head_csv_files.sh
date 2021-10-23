#!/bin/bash

# "head" the csv files, for use in PostgreSQL DDL generation
# Chris Joakim, Microsoft, 2021/10/23

echo 'products' >> csv_head.txt
head -1 data/wrangled/retail/products.csv   >> csv_head.txt

echo 'customers' >> csv_head.txt
head -1 data/wrangled/retail/customers.csv  >> csv_head.txt

echo 'orders' >> csv_head.txt
head -1 data/wrangled/retail/orders.csv     >> csv_head.txt

echo 'line_items' >> csv_head.txt
head -1 data/wrangled/retail/line_items.csv >> csv_head.txt

echo 'deliveries' >> csv_head.txt
head -1 data/wrangled/retail/deliveries.csv >> csv_head.txt

echo 'done'
