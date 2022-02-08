#!/bin/bash

# Slice the generated sales.json into two files - one with sales prior
# to 2022-01-26, and one with sales on or after 2022-01-26.
# Chris Joakim, Microsoft, January 2022

infile="data/products/sales.json"
file1="data/products/sales1.json"
file2="data/products/sales2.json"

wc -l $infile  # 100738
head -100538 $infile > $file1
tail -200    $infile > $file2

wc -l $file1
wc -l $file2

echo 'done'
